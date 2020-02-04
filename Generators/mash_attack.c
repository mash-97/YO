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


char spouse_name[40];
char luxury_item[40];
int number_of_childrens;
int favn;

int betweenAlphabets(char c)
{
	return (c>='A' && c<='Z') || (c>='a' && c<='z') ? 1 : 0;
}
int allIsBetweenAlphabets(char *string)
{
	int len = (int)strlen(string);
	for(int i=0; i<len; i++)
		if(!betweenAlphabets(string[i]))
			return 0;
	return 1;
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
int allIsBetweenLetterDigits(char *string)
{
	int len = strlen(string);
	for(int i=0; i<len; i++)
		if(!betweenLetterDigits(string[i]))
			return 0;
	return 1;
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

void burnMashAttackCases(char *tc_file_path)
{
	createFile(tc_file_path);
	FILE *tc_fp = fopen(tc_file_path, "w");
	fprintf(tc_fp, "%s %d %s\n%d\n", spouse_name, number_of_childrens, luxury_item, favn);
	fclose(tc_fp);
}

void lowerify(char *string)
{
	int len = (int)strlen(string);
	for(int i=0; i<len; i++)
		if(string[i]>='A' && string[i]<='Z') string[i] = string[i] - 'A' + 'a';
}

void takeAttackCases()
{	
	printf("\t(Use '_' instead of space in string type input)\n");
	spouse_name:
		printf("\tSpouse name : ");
		scanf(" %s", spouse_name);
		delete_unnecessary_spaces(spouse_name, "_");
		lowerify(spouse_name);
		if((int)strlen(spouse_name)<3 || !allIsBetweenAlphabets(spouse_name))
			goto spouse_name;
			
	printf("\t\n");
	number_of_childrens:
		printf("\tNumber of childrens: ");
		scanf("%d", &number_of_childrens);
		if(number_of_childrens<0 || number_of_childrens>10000000)
			goto number_of_childrens;
	
	printf("\t\n");
	luxury_item:
		printf("\tLuxury item name: ");
		scanf(" %s", luxury_item);
		delete_unnecessary_spaces(luxury_item, "_");
		lowerify(luxury_item);
		if((int)strlen(luxury_item)<2 || !allIsBetweenLetterDigits(luxury_item))
			goto luxury_item;
	
	printf("\t\n");
	favn:
		printf("\tFavourite Number (1-9): ");
		scanf("%d", &favn);
		if(favn<1 || favn>9)
			goto favn;
}

void displayHeader()
{
	printf("---------------\n");
	printf("| Mash Attack |\n");
	printf("---------------\n");
	printf("Attack others by your choices\n\n");
	
	printf("To attack all:: enter '*'\n");
	printf("Ex:: Attack -> *\n\n");
	
	printf("For individual attack:: enter his/her Valid ID (Without any spaces or '-')\n");
	printf("Ex:: Attack -> 18115955\n\n");
	
	printf("To attack multiple IDs:: enter Valid IDs like: ID1, ID2, ID3 ...\n");
	printf("Ex:: Attack -> 18115955, 18115935, ...\n\n");
	
}
	
int main()
{
	displayHeader();
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
			strcpy(file_path, rabbits);
			printf("\nEnter your Mash attack cases for all:\n\n");
			takeAttackCases();
			burnMashAttackCases(file_path);
		}
		else
		{
			printf("\nEnter your Mash attack choices for: %s\n\n", rabbits);
			takeAttackCases();
			
			token = strtok(rabbits, " ,");
			while(token!=NULL)
			{
				token_length = (int)strlen(token);
				if(!checkIfAllIsDigits(token) || token_length<8 || token_length>9)
				{
					printf("\n%s seems not correct, so not taken !!!\n", token);
					printf("If you insist for it mash must be contacted with :D\n\n");
				}
				else
				{
					strcpy(file_path, token);
					burnMashAttackCases(file_path);
				}
				token = strtok(NULL, " ,");
			}
		}
		printf("\nYo! Your choices are taken carefully! :D\n\n\a");
	goto attack_rabbits;	
	
	return 0;
}

