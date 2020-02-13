require("timeout")

class CProgram_Generator

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
			
		end
		self.compile()
	end
	
	def run(test_case, time_limit)
		return false if not @compiled
		
		cwd = File.realpath(Dir.pwd())
		Dir.chdir(@folder_path) do
			puts("\t-->For file: #{File.realpath(@file_name).split(cwd)[1]}")
			puts()
			puts("\t\tExecuting...")
			
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
			puts("\t\tExecuted Successfully in %3.7f seconds."%(@last_se_time))
			puts()
			puts()
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
	
	
	def removeFreopens()
		Dir.chdir(@folder_path) do
			file_code_lines = File.readlines(@file_name).select{|line| not line=~/freopen/}
			
			newl_count = 0
			file_code_lines.select! do
				|line|
				if(line =~ /^\s*?$/) then
					newl_count+=1
				else
					newl_count = 0
				end
				if line=~/^\s*?$/ and newl_count>1 then
					false
				else
					true
				end
			end
			
			file = File.open(@file_name, "w")
			file_code_lines.each{|line|file.puts(line)}
			file.close()
		end
	end
			
			
	
	def compile()
		@compiled = false
		cwd = File.realpath(Dir.pwd())
		Dir.chdir(@folder_path) do 
			puts("\t-->File name: #{File.realpath(@file_name).split(cwd)[1]}")
			puts()
			puts("\t\tCompiling ...")
			
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
			removeFreopens()
		end
		puts("\t\tCompiled!") if @compiled
		puts("\t\t### Failed to compile !!!") if not @compiled
		puts("\n\n")
		return @compiled
	end
	
end

