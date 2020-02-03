require 'yaml'

$pd_yaml = "players.yaml"
$base_files = File.readlines("base_files.nms").select{|l| l!=nil and l.strip!=""}.collect{|line| line.strip}.compact
$base_files_regexps = File.readlines("base_files.regexps").select{|l| l!=nil and l.strip!=""}.collect{|line| Regexp.new(line.strip)}
$pd = []

class Array
	def match(match_against_data)
		self.flatten.each do 
			|e|
			if e.match(match_against_data) then return e.match(match_against_data) end
		end
		return nil
	end
end

def checkOutPlayersData()

	user_folders = Dir.glob("*").select{|d| File.directory?(d) and d=~/[a-zA-Z]{2,}_[0-9]{8,}/}
	
	user_folders.each do 
		|u| 
		id = u.split("_")[1]
		user_name = u.split("_")[0]
		
		#~ puts("Id: #{id}, User_name: #{user_name}")
		pd_hash = {:user_name=> user_name, :id=> id}
		pd_hash[:files] = Dir.entries(u).select{|e| e!="." and e!=".." and $base_files_regexps.match(e)}.collect{|e| [e, u+"/"+e]}
		$pd << pd_hash
		#~ $base_files_regexps.each do 
			#~ |regexp| 
			#~ if not ($pd[id][:files].match(regexp)) then
				#~ puts("\tuser_name: #{user_name} lacks #{regexp}")
			#~ end
		#~ end
		return $pd
	end
	
end


def initializen
	checkOutPlayersData()
	file = File.open($pd_yaml, "w")
	YAML.dump($pd, file)
	file.close()
end

