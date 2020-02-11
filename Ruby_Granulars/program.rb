require_relative("helper")
require_relative("program_type")
require_relative("cprogram_generator")


class Program
	
	attr_accessor :folder_path
	attr_accessor :program_file_path
	
	attr_accessor :attacks_file_path
	attr_accessor :attacks
	
	attr_accessor :program
	attr_accessor :base_program
	
	attr_accessor :owner
	attr_accessor :program_type
	attr_accessor :program_sym
	
	def initialize(owner_obj, program_type_obj)
		
		@owner = owner_obj
		@program_type = program_type_obj
		
		@folder_path = File.join( @owner.folder_path, @program_type.folder_name)
		
		files = Dir.glob("#{@folder_path}#{File::SEPARATOR}*")
		
		@program_file_path = files.match( @program_type.program_file_rgx ) != nil ? 
									files.match(@program_type.program_file_rgx)[0] : nil
									
		@attacks_file_path = File.join( @folder_path, @program_type.attacks_folder_name)
		@attacks = {}
		
		files = Dir.glob("#{@attacks_file_path}#{File::SEPARATOR}*")
		
		files.each do |file_path|
			@attacks[File.basename(file_path)] = file_path
		end
		
		@program = CProgram_Generator.new(@program_file_path) if @program_file_path != nil
		@program_sym = @program_type.program_sym
		@base_program = @program_type.base_program
		
	end
	
	
	
	def testBaseCases()
		@owner.sendMessage("\n--> #{@program_type.program_name}: Testing For Base Test Cases.\n") 
		test_case = File.readlines( @program_type.base_testcase_file_path ).join()
		
		if not @base_program.run(test_case, @program_type.time_limit) then
			@owner.sendMessage("\n\t\tTesting Haulted ! :: Base Program is unable to run !\n")
			return false
		end
		
		if not @program.run(test_case, @program_type.time_limit) then
			@owner.sendMessage("\n\t\tTesting Haulted ! :: Your #{@program_type.program_name} is unable to run!\n")
			return false
		end
		
		if @program.readOutput() == @base_program.readOutput()
			@owner.sendMessage("\n\t\tSuccessfully Passed !\n")
			@owner.total_scores += @program_type.basecase_passcore
			
		else
			@owner.sendMessage("\t\t\tHacked !\n")
		end		
		return true
	end
	
	def startAttacks(players)
	
		players.each do |player|
			next if player == @owner
			next if player.programs[@program_sym].program == nil 
			next if not player.programs[@program_sym].program.compiled
			
			@attacks.each do |rabbit_id, attack_case_file_path|
				
				# if the attack is for everyone or for this player.
				if(rabbit_id=~/\*/ or rabbit_id.to_i == player.id.to_i) then
					
					@owner.sendMessage("\n-->  #{@program_type.program_name} -> (#{player.id}:#{player.name})\n")
					player.sendMessage("\n-->  #{@program_type.program_name} <- #{@owner.id}:#{@owner.name}\n")
					player.sendMessage("\n\t\tTest Case Path: #{attack_case_file_path}\n")
					
					
					# read test_cases from attack_case_file_path
					test_case = File.readlines(attack_case_file_path).join()
					
					
					# if base_program doesn't run, @owner surely wins points
					if not @base_program.run(test_case, @program_type.time_limit) then
						@owner.sendMessage("\n\t\tHaulted ! :: unable to run base program\n")
						player.sendMessage("\n\t\tHaulted ! :: unable to run base program\n")
						next
					end
					
					# rabbit program doesn't run.
					if not player.programs[@program_sym].program.run(test_case, @program_type.time_limit) then
						@owner.sendMessage("\n\t\tHaulted ! :: (#{player.id}:#{player.name}) 's #{@program_type.program_name} unable to run!")
						player.sendMessage("\n\t\tHaulted ! :: unable to run your #{@program_type.program_name}")
						next
					end
					
					# rabbit's program output needs to be match with base_program's output
					if player.programs[@program_sym].program.readOutput() == @base_program.readOutput() then
						player.total_scores += @program_type.attack_dosscore
						player.sendMessage("\n\t\tSuccessfully Passed !\n")
						@owner.sendMessage("\n\t\tDefended !!!\n")
					else
						@owner.total_scores += @program_type.attack_dosscore
						player.sendMessage("\n\t\tHacked !!!\n")
						@owner.sendMessage("\n\t\tSuccessfull Hits !\n")
					end
					
				end
			end
		end
	end
	
end

