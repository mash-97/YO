require_relative("cprogram_generator")

class Mash
	MASH_PROGRAM = CProgram_Generator.new(File.join(".Test_Base", "mash.cpp"))
	MASH_FOLDER_NAME = "mash"
	MASH_PREF_FILE_PATH = File.join("mash", ".mash.pref")

	
	attr_accessor :owner
	attr_accessor :folder_path
	
	attr_accessor :pref_file_path
	attr_accessor :attacks
	
	
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
		
	end
	
	def start(players)
		players.each do |player|
			# if the @owner is  the player
			next if player == @owner
			print("\n\t\t@attacks: #{@attacks}")
			puts()
			@attacks.each do |id, attack_data_file_path|
				puts("\n\t\t id: #{id}")
				if(id=~/\*/ or id =~ Regexp.new(player.id.to_s)) then
					puts("\n\t\tAttacking to: #{player.id} :: #{player.name}")
					@owner.sendMessage("\n--> Mash -> #{player.id}:#{player.name}\n")
					@owner.sendMessage("\n\t\tPreferences are: ")
					@owner.sendMessage("\n\t\t"+File.readlines(player.mash.pref_file_path).join("\t\t"))
					@owner.sendMessage("\n")
					@owner.sendMessage("\n\t\tAttack values are: ")
					@owner.sendMessage("\n\t\t"+File.readlines(attack_data_file_path).join("\t\t"))
					
					player.sendMessage("\n--> Mash <- #{@owner.id}:#{@owner.name}\n")
					player.sendMessage("\n\t\tYour preferences: ")
					player.sendMessage("\n\t\t"+File.readlines(player.mash.pref_file_path).join("\t\t"))
					player.sendMessage("\n\t\tAttack Values are: ")
					player.sendMessage("\n\t\t"+File.readlines(attack_data_file_path).join("\t\t"))
					player.sendMessage("\n")
					
					if not File.exists?(player.mash.pref_file_path) then
						@owner.sendMessage("\n\t\tDoesn't have any preference file !!!\n")
						player.sendMessage("\t\t\tYou don't have any preference file !!!\n")
						next
					end
					
					# creating test_case from player's mash pref file and @owner's attack file 
					test_case = createMashTestCase( player.mash.pref_file_path, attack_data_file_path )
					
					# if  mash program runs, program should be run
					if MASH_PROGRAM.run(test_case, 10) then
						# fetch result from mash_program
						result = MASH_PROGRAM.readOutput()
						puts("&& ***********> result: #{result}")
						results = result.split(" ").select{|r| r=~/^[a-z_A-Z0-9]+$/}
						puts("&& ***********> results: #{results}")
						
						h_result = {:home=> results[0], :spouse=> results[1], :childrens=> results[2], :luxury => results[3]}
						
						# quantize data except mash
						mash_data_from_result = quantizeMashData(result)
						mash_data_from_attack = quantizeMashData(File.readlines(attack_data_file_path).join())
						mash_data_from_pref = quantizeMashDataFromPrefFile(player.mash.pref_file_path)
						
						puts("&& ************> mash_data_from_result: #{mash_data_from_result}")
						puts("&& ************> mash_data_from_attack: #{mash_data_from_attack}")
						puts("&& ************> mash_data_from_pref: #{mash_data_from_pref}")
						# match values 
						match_value_for_attacker = matchValue(mash_data_from_result, mash_data_from_attack)
						match_value_for_rabbit = matchValue(mash_data_from_result, mash_data_from_pref)
						
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
						writeResults(player, h_result, attack_data_file_path)
						@owner.sendMessage("\n\t\tMatch Value: #{match_value_for_attacker}")
						player.sendMessage("\n\t\tMatch Value: #{match_value_for_rabbit}")
						
					else
						puts("------------------------------------------------------>>>>>")
						puts("#### Mash Program was unabled to run !!!")
						puts("#### Mash Attacker:: id: #{@owner.id}, name: #{@owner.name}")
						puts("#### Mash Rabbit: id: #{player.id}, name: #{player.name}")
						puts()
						@owner.sendMessage("\n\t\t#### Mash Program was unabled to run !!!\n")
						player.sendMessage("\n\t\t#### Mash Program was unabled to run !!!\n")
						
					end
				end
			end
		end
	end
						
					
	protected
	def writeResults(player, hash_results, attack_data_file_path)
		
		@owner.sendMessage("\n\t\tSuccessfully attacked to id: #{player.id}, user_name: #{player.name}")
		@owner.sendMessage("\n\n")
		@owner.sendMessage("\n\t\tResults:: ")
		
		@owner.sendMessage("\n\t\tHome: #{hash_results[:home]}")
		@owner.sendMessage("\n\t\tSpouse: #{hash_results[:spouse]}")
		@owner.sendMessage("\n\t\tChildrens: #{hash_results[:childrens]}")
		@owner.sendMessage("\n\t\tLuxury: #{hash_results[:luxury]}")
		@owner.sendMessage("\n")
		@owner.sendMessage("\n")
		
		player.sendMessage("\n\t\tSays:: ")
		player.sendMessage("\n\t\tHome: #{hash_results[:home]}")
		player.sendMessage("\n\t\tSpouse: #{hash_results[:spouse]}")
		player.sendMessage("\n\t\tChildrens: #{hash_results[:childrens]}")
		player.sendMessage("\n\t\tLuxury: #{hash_results[:luxury]}")
		player.sendMessage("\n")
		player.sendMessage("\n")
		
	end
	
	def quantizeMashData(data)
		rgx = /\s*?([a-z_A-Z0-9]+?)\s+([0-9]+?)\s+?([a-z_A-Z0-9]+)\s*?/
		return data.match(rgx) ? [$~[1], $~[2], $~[3]] : nil
	end
	
	def quantizeMashDataFromPrefFile(file_path)
		rgx = /\s*?[0-9]+?\s+?([a-z_A-Z0-9]+)\s*?/
		
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

		
