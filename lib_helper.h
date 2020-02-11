#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#if defined(_WIN32) || defined(_WIN64) || defined(WIN32)
	#define path_sep "\\"
	#define copy_command "xcopy /e "
#else
	#define path_sep "/"
	#define copy_command "cp -r "

#endif

#define PROJECTILE_ATTACKs_FOLDER_NAME ".Projectile_Attacks"
#define NAB_ATTACKs_FOLDER_NAME ".Nab_Attacks"

int betweenTheseCases(char c, char *cases)
{
	int length = strlen(cases);
	for(int i=0; i<length; i++)
		if(c==cases[i])
			return 1;
	return 0;
}

int betweenAlphabets(char c)
{
	return (c>='A' && c<='Z') || (c>='a' && c<='z') ? 1 : 0;
}
int allIsBetweenAlphabets(char *string, char *special_cases)
{
	int len = (int)strlen(string);
	for(int i=0; i<len; i++)
		if(!betweenAlphabets(string[i]) && !betweenTheseCases(string[i], special_cases))
			return 0;
	return 1;
}

int betweenDigits(char c)
{
	return (c>='0' && c<='9') ? 1 : 0;
}

int allIsBetweenDigits(char *string, char *special_cases)
{
	int len = strlen(string);
	for(int i=0; i<len; i++)
		if(!betweenDigits(string[i]) && !betweenTheseCases(string[i], ""))
			return 0;
	return 1;
}

int betweenLetterDigits(char c)
{
	return (betweenAlphabets(c) || betweenDigits(c)) ? 1 : 0;
}
int allIsBetweenLetterDigits(char *string, char *special_cases)
{
	int len = strlen(string);
	for(int i=0; i<len; i++)
		if(!betweenLetterDigits(string[i]) && !betweenTheseCases(string[i], special_cases))
			return 0;
	return 1;
}

int ifTheresAAlphabet(char *string)
{
	int len = strlen(string);
	for(int i=0; i<len; i++)
		if(betweenAlphabets(string[i]))
			return 1;
	return 0;
}

int checkIfAllIsDigits(char *string)
{
	int length = (int)strlen(string);
	for(int i=0; i<length; i++)
		if(!betweenDigits(string[i]))
			return 0;
	return 1;
}

void delete_unnecessary_spaces(char *string, char *special_cases)
{
	int length = strlen(string);
	int space = 0;
	int i=0, s;
	
	
	for(i=0; string[i] == ' ' && i<length; i++);
	for(s = 0; i<length; i++)
	{
		if(betweenAlphabets(string[i]) || betweenDigits(string[i]) || betweenTheseCases(string[i], special_cases))
		{
			if(!space)	space = 1;
			string[s++] = string[i];
		}
		else if(space)
		{
			space = 0;
			string[s++] = ' ';
		}
	}
	for(i=s-1; string[i]==' ' && i>=0; i--);
	string[i+1] = 0;
}

void lowerify(char *string)
{
	int len = (int)strlen(string);
	for(int i=0; i<len; i++)
		if(string[i]>='A' && string[i]<='Z') string[i] = string[i] - 'A' + 'a';
}

int createFile(char *path)
{
	FILE *result = fopen(path, "w");
	if(result==NULL)
	{
		printf("\tFailed To Create The File: %s !!!\n\n", path);
		exit(-1);
	}
	fclose(result);
	return 1;
}



int createFolder(char *folder_path)
{	
	char command[1000];
	strcpy(command, "mkdir ");
	strcat(command, folder_path);
	
	int result = system(command);
	if(result==-1)
	{
		printf("Failed To Create The Folder: %s !!!\n\n", folder_path);
		exit(-1);
	}
	return 1;
}
