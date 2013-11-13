require 'socket'
require 'uri'

module RoadRunner::WebServer
  @@server = nil

  def self.web_root
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  def self.requested_file(request_line)
    request_uri = request_line.split(" ")[1]
    path = URI.unescape(URI(request_uri).path)    
  end

  def self.server
    @@server ||= TCPServer.new('localhost', RoadRunner::config("web_server_port"))
  end

  def self.init_server
    loop do
      socket = server.accept
      request_line = socket.gets

      unless request_line.nil?
        file_name = requested_file(request_line)
        
        if file_name == "/roadrunner.js"
          File.open(File.join(web_root, "roadrunner-#{RoadRunner::VERSION}.debug.js"), "rb") do |file|
            socket.print "HTTP/1.1 200 OK\r\n" +
                         "Content-Type: text/javascript\r\n" +
                         "Content-Length: #{file.size}\r\n" +
                         "Connection: close\r\n"

            socket.print "\r\n"
            IO.copy_stream(file, socket)
          end
        else
          message = "File not found\n"

          socket.print "HTTP/1.1 404 Not Found\r\n" +
                       "Content-Type: text/plain\r\n" +
                       "Content-Length: #{message.size}\r\n" +
                       "Connection: close\r\n"

          socket.print "\r\n"
          socket.print message
        end
        socket.close
      end
    end
  end
end