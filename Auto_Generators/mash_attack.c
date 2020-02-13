#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "lib_helper.h"

#if defined(_WIN32) || defined(_WIN64) || defined(WIN32)
	#define path_sep "\\"
#else
	#define path_sep "/"
#endif


char spouse_name[40];
char luxury_item[40];
int number_of_childrens;
int favn;


void burnMashAttackCases(char *tc_file_path)
{
	createFile(tc_file_path);
	FILE *tc_fp = fopen(tc_file_path, "w");
	fprintf(tc_fp, "%s %d %s\n%d\n", spouse_name, number_of_childrens, luxury_item, favn);
	fclose(tc_fp);
}


void takeAttackCases()
{	
	char num_string[1001];
	
	printf("\t(Use '_' instead of space in string type input)\n");
	spouse_name:
		printf("\tSpouse name : ");
		scanf(" %s", spouse_name);
		delete_unnecessary_spaces(spouse_name, "_");
		if((int)strlen(spouse_name)<3 || !allIsBetweenAlphabets(spouse_name, "_"))
			goto spouse_name;
	printf("\t\n");
	
	
	number_of_childrens:
		printf("\tNumber of childrens: ");
		scanf(" %s", num_string);
		if(ifTheresAAlphabet(num_string))
			goto number_of_childrens;
		number_of_childrens = atoi(num_string);
		if(number_of_childrens<0 || number_of_childrens>10000000)
			goto number_of_childrens;
	printf("\t\n");
	
	
	luxury_item:
		printf("\tLuxury item name: ");
		scanf(" %s", luxury_item);
		delete_unnecessary_spaces(luxury_item, "_");
		lowerify(luxury_item);
		if((int)strlen(luxury_item)<2 || !allIsBetweenLetterDigits(luxury_item, "_"))
			goto luxury_item;
	
	printf("\t\n");
	favn:
		printf("\tFavourite Number (1-9): ");
		scanf(" %s", num_string);
		if(ifTheresAAlphabet(num_string))
			goto favn;
		favn = atoi(num_string);
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

void displayAttackChoices(char *rabbits)
{
	printf("\n");
	printf("You attack choices for: %s\n", rabbits);
	printf("--------------------------------------------------\n");
	printf("Spouse name: %s\n", spouse_name);
	printf("Number of Childrens: %d\n", number_of_childrens);
	printf("Luxury Item Name: %s\n", luxury_item);
	printf("Favourite Number: %d\n", favn);
	printf("--------------------------------------------------\n");
	printf("\n");
}

int main()
{
	displayHeader();
	char rabbits[100001];
	char file_path[200001];
	char * token = NULL;
	
	int flag;
	int token_length;
	
	attack_rabbits:
		flag = 0;
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
			strcpy(file_path, ".");
			strcat(file_path, rabbits);
			printf("\nEnter your Mash attack cases for all:\n\n");
			takeAttackCases();
			burnMashAttackCases(file_path);
			flag = 1;
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
					strcpy(file_path, ".");
					strcat(file_path, token);
					burnMashAttackCases(file_path);
					flag = 1;
				}
				token = strtok(NULL, " ,");
			}
		}
		displayAttackChoices(rabbits);
		if(flag)
			printf("\nYo! Your choices are taken successfully! :D\n\n\a");
		else
			printf("\nChoices not taken !!!\n\n\a");
			
	goto attack_rabbits;	
	
	return 0;
}

