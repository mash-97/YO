#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "string_operations_lib.h"

#if defined(_WIN32) || defined(_WIN64) || defined(WIN32)
	#define touch "echo .> "
	#define path_sep "\\"
#else
	#define touch "touch "
	#define path_sep "/"
#endif

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

int createFile(char *folder_name, char *file_name)
{
	char path[1000];
	strcpy(path, folder_name);
	strcat(path, path_sep);
	strcat(path, file_name);
	
	printf("\n\tCreating File: %s\n", path);
	FILE *result = fopen(path, "w");
	if(result==NULL)
	{
		printf("\tFailed To Create The File: %s\n", file_name);
		exit(-1);
	}
	printf("\tFile Created Successfully: %s\n", file_name);
	printf("\n");
	fclose(result);
	return 1;
}

int main()
{
	char user_name[40];
	char id[10];
	
	get_user_name:
		printf("Enter valid user name (without any space): ");
		scanf(" %s", user_name);
		delete_unnecessary_spaces(user_name);
		lowerify(user_name);
		printf("### user_name: %s\n", user_name);
		if(!check_name(user_name))
			goto get_user_name;
	
	printf("\n");
	get_id:
		printf("Enter your id (without any '-' or space): ");
		scanf(" %s", id);
		delete_unnecessary_spaces(id);
		printf("### user_id: %s\n", id);
		if(!check_name(user_name))
			goto get_id;
	
	// make user_id folder
	char folder_path[110];
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
		createFile(folder_path, file_name);
	
	fclose(f);
	
	printf("\n\nBase Dir and Files Created Successfully!! o-o\n");
	printf("                                           V");
	return 0;
}
	
	
	
	
	
	
