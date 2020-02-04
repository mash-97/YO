#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#if defined(_WIN32) || defined(_WIN64) || defined(WIN32)
	#define touch "echo .> "
	#define path_sep "\\"
#else
	#define touch "touch "
	#define path_sep "/"
#endif

#define STRING_OPERATIONS_LIB_FILE_NAME "string_operations_lib.h"

#define NAME_CHECK_LENGTH 2

int ntest_cases;
long long int test_cases[100][2];

int betweenAlphabets(char c)
{
	return (c>='A' && c<='Z') || (c>='a' && c<='z') ? 1 : 0;
}

int betweenDigits(char c)
{
	return (c>='0' && c<='9') ? 1 : 0;
}

int betweenTheseCases(char c, char *cases)
{
	int length = strlen(cases);
	for(int i=0; i<length; i++)
		if(c==cases[i])
			return 1;
	return 0;
}

int betweenLetterDigits(char c)
{
	return (betweenAlphabets(c) || betweenDigits(c)) ? 1 : 0;
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

void burnProjectileTestCases(char *tc_file_path)
{
	createFile(tc_file_path);
	FILE *tc_fp = fopen(tc_file_path, "w");
	
	fprintf(tc_fp, "%d\n", ntest_cases);
	for(int i=0; i<ntest_cases; i++)
		fprintf(tc_fp, "%lld %lld\n", test_cases[i][0], test_cases[i][1]);
	
	fclose(tc_fp);
}

void takeTestCases()
{	
	scanf("%d", &ntest_cases);
	
	for(int i=0; i<ntest_cases; i++)
		scanf("%lld %lld", &test_cases[i][0], &test_cases[i][1]);
}

void displayHeader()
{
	printf("---------------------\n");
	printf("| Projectile Attack |\n");
	printf("---------------------\n");
	printf("Attack others by your test cases\n\n");
	
	printf("To attack all:: enter '*'\n");
	printf("Ex:: Attack -> *\n\n");
	
	printf("For individual attack:: enter his/her Valid ID (Without any spaces or '-')\n");
	printf("Ex:: Attack -> 18115955\n\n");
	
	printf("To attack multiple IDs:: enter Valid IDs like: ID1, ID2, ID3 ...\n");
	printf("Ex:: Attack -> 18115955, 18115935, ...\n\n");
	
	printf("Test Case should be like in this format: \n");
	printf("Example 1:         Example 2:\n");
	printf("2                  3\n");
	printf("30 30              35 35\n");
	printf("100 45             46 92\n");
	printf("                   28 93\n");
	
}
	
int main()
{
	displayHeader();
	createFolder("Projectile_Attacks");
	char rabbits[100001];
	char file_path[200001];
	char * token = NULL;
	
	int token_length;
	
	attack_rabbits:
		printf("\n\n------------------------------------\n");
		printf("Attack -> ");
		scanf(" %[^\n]", rabbits);
		
		delete_unnecessary_spaces(rabbits, "*,");
		if(strlen(rabbits)==0)
		{
			printf("\nSeems wrong!!!\n");
			printf("Enter '*' or a ID or for multiple ID, ID, ID..\n");
			printf("For Example: 18115955 or 18115955, 18115935\n");
			goto attack_rabbits;
		}
		
		// make file path
		if(strcmp(rabbits, "exit")==0 || strcmp(rabbits, "quit")==0)
			return 0;
			
		else if(strcmp(rabbits, "*")==0)
		{
			strcpy(file_path, "Projectile_Attacks");
			strcat(file_path, path_sep);
			strcat(file_path, rabbits);
			printf("\nGive your nab test cases for all:\n\n");
			takeTestCases();
			burnProjectileTestCases(file_path);
		}
		else
		{
			printf("\nGive your nab test cases: \n\n");
			takeTestCases();
			
			token = strtok(rabbits, " ,");
			while(token!=NULL)
			{
				token_length = (int)strlen(token);
				if(!checkIfAllIsDigits(token) || token_length<8 || token_length>9)
				{
					printf("%s seems not correct, so not taken !!!\n", token);
					printf("If you insist for it contact with Mash :D\n\n");
				}
				else
				{
					strcpy(file_path, "Projectile_Attacks");
					strcat(file_path, path_sep);
					strcat(file_path, token);
					burnProjectileTestCases(file_path);
				}
				token = strtok(NULL, " ,");
			}
		}
		printf("\nYo! Test Cases taken successfully!\n\n\a");
	goto attack_rabbits;	
	
	return 0;
}

