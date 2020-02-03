
class Array
	def match(match_against_data)
		self.flatten.each do 
			|e|
			if e.match(match_against_data) then return e.match(match_against_data) end
		end
		return nil
	end
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
	
	private
	
end

class Attack_Schedeule
	attr_accessor :attacker, :rabbit
	attr_accessor :attack_type
	attr_accessor :test_cases
	
	def initialize(rabbit, attacker, attack_type, testcases)
		@attacker = attacker
		@rabbit = rabbit
		@test_case = testcases
		@attack_type = attack_type.to_s.upcase
	end
end

