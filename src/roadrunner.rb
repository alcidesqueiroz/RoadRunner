require 'socket'
require 'yaml'
require_relative '../lib/websocket'
require_relative '../lib/version'
require_relative 'webserver'

module RoadRunner
  def self.root_dir
     Dir.pwd
  end

  def self.config_file
    File.join(root_dir, "roadrunner.yml")
  end

  def self.config key=nil
    @@config ||= YAML.load_file(config_file)["config"]
    parse_config_key key
  end

  def self.parse_config_key key
    return @@config if key.nil?
    key_parts = key.split(/[\.,>]/)
    
    ret = @@config
    key_parts.each do |part|
      ret = ret[part];
    end

    ret
  end

  def self.load_files_to_monitor
    files = config("files")
    @@files_to_monitor = []
    files.each do |path|
      if path.is_a? Array
        relative_path = path[0]
        url_relative_path = path[1]
      else
        relative_path = path
        url_relative_path = path
      end
      
      absolute_path = File.join(root_dir, relative_path)
      file = File.open(absolute_path)
      @@files_to_monitor << {
        :relative_path => relative_path,
        :absolute_path => absolute_path,
        :url_relative_path => url_relative_path,
        :mtime => file.mtime,
        :checksum => calculate_checksum(file)
      }
      file.close
    end
  end

  def self.monitor_files
    load_files_to_monitor
    polling_interval = config("polling_interval")

    strategy = config("change_check_strategy")
    checksum_checker = Proc.new do |file, file_hash| 
      checksum = calculate_checksum(file)

      if checksum != file_hash[:checksum]
        file_hash[:mtime] = Time.now
        file_hash[:checksum] = checksum
        notify_change file, file_hash[:relative_path], file_hash[:url_relative_path]
      end
    end

    mtime_checker = Proc.new do |file, file_hash|
      if file.mtime != file_hash[:mtime]
        file_hash[:mtime] = file.mtime
        notify_change file, file_hash[:relative_path], file_hash[:url_relative_path]
      end
    end

    if strategy == "checksum"
      checker = checksum_checker
    elsif strategy == "modification_time"
      checker = mtime_checker
    else
      raise "Invalid change_check_strategy"
    end

    loop do
      sleep polling_interval
      @@files_to_monitor.each do |file_hash|
        begin
          file = File.open(file_hash[:absolute_path])
          checker.call file, file_hash
          file.close
        rescue
          puts "/!\\ Could not found the file #{file_hash[:absolute_path]} "
        end
      end
    end
  end

  def self.notify_change file, relative_path, url_relative_path
    puts "!!! File '#{file.path}' changed at #{file.mtime}. \nNotification sent to listeners."
    lost_connection = []
    @@sockets.each do |socket|
      begin
        socket.send "{ \"filepath\": \"#{url_relative_path.gsub("\\", "/")}\", \"modified_at\": \"#{file.mtime}\" }"
      rescue 
        lost_connection << socket 
      end
    end
    
    lost_connection.each do |socket|
      @@sockets.delete socket
    end
  end

  def self.init_server
    initialization_message
    @@sockets = []
    Thread.new { RoadRunner::WebServer.init_server }
    Thread.new { monitor_files }
    Thread.abort_on_exception = true

    server = WebSocketServer.new(
              :accepted_domains => ["*"],
              :port => config("live_reload_port"))
    loop do
      server.run do |ws|
        @@sockets << ws
        puts "New connection at #{Time.now.to_s}"
        ws.handshake()
        while data = ws.receive()
          sleep 0.1
        end
      end
    end
  end

  def self.initialization_message
    puts "Starting Roadrunner #{RoadRunner::VERSION} (ctrl-c to exit)"
    puts "RoadRunner Live Reload Server is running on port #{config("live_reload_port")}"
    puts "RoadRunner Simple Web Server is running on port #{config("web_server_port")}"
    puts "Polling for changes..."
  end

  private 

  def self.calculate_checksum file
    Digest::SHA2.file(file).hexdigest
  end 
end