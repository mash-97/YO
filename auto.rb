def copy_directory(source_dir, dest_dir, tabs="")
	if not Dir.exists?(source_dir) then
		puts()
		puts(tabs+"#{source_dir} doesn't exist. So returning... !!!")
		return false
		
	elsif not Dir.exists?(dest_dir) then
		puts()
		puts(tabs+"#{dest_dir} doesn't exist. So trying to create...")
		if not Dir.mkdir(dest_dir) then
			puts(tabs+" failed to create #{dest_dir}. So returning... !!!")
			return false
		end
		puts("created successfully !")
	end
	puts()
	Dir.foreach(source_dir) do |file_name|
		source_file_path = File.join(source_dir, file_name)
		dest_file_path = File.join(dest_dir, file_name)
		
		if not file_name=="." and not file_name==".." then
			if File.file?(source_file_path) then
				puts(tabs+" Copying #{file_name} into #{File.dirname(dest_file_path)}")
				IO.copy_stream(source_file_path, dest_file_path)
				puts(tabs+" Copying complete !")
				puts()
			else
				puts(tabs+" Checking #{file_name}...")
				return false if not copy_directory(source_file_path, dest_file_path, tabs+=" ")
				puts()
			end
		end
	end
	puts()
	return true
end

user_name = ""

while(true) do
	print("user name: ")
	user_name = gets
	exit() if user_name==nil
	user_name.chomp!
	user_name.strip!
	
	next if user_name =~/[^a-zA-Z0-9]/ 
	next if user_name =~/^[0-9]+?/
	next if user_name.length < 2
	break
end
puts()
user_id = ""

while(true) do
	print("ID: ")
	user_id = gets
	exit() if user_id==nil
	user_id.chomp!
	user_id.strip!
	break if user_id =~ /^[0-9]{8,11}$/
	next
end

user_folder_name = user_name+"_"+user_id
puts()
if not copy_directory(".Base", user_folder_name) then
	puts("Failed to create base: #{user_folder_name} !!!")
else
	puts("Successfully created base: #{user_folder_name} !")
end

gets()

	
