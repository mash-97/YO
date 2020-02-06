class Array
	def match(match_against_data)
		self.flatten.each do 
			|e|
			if e.match(match_against_data) then return e.match(match_against_data) end
		end
		return nil
	end
	def removeNilOrZL
		self.each do |s|
			self.delete(s) if s.to_s.length==0
		end
		self
	end
end


def removeFilesWithExtensions(extensions_array)
	regexp = Regexp.new("\.(#{extensions_array.join("|")})$")
	
	# initializing current working directory for the test.
	# removing all files that has a extension from extensions_array
	Dir.entries(".").each{ |e| `rm #{e}` if e=~regexp}
end
