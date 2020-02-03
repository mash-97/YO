class Array
	def match(match_against_data)
		self.flatten.each do 
			|e|
			if e.match(match_against_data) then return e.match(match_against_data) end
		end
		return nil
	end
end


class Nab
	Program_File_rgx = /.*nab\.(c|cpp)$/
	Attack_File_rgx = /.*nab\.atck$/
	
	Base_Test_Cases_File_Path = "Test_Base/nab.test"
	Base_Program_File_Path = "Test_Base/base_nab.cpp"
	
	#                        n             a             b      
	# range is set to 1 to 9*10**18
	Test_Case_rgx = /\s*[0-9]{1,19}\s*[0-9]{1,19}\s*[0-9]{1,19}\s*/
	
	attr_accessor :folder_path
	attr_accessor :program_file_path
	attr_accessor :executable_file_name
	attr_accessor :input_file_name
	attr_accessor :output_file_name
	attr_accessor :total_scores
	attr_accessor :attack_file_path
	attr_accessor :attack_schedeules
	
	def initialize(player_folder_path)
	
		@folder_path = player_folder_path
		
		files = Dir.glob("#{player_folder_path}/*")
		
		@program_file_path = files.match(Program_File_rgx) != nil ? files.match(Program_File_rgx)[0] : nil
		@attack_file_path = files.match(Attack_File_rgx) != nil ? files.match(Attack_File_rgx)[0] : nil
		
		@total_scores = 0.0
		
	end
		
	def testBaseCases(score_factor)
	
		return false if @program_file_path == nil
		removeFilesWithExtensions(['c', 'cpp', 'o', 'out', 'in'])
		
		test_cases = File.readlines(Base_Test_Cases_File_Path).collect{|line| line.strip}.select do
						|line|
						not line.nil? and line!='' and line=~Test_Case_rgx
					end
		
		successfull_hits = 0
		
		test_cases.each do 
			|test_case|
			if runProgramForTestCase(Base_Program_File_Path, test_case) == runProgramForTestCase(@program_file_path, test_case)
				successfull_hits += 1
			end
		end
		
		total_scores += (successfull_hits/test_cases.length)*score_factor
		return total_scores
		
	end
	
	private
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
		
end

		
nab = Nab.new("asma_18115935")
puts(nab.testBaseCases(5))
