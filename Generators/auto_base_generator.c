#include "lib_helper.h"

int createUserFolder(char *folder_path)
{	
	char command[1000];
	strcpy(command, "mkdir ");
	strcat(command, folder_path);
	
	printf("\nCreating Folder: %s\n", folder_path);
	int result = system(command);
	printf("Result: %d\n", result);
	if(result==-1)
	{
		printf("Failed To Create The Folder: %s!!!\n", folder_path);
		exit(-1);
	}
	else if(result==256)
		printf("Folder Exists Already: %s\n", folder_path);
	else
		printf("Folder Created Successfully: %s\n", folder_path);
	printf("\n");
	return 1;
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
	char file_path[20001];
	
	strcpy(folder_path, user_name);
	strcat(folder_path, "_");
	strcat(folder_path, id);
	
	createUserFolder(folder_path);
	
	// Create files defined in base_files.nms
	FILE * f = fopen("base_files.nms", "r");
	if(f==NULL)
	{
		printf("Failed To Load: base_files.nms!!!\n\n");
		exit(-1);
	}
	else
		printf("Successfully Loaded: base_files.nms!!!\n\n");
	
	printf("Going to create files defined in base_files.nms:: \n");
	char file_name[111];
	while(fscanf(f, " %[^\n]", file_name) != EOF)
	{
		strcpy(file_path, folder_path);
		strcat(file_path, path_sep);
		strcat(file_path, file_name);
		createFile(folder_path, file_name);
	
	fclose(f);
	
	printf("\n\nBase Dir and Files Created Successfully!! o-o\n");
	printf("                                           V");
	return 0;
}
	
	
	
	
	
	
