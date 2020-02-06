@folder_path = "asma_18115935/nab"
@file_name = "nab.c"

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

removeFreopens()
