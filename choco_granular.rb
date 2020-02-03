
def pasteFreopensOnC(file_name)
	codes = "int main()\n{\n\tfreopen('#{file_name.split(/\.(c)|(cpp)$/)[0]}.in', 'r', stdin);\n\tfreopen('#{file_name.split(/\.(c)|(cpp)$/)[0]}.out', 'w', stdout);\n"
	regex = /int\s+main\s*\([\s\S]*\)\s*{/
	
	file_codes = File.readlines(file_name).join()
	file_codes.sub!(regex, codes)
	file = File.open(file_name, "w")
	file.puts(file_codes)
	file.close()
end


	
