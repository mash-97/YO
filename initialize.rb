require 'yaml'

def checkOutPlayersData()

	user_folders = Dir.glob("*").select{|d| File.directory?(d) and d=~/^[a-zA-Z]{2,}_[0-9]{8,}$/}
	users_data = []
	user_folders.each do 
		|u| 
		id = u.split("_")[1]
		name = u.split("_")[0]
		
		ud_hash = {:name=> name, :id=> id}
		
		users_data << ud_hash
	end
	return users_data
end

print(checkOutPlayersData())
