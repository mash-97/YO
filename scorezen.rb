$global_program_timeout = 3 #seconds
class CProgram
	attr_accessor :folder_path
	attr_accessor :file_name
	attr_accessor :input_file_name
	attr_accessor :output_file_name
	attr_accessor :executable_file_name
	attr_accessor :compiled
	
	def initialize(program_file_path)
		@folder_path = File.dirname(File.realpath(program_file_path))
		
		Dir.chdir(@folder_path) do
			@file_name = File.basename(program_file_path)
			
			@input_file_name = @file_name.sub(File.extname(file_name), ".in")
			File.open(@input_file_name, "w").close()
			
			@output_file_name = @file_name.sub(File.extname(@file_name), ".out")
			File.open(@output_file_name, "w").close()
			
			@executable_file_name = @file_name.sub(File.extname(@file_name), ".o")
			
			puts("For program: #{@file_name}")
			puts("Compiling...")
			self.compile()
			puts("Compiled! ") if @compiled
			puts("Not Compiled! ") if not @compiled
			puts
		end
	end
	
	def run(test_case)
		return false if not @compiled
		Dir.chdir(@folder_path) do
			puts("For program: #{@file_name}")
			puts("Executing...")
			# writing test_case into the .in file
			in_file = File.open(@input_file_name, "w")
			in_file.puts(test_case)
			in_file.close()
			
			#secon run the .o file
			`chmod +x #{@executable_file_name}`
			`./#{@executable_file_name}`
			puts("Executed!")
			puts
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
			regex = /int\s+main\s*\([\s\S]*\)\s*{/
			
			file_codes = File.readlines(@file_name).join()
			file_codes.sub!(regex, codes)
			file = File.open(@file_name, "w")
			file.puts(file_codes)
			file.close()
		end
	end
	
	def compile()
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
		return @compiled
	end
	
end

require 'timeout'

program  = CProgram.new("asma_18115935/nab.c")

begin
	Timeout.timeout($global_program_timeout) do
		s = Time.now
		program.run("5 9 99")
		e = Time.now
	end
rescue Timeout::Error => e
	puts("Program terminated: Time Expired!")
else
	puts("Program is executed without any interruptions in %10.3f seconds\n"%(e-s))
end

