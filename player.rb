require_relative("nab")
require_relative("projectile")

class Player
	attr_accessor :name
	attr_accessor :id
	attr_accessor :folder_path
	
	attr_accessor :total_scores
	
	attr_accessor :nab
	attr_accessor :projectile
	attr_accessor :mash
	
	def initialize(pd)
		@id  = pd[:id]
		@name = pd[:user_name]
		@folder_path = pd[:folder_path]
		
		@total_scores = 0.0
		
		@nab = Nab.new(self)
		@projectile = Projectile.new(self)
		@mash = nil
	end
	
end


pds = [{:id=>"18115955", :user_name=>"mash", :folder_path=> "mash_18115955"}, {:id=>"18115935", :user_name=>"asma", :folder_path=>"asma_18115935"}]

players = pds.collect{|pd| Player.new(pd)}

players.each{|player|
	puts("For player: #{player.name}")
	puts("Base Test: #{player.nab.testBaseCases()}")
}
	
