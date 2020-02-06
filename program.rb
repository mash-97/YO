require_relative("helper")
require_relative("program_type")
require_relative("cprogram_generator")


class Program
	
	attr_accessor :folder_path
	attr_accessor :program_file_path
	
	attr_accessor :execution_time
	
	attr_accessor :attacks_file_path
	attr_accessor :attacks
	
	attr_accessor :program
	attr_accessor :base_program
	
	attr_accessor :owner
	attr_accessor :program_type
	
	def initialize(owner_obj, program_type_obj)
		
		@owner = owner_obj
		@program_type = program_type_obj
		
		@folder_path = @owner.folder_path+"/"+@program_type.folder_name
		
		files = Dir.glob("#{@folder_path}/*")
		
		@program_file_path = files.match( @program_type.program_file_rgx ) != nil ? 
									files.match(@program_type.program_file_rgx)[0] : nil
									
		@attacks_file_path = @folder_path+"/"+ @program_type.attacks_folder_name
		@attacks = {}
		
		files = Dir.glob("#{@attacks_file_path}/*")
		
		files.each do |file_path|
			@attacks[File.basename(file_path)] = file_path
		end
		
		@program = CProgram_Generator.new(@program_file_path) if @program_file_path != nil
		
		@base_program = @program_type.base_program
		
		@execution_time = Float::INFINITY
	end
	
	
	
	def testBaseCases()
		
		test_case = File.readlines( @program_type.base_testcase_file_path ).join()
		
		if not @base_program.run(test_case, @program_type.time_limit) then
			@execution_time = 0.0
			@owner.total_scores += @program_type.basecase_passcore
			return @program_type.basecase_passcore
		end
		
		if not @program.run(test_case, @program_type.time_limit) then
			@execution_time = Float::INFINITY
			return 0.0
		end
		
		@execution_time = @program.last_se_time
		
		if @program.readOutput() == @base_program.readOutput()
			@owner.total_scores += @program_type.basecase_passcore
			return @program_type.basecase_passcore
		else
			@owner.total_scores += 0.0
			@execution_time = Float::INFINITY
			return 0.0
		end		
	end
	
	def startAttacks(players)
		players.each do |player|
			next if player == @owner
			@attacks.each do |id, test_case_file_path|
				if(id=~/\*/ or id.to_i == player.id.to_i) then
					# read test_cases from test_case_file_path
					test_case = File.readlines(test_case_file_path).join()
					
					# run base program
					base_program_runs =  @base_program.run(test_case, @program_type.time_limit)
					
					# if base_program doesn't run @owner surely wins points
					if not base_program_runs then
						@owner.total_scores += @program_type.attack_dosscore
					end
					
					# rabbit should be more carefull, although @owner wins again
					if not player.nab.program.run(test_case, @program_type.time_limit) then
						@owner.total_scores += @program_type.attack_dosscore
						player.total_scores -= @program_type.attack_dosscore
					end
					
					# rabbit's program output needs to be match with base_program's output
					if(base_program_runs and (player.nab.program.readOutput() == @base_program.readOutput())) then
						player.total_scores += @program_type.attack_dosscore
					end
					
					# rabbit beats base programmer
					player.total_scores += @program_type.attack_dosscore if not base_program_runs
				end
			end
		end
	end
	
end

