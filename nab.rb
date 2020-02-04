require 'timeout'

class Array
	def match(match_against_data)
		self.flatten.each do 
			|e|
			if e.match(match_against_data) then return e.match(match_against_data) end
		end
		return nil
	end
end

class CProgram
	attr_accessor :folder_path
	attr_accessor :file_name
	attr_accessor :input_file_name
	attr_accessor :output_file_name
	attr_accessor :executable_file_name
	attr_accessor :compiled
	attr_accessor :last_se_time
	
	def initialize(program_file_path)
		@folder_path = File.dirname(File.realpath(program_file_path))
		
		Dir.chdir(@folder_path) do
			@file_name = File.basename(program_file_path)
			
			@input_file_name = @file_name.sub(File.extname(file_name), ".in")
			File.open(@input_file_name, "w").close()
			
			@output_file_name = @file_name.sub(File.extname(@file_name), ".out")
			File.open(@output_file_name, "w").close()
			
			@executable_file_name = @file_name.sub(File.extname(@file_name), ".o")

			self.compile()
			
		end
	end
	
	def run(test_case, time_limit)
		return false if not @compiled
		puts("-->For file: #{@file_name}")
		puts("\tExecuting...")
		Dir.chdir(@folder_path) do
		
			# writing test_case into the .in file
			in_file = File.open(@input_file_name, "w")
			in_file.puts(test_case)
			in_file.close()
			
			#secon run the .o file
			`chmod +x #{@executable_file_name}`
			start_time = nil
			end_time =  nil
			begin
				Timeout.timeout(time_limit) do
					start_time = Time.now
					`./#{@executable_file_name}`
					end_time = Time.now
				end
			rescue 
				return false
			end
			@last_se_time = (end_time-start_time)
			puts("\tExecuted in %3.7f seconds\n"%(@last_se_time))
			return true
		end
	end
	
	def readOutput()
		Dir.chdir(@folder_path) do
		
			return false if not File.exists?(@output_file_name)
			return File.readlines(@output_file_name).join()
			
		end
	end
		
	
	protected
	def pasteFreopens()
		Dir.chdir(@folder_path) do
			codes = "int main()\n{\n\tfreopen(\"#{@input_file_name}\", \"r\", stdin);\n\tfreopen(\"#{@output_file_name}\", \"w\", stdout);\n"
			regex = /int\s+main\s*?\([\s\S]*?\)\s*?{/
			
			file_codes = File.readlines(@file_name).join()
			file_codes.sub!(regex, codes)
			file = File.open(@file_name, "w")
			file.puts(file_codes)
			file.close()
		end
	end
	
	def compile()
		puts("-->File name: #{@file_name}")
		puts("\tCompiling ...")
		@compiled = false
		Dir.chdir(@folder_path) do 
			
			#initialize input, output and executable file name
			File.open(@input_file_name, "w").close()
			File.open(@output_file_name, "w").close()
			
			
			# paste freopens codes in the program_file
			self.pasteFreopens()
			
			# deleting @executable_file if exists
			if File.exists?(@executable_file_name) then
				File.delete(@executable_file_name)
			end
			
			# running the .c or .cpp file
			# first compiling with g++
			`g++  #{@file_name} -o #{@executable_file_name}`
			
			@compiled = true if File.exists?(@executable_file_name)
		end
		puts("\tCompiled!\n")
		return @compiled
	end
	
end
		
class Nab
	Time_Limit = 0.1 #s
	Program_File_rgx = /.*nab\.(c|cpp)$/
	Attack_File_rgx = /.*nab\.atck$/
	
	Base_Test_Cases_File_Path = "Test_Base/nab.test"
	Base_Program_File_Path = "Test_Base/base_nab.c"
	
	#                        n             a             b      
	# range is set to 1 to 9*10**18
	Test_Case_rgx = /\s*?[0-9]{1,6}[ ]*?\n+?[0-9]{1,19}\s*[0-9]{1,19}\s*[0-9]{1,19}\s*/
	
	attr_accessor :folder_path
	attr_accessor :program_file_path
	
	attr_accessor :total_scores
	attr_accessor :execution_time
	
	attr_accessor :attack_file_path
	attr_accessor :attack_schedeules
	
	attr_accessor :program
	attr_accessor :base_program
	
	
	def initialize(player_folder_path)
	
		@folder_path = player_folder_path
		
		files = Dir.glob("#{player_folder_path}/*")
		
		@program_file_path = files.match(Program_File_rgx) != nil ? files.match(Program_File_rgx)[0] : nil
		@attack_file_path = files.match(Attack_File_rgx) != nil ? files.match(Attack_File_rgx)[0] : nil
		
		@program = CProgram.new(@program_file_path) if @program_file_path != nil
		@base_program = CProgram.new(Base_Program_File_Path)
		
		@total_scores = 0.0
	end
		
	def testBaseCases(score_factor)
	
		return false if not @program.compiled and not @base_program.compiled
		
		#~ test_cases = File.readlines(Base_Test_Cases_File_Path).collect{|line| line.strip}.select do
						#~ |line|
						#~ not line.nil? and line!='' and line=~Test_Case_rgx
					#~ end
		test_cases = [File.readlines(Base_Test_Cases_File_Path)]
		successfull_hits = 0
		total_hits = 0
		total_execution_time = 0.0
		
		test_cases.each do 
			|test_case|
			
			if not @base_program.run(test_case, Time_Limit)then
				successfull_hits +=1
				next
			end
			
			next if not @program.run(test_case, Time_Limit)
			
			program_output = @program.readOutput()
			bprogram_output = @base_program.readOutput()
			
			# ehehehhhe
			total_hits += 0
			total_execution_time += @program.last_se_time
			# ehehehhe
			
			if program_output == bprogram_output
				successfull_hits += 1
			end
			
		end
		
		@total_scores += (successfull_hits/test_cases.length.to_f)*score_factor
		@execution_time = total_execution_time
		return total_scores
		
	end
	
	private
	def removeFilesWithExtensions(extensions_array)
		regexp = Regexp.new("\.(#{extensions_array.join("|")})$")
		
		# initializing current working directory for the test.
		#removing all files that has a extension from extensions_array
		Dir.entries(".").each{ |e| `rm #{e}` if e=~regexp}
	end

end

		
nab = Nab.new("asma_18115935/nab")
puts(nab.testBaseCases(5))
puts("Average Execution Time: #{"%3.3f seconds"%(nab.execution_time)}")
