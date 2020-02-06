require_relative("player")
require_relative("program_type")
require_relative("cprogram_generator")

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


pds = [{:id=>"18115955", :user_name=>"mash", :folder_path=> "mash_18115955"}, 
		{:id=>"18115935", :user_name=>"asma", :folder_path=>"asma_18115935"}]

players = pds.collect{|pd| Player.new(pd, {:nab => nab_pthash, :projectile =>  projectile_pthash}) }

players.each{|player|
	puts("For player:: #{player.name} : #{player}")
	puts("Testing nab program: ")
	puts("Base Test for nab: #{player.nab.testBaseCases()}")
	puts
	puts("Starting attacks for nab program: ")
	player.nab.attack(players)
	puts("----------------------------------------------------------------")
	
	puts("Testing projectile program: ")
	puts("Base Test for projectile: #{player.projectile.testBaseCases()}")
	puts
	puts("Starting attacks for projectile program: ")
	player.projectile.attack(players)
	puts()
}


puts("Scores: ")
players.each do |player|
	puts("#{player.name}: #{player.total_scores}")
end
