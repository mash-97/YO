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
	end
	return $pd
end


def initializen
	checkOutPlayersData()
	file = File.open($pd_yaml, "w")
	print($pd)
	puts
	YAML.dump($pd, file)
	file.close()
end





def pasteFreopensOnC(file_name)
	codes = "int main()\n{\n\tfreopen('#{file_name.split(/\.(c)|(cpp)$/)[0]}.in', 'r', stdin);\n\tfreopen('#{file_name.split(/\.(c)|(cpp)$/)[0]}.out', 'w', stdout);\n"
	regex = /int\s+main\s*\([\s\S]*\)\s*{/
	
	file_codes = File.readlines(file_name).join()
	file_codes.sub!(regex, codes)
	file = File.open(file_name, "w")
	file.puts(file_codes)
	file.close()
end


module YO
	Attack_Schedeule_YAML = "attacks.yaml"
	
	class Attack_Schedeule
		attr_accessor :attacker, :rabbit
		attr_accessor :attack_type
		attr_accessor :test_case
		
		def initialize(rabbit, attacker, attack_type, testcase)
			@attacker = attacker
			@rabbit = rabbit
			@test_case = testcase
			@attack_type = attack_type.to_s.upcase
		end
	end
	
	def keenTestCases(string)
		cases = string.scan(/\([ 0-9]+\)/)
		cases.collect do 
			|kase|
			kase.match(/\(([ 0-9]+)\)/)
			$~[1]
		end
	end
	
	def extractAttackCases(string)
		# Extracting from raw to >[] base
		strings = string.split(/-/).select{|s| s if s=~/>[\s\S]*/}
		
		attack_cases = {}
		strings.each do 
			|s|
			s.match(/>\[([*, a-zA-Z0-9]+)\]([\s\S]*)$/)
			rabbits = $~[1].strip.split(",")
			
			test_cases =  keenTestCases($~[2])
			
			
			if rabbits[0] =~ /\*/ or rabbits.length == 1 then
				attack_cases[rabbits[0].strip] = test_cases
			else
				rabbits.each{|rabbit| attack_cases[rabbit.strip] = test_cases}
			end
		end
		#~ print(attack_cases)
		#~ puts
		return attack_cases
	end
	
	def produceAttackSchedeulesFor(type, attacker, players)
		players.delete(attacker)
		attack_schedeules = []
		
		string = File.readlines(attacker.files[type.to_s.downcase+".atck"]).join()
		attack_cases = extractAttackCases(string)
		
		rabbits = attack_cases.keys
		rabbits.each do 
			|rabbit|
			crammer = ->(arabbit, rabbit_foods){
				rabbit_foods.each{|food| attack_schedeules << Attack_Schedeule.new(arabbit, attacker, type, food)}
			}
			
			if(rabbit=~/\*/) then
				players.each{|arabbit| crammer.call(arabbit, attack_cases[rabbit])}
			else
				players.select{|p| p if p.user_id.to_s =~ Regexp.new(rabbit)}.each{
					|arabbit| 
					crammer.call(arabbit, attack_cases[rabbit])
				}
			end
		end
		return attack_schedeules
	end
	
	class Player
		attr_accessor :files
		attr_accessor :user_name
		attr_accessor :user_id
		attr_accessor :total_scores
		
		def initialize(pd)
			@files = pd[:files]
			@user_id  = pd[:id]
			@user_name = pd[:user_name]
			@total_scores = 0.0
			
			@files.each{|file| pasteFreopensOnC(file) if file=~/\.(c)|(cpp)$/}
		end
			
	end
end

include YO

initializen()
players = checkOutPlayersData().collect{|pd| Player.new(pd)}
players.each{|player| 
	puts("player_name: #{player.user_name}")
}
print(produceAttackSchedeulesFor("nab", players[0], players))
			
		
		
