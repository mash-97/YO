require("yaml")

puts("YOH !")
puts("Waxxup !!!")
puts("----------> Initializing.")

require_relative("Ruby_Granular/player")
require_relative("Ruby_Granular/program_type")
require_relative("Ruby_Granular/cprogram_generator")


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
							:time_limit => 1,
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
	puts("\t--------> Checking existency of the NAB program: #{player.programs[:nab].program!=nil ? true : false}")
	
	if player.programs[:nab].program != nil and player.programs[:nab].program.compiled then
		puts("\t--------> Testing the NAB for base test cases: ")
		puts()
		tested = player.programs[:nab].testBaseCases()
		puts("\t--------> #{player.name}'s NAB program tested") if tested
		puts("\t--------> #{player.name}'s NAB program is not tested !!!") if not tested
		puts()
		puts("\t--------> Starting Attack method: ")
		player.programs[:nab].startAttacks(players)
		puts()
		puts()
		puts("\t-------->NAB Schedeule is finished!")
		puts()
		
	else
		if player.programs[:nab].program != nil and not player.programs[:nab].program.compiled then
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
	puts("\t--------> Checking existency of the Projectile program: #{player.programs[:projectile].program!=nil ? true : false}")
	
	if player.programs[:projectile].program != nil and player.programs[:projectile].program.compiled then
		puts("\t--------> Testing the Projectile for base test cases: ")
		tested = player.programs[:projectile].testBaseCases()
		puts("\t--------> #{player.name}'s Projectile program is tested") if tested
		puts("\t--------> #{player.name}'s Projectile program is not tested !!!") if not tested
		puts()
		puts("\t--------> Starting Attack method: ")
		player.programs[:projectile].startAttacks(players)
		puts()
		puts()
		puts("\t-------->Projectile Schedeule is finished!")
		puts()
		
		
	else
		if not player.programs[:projectile].program.compiled then
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
	puts("\t********> DUDE! YOU ARE A COMPUTER PROGRAM -_-")
	puts()
	puts()
	puts("\tStarting MASH Schedeule:")
	player.mash.start(players)
	puts("\tLeaving MASH Schedeule without any further notices !")
	puts()
	puts()
	puts("At the end of general schedeules #{player.name}'s total score is : #{player.total_scores}")
	puts()
	puts()
end


players.sort! do |x,y| 
	y.total_scores <=> x.total_scores
end

puts()
puts()
puts("Player's stands:: ")
i = 0
players.each do |player|
	i+=1
	puts("#{i}: #{player.id}: #{player.name} ===> #{player.total_scores}")
	player.sendMessage("\n\n========================= Results ============================\n\n")
	count = 0
	players.each { 
		|p| 
		count+=1
		player.sendMessage("#{count}:: #{p.id} : #{p.name}")
	}
end


