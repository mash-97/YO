require_relative("cprogram_generator")

class Mash
	MASH_PROGRAM = CProgram_Generator.new(".Test_Base/mash.cpp")
	MASH_FOLDER_NAME = "mash"
	MASH_PREF_FILE_PATH = "mash/.mash.pref"
	MASH_RESULTS_FILE_PATH = "mash/mash.results"
	MASH_ATTACKS_RESULTS_FILE_PATH = "mash/mash_attack.results"
	
	attr_accessor :owner
	attr_accessor :folder_path
	
	attr_accessor :pref_file_path
	attr_accessor :attacks
	
	attr_accessor :results_file_path
	attr_accessor :attacks_results_file_path
	
	
	def initialize(owner_obj)
		@owner = owner_obj
		
		@folder_path = File.join( @owner.folder_path, MASH_FOLDER_NAME )
		@pref_file_path = File.join( @owner.folder_path, MASH_PREF_FILE_PATH )
		
		# keen out attack list from the @folder_path
		@attacks = {}
		Dir.glob("#{@folder_path}/.*").each do |file_path|
			fbn = File.basename(file_path)
			@attacks[fbn] =  file_path if (fbn=~/^\.\*$/ or fbn=~/^\.[0-9]+?$/)
		end
		
		@results_file_path = File.join( @owner.folder_path, MASH_RESULTS_FILE_PATH )
		# initialize the results file path
		File.open(@results_file_path, "a+").close()
		
		@attacks_results_file_path = File.join( @owner.folder_path, MASH_ATTACKS_RESULTS_FILE_PATH )
		
	end
	
	def start(players)
		players.each do |player|
			# if the @owner is  the player
			next if player == @owner
			
			@attacks.each do |id, attack_data_file_path|
			
				if(id=~/\*/ or id.to_i == player.id.to_i) then
					# if player doesn't have  prefs
					if not File.exists?(player.mash.pref_file_path) then
						owner_ar_file = File.open(@attacks_results_file_path, "a+")
						owner_ar_file.puts("--> Attack to id: #{player.id}, user_name: #{player.name}")
						owner_ar_file.puts("#{player.name} doesn't have any preference !")
						owner_ar_file.puts("\n")
						owner_ar_file.puts("\n")
						owner_ar_file.close()
						break
					end
						
					# creating test_case from player's mash pref file and @owner's attack file 
					test_case = createMashTestCase( player.mash.pref_file_path, attack_data_file_path )
					
					# if  mash program runs, program should be run
					if MASH_PROGRAM.run(test_case, 10) then
						# fetch result from mash_program
						result = MASH_PROGRAM.readOutput()
						results = result.split(" ").select{|r| r=~/^[a-z_A-Z0-9]+$/}
						h_result = {:home=> results[0], :spouse=> results[1], :childrens=> results[2], :luxury => results[3]}
						
						# quantize data except mash
						mash_data_from_result = quantizeMashData(result)
						mash_data_from_attack = quantizeMashData(File.readlines(attack_data_file_path).join())
						mash_data_from_pref = quantizeMashDataFromPrefFile(player.mash.mash_pref_file_path)
						
						# match values 
						match_value_for_attacker = matchValue(mash_data_from_result, mash_data_from_attack)
						match_value_for_rabbit = matchValue(mash_data_from_pref)
						
						# here @owner is like an attacker
						# and player is like a rabbit
						# @owner points giving will be like: how much match does his data with the result
						@owner.total_scores += match_value_for_attacker
						# player points giving will be like: how much match does his data with the result too
						player.total_scores += match_value_for_rabbit
						
						# each player should get 1 extra point for play this game
						@owner.total_scores += 1
						player.total_scores += 1
						
						# send readable results to both party
						writeResults(player, h_result)
					else
						puts("------------------------------------------------------>>>>>")
						puts("#### Mash Program was unabled to run !!!")
						puts("#### Mash Attacker:: id: #{@owner.id}, name: #{@owner.name}")
						puts("#### Mash Rabbit: id: #{player.id}, name: #{player.name}")
						puts()
					end
				end
			end
		end
	end
						
					
	protected
	def witeResults(player, hash_results)
		# burn readable result into owner's attacks_file_path
		owner_ar_file = File.open(@attacks_results_file_path, "a+")
		owner_ar_file.puts("--> Successfully attacked to id: #{player.id}, user_name: #{player.name}")
		owner_ar_file.puts("Attacked value was:: ")
		owner_ar_file.puts(File.readlines(attack_data_file_path).join())
		owner_ar_file.puts("\n")
		owner_ar_file.puts("Results:: ")
		
		owner_ar_file.puts("\tHome: #{hash_result[:home]}")
		owner_ar_file.puts("\tSpouse: #{hash_result[:spouse]}")
		owner_ar_file.puts("\tChildrens: #{hash_result[:childrens]}")
		owner_ar_file.puts("\tLuxury: #{hash_result[:luxury]}")
		owner_ar_file.puts("\n")
		owner_ar_file.puts("\n")
		owner_ar_file.close()
		
		# burn readable result  into player's results file path
		player_r_file = File.open(player.mash.results_file_path, "a+")
		player_r_file.puts("--> Attack from id: #{@owner.id}, user_name: #{@owner.name}")
		player_r_file.puts("Says:: ")
		player_r_file.puts("\tHome: #{hash_result[:home]}")
		player_r_file.puts("\tSpouse: #{hash_result[:spouse]}")
		player_r_file.puts("\tChildrens: #{hash_result[:childrens]}")
		player_r_file.puts("\tLuxury: #{hash_result[:luxury]}")
		player_r_file.puts("\n")
		player_r_file.puts("\n")
		player_r_file.close()
	end
	
	def quantizeMashData(data)
		rgx = /\s*?([a-z_A-Z0-9]+?)\s*([0-9]+?)\s*?([a-z_A-Z0-9]+)\s*?/
		return data.match(rgx) ? [$~[1], $~[2], $~[3]] : nil
	end
	
	def quantizeMashDataFromPrefFile(file_path)
		rgx = /\s*?[0-9]+?\s*([a-z_A-Z0-9]+)\s*?/
		
		results = []
		File.readlines(file_path).each do |line|
			results << $~[1] if line.match(rgx)
		end
		return results
	end
		
	def matchValue(sarray_1, sarray_2)
		match_value = 0
		sarray_1.each do |sa1|
			sarray_2.each do |sa2|
				match_value += 1 if sa1.strip.downcase == sa2.strip.downcase
			end
		end
		return match_value
	end
	
	def createMashTestCase(pref_file_path, attack_data_file_path)
		pref  = File.readlines(pref_file_path).join()
		ads = File.readlines(attack_data_file_path).join()
		return [pref, ads].join("\n")
	end
end

		
