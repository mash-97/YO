require("yaml")

puts("YOH !")
puts("Waxxup !!!")
puts("----------> Initializing.")

require_relative("player")
require_relative("program_type")
require_relative("cprogram_generator")


def checkOutPlayersData()

	user_folder_paths = Dir.glob("*").select{|d| File.directory?(d) and d=~/^[a-zA-Z]{2,}_[0-9]{8,}$/}
	users_data = []
	user_folder_paths.each do 
		|folder_paths| 
		id = folder_paths.split("_")[1]
		name = folder_paths.split("_")[0]
		
		ud_hash = {:name=> name, :id=> id, :folder_path => folder_paths}
		
		users_data << ud_hash
	end
	return users_data
end

nab_pthash = {

							:program_name => "nab",
							:time_limit => 2,
							:basecase_passcore => 5,
							:attack_dosscore =>5,
							
							:folder_name => "nab",
							:attacks_folder_name => ".Nab_Attacks",
							:program_file_rgx => /^.*?nab\.(c|cpp)$/,
							:base_testcase_file_path => ".Test_Base/nab.tc",
							:base_program => CProgram_Generator.new(".Test_Base/base_nab.c")
}
				
projectile_pthash = {

							:program_name => "projectile",
							:time_limit => 2,
							:basecase_passcore => 5, 
							:attack_dosscore => 5,
							
							:folder_name => "projectile",
							:program_file_rgx => /^.*?projectile\.(c|cpp)$/,
							:attacks_folder_name => ".Projectile_Attacks",
							
							:base_testcase_file_path => ".Test_Base/projectile.tc",
							:base_program => CProgram_Generator.new(".Test_Base/base_projectile.c")
}


players_data = checkOutPlayersData()
players = players_data.collect{|pd_hash| Player.new(pd_hash, {:nab => nab_pthash, :projectile =>  projectile_pthash}) }

puts("\n----------> Initializing Complete !")
puts()
puts()
puts("Schedeuling Base Tests and Attacks. . .")
puts()
players.each do |player|
	puts("----------------------------------------------------------------------")
	puts("----------------------------------------------------------------------")
	puts("Player Name: #{player.name} :: ID: #{player.id}")
	puts()
	puts()
	puts("\tStarting NAB Schedeule:")
	puts("\t--------> Checking existency of the NAB program: #{player.nab.program!=nil ? true : false}")
	
	if player.nab.program != nil and player.nab.program.compiled then
		puts("\t--------> Testing the NAB for base test cases: ")
		puts()
		points = player.nab.testBaseCases()
		puts("\t--------> #{player.name}'s NAB program executed with  #{points} point(s)")
		puts()
		puts("\t--------> Starting Attack method: ")
		player.nab.startAttacks(players)
		puts()
		puts()
		puts("\t-------->NAB Schedeule is finished!")
		puts()
		
	else
		if not player.nab.program.compiled then
			puts("\t========> #{player.name}'s NAB program wasn't compiled !!!")
		else
			puts("\t########> #{player.name} doesn't have the NAB program")
		end
	end

	puts("\tLeaving NAB Schedeule")
	puts()
	puts("\tAt this point #{player.name}'s total score is: #{player.total_scores}")
	puts()
	puts()
	puts("\tStarting Projectile Schedeule:")
	puts("\t--------> Checking existency of the Projectile program: #{player.projectile.program!=nil ? true : false}")
	
	if player.projectile.program != nil and player.projectile.program.compiled then
		puts("\t--------> Testing the Projectile for base test cases: ")
		points = player.projectile.testBaseCases()
		puts("\t--------> #{player.name}'s Projectile program executed with  #{points} point(s)")
		puts()
		puts("\t--------> Starting Attack method: ")
		player.projectile.startAttacks(players)
		puts()
		puts()
		puts("\t-------->Projectile Schedeule is finished!")
		puts()
		
		
	else
		if not player.nab.program.compiled then
			puts("\t========> #{player.name}'s Projectile program wasn't compiled !!!")
		else
			puts("\t########> #{player.name} doesn't have the Projectile program")
		end
	end
	puts("\tLeaving Projectile")
	puts()
	puts("\tAt this point #{player.name}'s total score is: #{player.total_scores}")
	puts()
	puts()
	puts("\t%%%%%%%%> OH! FOOO I'M SO TIRED TO GET THIS WORK DONE!!!")
	puts("\t********> DUDE! YOU ARE COMPUTER PROGRAM -_-")
	puts()
	puts()
	puts("\tStarting MASH Schedeule:")
	player.mash.start(players)
	puts("\t-------->Leaving MASH Schedeule without any further notices !")
	puts()
	puts()
	puts("At the end of general schedeules #{player.name}'s total score is : #{player.total_scores}")
	puts()
	puts()
end


players.sort! do |x,y| 
	if (x.total_scores<=>y.total_scores)==0 then
		x.total_execution_time <=> y.total_execution_time
	else
		x.total_scores<=>y.total_scores
	end
end

puts()
puts()
puts("Player's stands:: ")
count = 0
players.each do |player|
	count += 1
	puts("#{count}: #{player.name}, #{player.id}, #{player.total_scores}")
	puts()
end


