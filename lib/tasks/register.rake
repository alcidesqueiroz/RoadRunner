task :register_roadrunner do 
	ruby_path = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')
	ruby_dir = File.dirname(ruby_path)
	distr_files_dir = File.expand_path(File.join(File.dirname(__FILE__), "../../distr" ))
	roadrunner_root_path = File.expand_path(File.join(File.dirname(__FILE__), "../.." ))

	FileUtils.cp(File.join(distr_files_dir, "roadrunner"), ruby_dir)
	FileUtils.cp(File.join(distr_files_dir, "roadrunner.bat"), ruby_dir)

	compass_loader_path = File.join(ruby_dir, "roadrunner")
	compass_bat_path = File.join(ruby_dir, "roadrunner.bat")

	compass_loader_file_text = File.read(compass_loader_path)
							   .gsub(/{RUBY_PATH}/, ruby_path)
							   .gsub(/{ROADRUNNER_ROOT_PATH}/, roadrunner_root_path)

	compass_bat_file_text = File.read(compass_bat_path)
							.gsub(/{ROADRUNNER_LOADER}/, compass_loader_path)

	File.open(compass_loader_path, "w") { |file| file << compass_loader_file_text }
	File.open(compass_bat_path, "w") { |file| file << compass_bat_file_text }

	#`echo #{File.dirname(__FILE__)} >> d:\\projects\\roadrunner\\teste`
end