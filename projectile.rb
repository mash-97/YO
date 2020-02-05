require_relative("helper_classes")

class Projectile
	Time_Limit = 1 #s
	BaseCase_PassScore = 5
	Attack_DossScore = 5
	
	Program_File_rgx = /.*projectile\.(c|cpp)$/
	
	Base_Test_Cases_File_Path = ".Test_Base/projectile.test"
	Base_Program_File_Path = ".Test_Base/base_projectile.c"
	
	Attacks_Folder_Name = ".Projectile_Attacks"
	
	BASE_PROGRAM = CProgram.new(Base_Program_File_Path)
	
	attr_accessor :folder_path
	attr_accessor :program_file_path
	
	attr_accessor :execution_time
	
	attr_accessor :attacks_file_path
	attr_accessor :attacks
	
	attr_accessor :program
	attr_accessor :base_program
	
	attr_accessor :owner
	
	def initialize(owner_obj)
		
		@owner = owner_obj
		@folder_path = @owner.folder_path
		
		files = Dir.glob("#{@folder_path}/*")
		
		@program_file_path = files.match(Program_File_rgx) != nil ? files.match(Program_File_rgx)[0] : nil
		@attacks_file_path = @folder_path+"/"+Attacks_Folder_Name
		@attacks = {}
		
		files = Dir.glob("#{@attack_file_path}/*")
		files.each do |file_path|
			@attacks[File.basename(file_path)] = file_path
		end
		
		@program = CProgram.new(@program_file_path) if @program_file_path != nil
		@base_program = BASE_PROGRAM
		
		@execution_time = Float::INFINITY
	end
	
	
	
	def testBaseCases()
		
		return false if not @program.compiled and not @base_program.compiled
		
		test_case = File.readlines(Base_Test_Cases_File_Path).join()
		
		if not @base_program.run(test_case, Time_Limit) then
			@execution_time = 0.0
			@owner.total_scores += BaseCase_PassScore
			return BaseCase_PassScore
		end
		
		if not @program.run(test_case, Time_Limit) then
			@execution_time = Float::INFINITY
		end
		
		@execution_time = @program.last_se_time
		
		if @program.readOutput() == @base_program.readOutput() 
			@owner.total_scores += BaseCase_PassScore
		else
			@owner.total_scores += 0.0
			@execution_time = Float::INFINITY
		end
		
		return @owner.total_scores
		
	end
	
	def attack(players)
		players.each do |player|
			next if player == @owner
			attacks.each do |id, test_case_file_path|
				if(id=~/\.\*/ || id.to_i == player.id.to_i) then
					# read test_cases from test_case_file_path
					test_case = File.readlines(test_case_file_path).join()
					
					# run base program
					base_program_runs =  @base_program.run(test_case, Time_Limit)
					
					# if base_program doesn't run @owner surely wins points
					if not base_program_runs then
						@owner.total_scores += Attack_DossScore
					end
					
					# rabbit should be more carefull, although @owner wins again
					if not player.projectile.program.run(test_case, Time_Limit) then
						@owner.total_scores += Attack_DossScore
						player.total_scores -= Attack_DossScore
					end
					
					# rabbit's program output needs to be match with base_program's output
					if(base_program_runs and (player.projectile.program.readOutput() == @base_program.readOutput())) then
						player.total_scores += Attack_DossScore
					end
					
					# rabbit beats base programmer
					player.total_scores += Attack_DossScore if not base_program_runs
				end
			end
		end
	end
	
	private
	def removeFilesWithExtensions(extensions_array)
		regexp = Regexp.new("\.(#{extensions_array.join("|")})$")
		
		# initializing current working directory for the test.
		# removing all files that has a extension from extensions_array
		Dir.entries(".").each{ |e| `rm #{e}` if e=~regexp}
	end

end

