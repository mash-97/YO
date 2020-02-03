def removeFilesWithExtensions(extensions_array)
		regexp = Regexp.new("\.(#{extensions_array.join("|")})$")
		
		# initializing current working directory for the test.
		#removing all files that has a extension from extensions_array
		Dir.entries(".").each{ |e| `rm #{e}` if e=~regexp}
	end

	def pasteFreopensIn(file_name, input_file_name, output_file_name)
		codes = "int main()\n{\n\tfreopen(\"#{input_file_name}\", \"r\", stdin);\n\tfreopen(\"#{output_file_name}\", \"w\", stdout);\n"
		regex = /int\s+main\s*\([\s\S]*\)\s*{/
		
		file_codes = File.readlines(file_name).join()
		file_codes.sub!(regex, codes)
		file = File.open(file_name, "w")
		file.puts(file_codes)
		file.close()
	end

	def runProgramForTestCase(program_file_path,  test_case)
		puts("program_file_path: #{program_file_path}, test_case: #{test_case}")
		#initialize input, output and executable file name
		input_file_name = File.basename(program_file_path.sub(File.extname(program_file_path), ".in"))
		File.open(input_file_name, "w").close()
		
		output_file_name = File.basename(program_file_path.sub(File.extname(program_file_path), ".out"))
		File.open(output_file_name, "w").close()
		
		executable_file_name = File.basename(program_file_path.sub(File.extname(program_file_path), ".o"))
		
		# writing test_case into the .in file
		in_file = File.open(input_file_name, "w")
		in_file.puts(test_case)
		in_file.close()
		
		# copy .c or .cpp into the current working directory
		`cp #{File.realpath(program_file_path)} .`
		
		# paste freopens codes in the program_file
		pasteFreopensIn(File.basename(program_file_path), input_file_name, output_file_name)
		
		# running the .c or .cpp file
		# first compiling with g++
		puts("Compiling... ")
		`g++  #{File.realpath(program_file_path)} -o #{executable_file_name}`
		
		#secon run the .o file
		puts("Executing... ")
		`chmod +x #{executable_file_name}`
		`./#{executable_file_name}`
		puts("Executed!\n")
		return File.readlines(output_file_name).join()
	end
		

removeFilesWithExtensions(['c', 'cpp', 'o', 'out', 'in'])
puts runProgramForTestCase("Test_Base/base_nab.cpp", "5 111 311")

class A
	Ab = 3
	def ab
		Ab
	end
end

print File.readlines("nab.rb").collect{|lines| lines.strip}.select(&->(s){not s.nil? and s!=''})
puts
