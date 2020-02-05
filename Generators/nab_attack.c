#include "lib_helper.h"

int ntest_cases;
long long int test_cases[100][3];

void burnNabTestCases(char *tc_file_path)
{
	createFile(tc_file_path);
	FILE *tc_fp = fopen(tc_file_path, "w");
	
	fprintf(tc_fp, "%d\n", ntest_cases);
	for(int i=0; i<ntest_cases; i++)
		fprintf(tc_fp, "%lld %lld %lld\n", test_cases[i][0], test_cases[i][1], test_cases[i][2]);
	
	fclose(tc_fp);
}

void takeTestCases()
{	
	scanf("%d", &ntest_cases);
	
	for(int i=0; i<ntest_cases; i++)
		scanf("%lld %lld %lld", &test_cases[i][0], &test_cases[i][1], &test_cases[i][2]);
}

void displayHeader()
{
	printf("--------------\n");
	printf("| Nab Attack |\n");
	printf("--------------\n");
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
	printf("2 4 10             5 10 50\n");
	printf("3 6 20             6 18 22\n");
	printf("                   1 1  300\n");
	
}
	
int main()
{
	displayHeader();
	createFolder("Nab_Attacks");
	
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
			strcpy(file_path, NAB_ATTACKs_FOLDER_NAME);
			strcat(file_path, path_sep);
			strcat(file_path, rabbits);
			printf("\nGive your nab test cases for all:\n\n");
			takeTestCases();
			burnNabTestCases(file_path);
			flag = 1;
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
					strcpy(file_path, NAB_ATTACKs_FOLDER_NAME);
					strcat(file_path, path_sep);
					strcat(file_path, token);
					burnNabTestCases(file_path);
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
