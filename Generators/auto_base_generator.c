#include "lib_helper.h"
#define base ".Base"
#define nab "nab"
#define projectile "projectile"
#define mash "mash"

void copyDependencies(char *folder_path)
{
	char command[10001];
	
	// .Base/mash
	strcpy(command, copy_command);
	strcat(command, base);
	strcat(command, path_sep);
	strcat(command, mash);
	strcat(command, " ");
	strcat(command, folder_path);
	strcat(command, copy_commands_attribute);
	system(command);
	
	// .Base/projectile
	strcpy(command, copy_command);
	strcat(command, base);
	strcat(command, path_sep);
	strcat(command, projectile);
	strcat(command, " ");
	strcat(command, folder_path);
	strcat(command, copy_commands_attribute);
	system(command);
	
	// .Base/nab
	strcpy(command, copy_command);
	strcat(command, base);
	strcat(command, path_sep);
	strcat(command, nab);
	strcat(command, " ");
	strcat(command, folder_path);
	strcat(command, copy_commands_attribute);
	system(command);
}

int main()
{
	char user_name[40];
	char id[10];
	
	get_user_name:
		printf("Enter valid user name (without any space): ");
		scanf(" %s", user_name);
		delete_unnecessary_spaces(user_name, "");
		lowerify(user_name);
		printf("### user_name: %s\n", user_name);
		if(!allIsBetweenLetterDigits(user_name, ""))
			goto get_user_name;
	
	printf("\n");
	get_id:
		printf("Enter your id (without any '-' or space): ");
		scanf(" %s", id);
		delete_unnecessary_spaces(id, "");
		printf("### user_id: %s\n", id);
		if(!allIsBetweenDigits(id, ""))
			goto get_id;
	
	// make user_id folder
	char folder_path[61];
	
	strcpy(folder_path, user_name);
	strcat(folder_path, "_");
	strcat(folder_path, id);
	
	createFolder(folder_path);
	
	copyDependencies(folder_path);
	
	printf("\n\nBase Dir and Files Created Successfully!! o-o\n");
	printf("                                           V");
	return 0;
}
	
	
	
	
	
	
