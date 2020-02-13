#include "lib_helper.h"

int ntest_cases;
int test_cases[100][2];

void burnProjectileTestCases(char *tc_file_path)
{
	createFile(tc_file_path);
	FILE *tc_fp = fopen(tc_file_path, "w");
	
	fprintf(tc_fp, "%d\n", ntest_cases);
	for(int i=0; i<ntest_cases; i++)
		fprintf(tc_fp, "%d %d\n", test_cases[i][0], test_cases[i][1]);
	
	fclose(tc_fp);
}

void takeTestCases()
{	
	scanf("%d", &ntest_cases);
	
	for(int i=0; i<ntest_cases; i++)
		scanf("%d %d", &test_cases[i][0], &test_cases[i][1]);
}

int checkTestCases()
{
	for(int i=0; i<ntest_cases; i++)
		if(test_cases[i][0]<0 || test_cases[i][0]>100000000 || test_cases[i][1]<0 || test_cases[i][1]>360)
			return 0;
	return 1;
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
	createFolder(PROJECTILE_ATTACKs_FOLDER_NAME);
	
	char rabbits[100001];
	char file_path[200001];
	char * token = NULL;
	
	int token_length;
	int flag;
	
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
			strcpy(file_path, PROJECTILE_ATTACKs_FOLDER_NAME);
			strcat(file_path, path_sep);
			strcat(file_path, rabbits);
			
			take_for_all:
			printf("\nGive your nab test cases for all:\n\n");
			takeTestCases();
			if(!checkTestCases())
			{
				printf("\n------->Test Cases seems incorrect! Try again !!!\n\n");
				goto take_for_all;
			}
			
			burnProjectileTestCases(file_path);
			flag = 1;
		}
		else
		{
			take_for_mul:
			printf("\nGive your nab test cases: \n\n");
			takeTestCases();
			if(!checkTestCases())
			{
				printf("\n------->Test Cases seems incorrect! Try again !!!\n\n");
				goto take_for_mul;
			}
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
					strcpy(file_path, PROJECTILE_ATTACKs_FOLDER_NAME);
					strcat(file_path, path_sep);
					strcat(file_path, token);
					burnProjectileTestCases(file_path);
					flag = 1;
				}
				token = strtok(NULL, " ,");
			}
		}
		if(flag) 
			printf("\nYo! Test Cases taken successfully !\n\n\a");
		else
			printf("\nTest Cases Not Taken !!!\n\n\a");
	
	goto attack_rabbits;	
	
	return 0;
}

