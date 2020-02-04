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


char spouse_names[4][41];
char luxury_items[4][41];
int children_numbers[4][1];
int favn;

int cindexes[4];
int ccount;

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

void burnPreferences(char *tc_file_path)
{
	createFile(tc_file_path);
	FILE *tc_fp = fopen(tc_file_path, "w");
	
	// Burning spouse choices
	for(int i=0; i<4; i++)
		if(spouse_names[i][0]!=0)
			fprintf(tc_fp, "%d %s\n", i+1, spouse_names[i]);
	
	// Burning children number choices
	for(int i=0; i<4; i++)
		if(children_numbers[i][0]!=-1)
			fprintf(tc_fp, "%d %d\n", i+1, children_numbers[i][0]);
	
	// Burning luxury items
	for(int i=0; i<4; i++)
		if(luxury_items[i][0]!=0)
			fprintf(tc_fp, "%d %s\n", i+1, luxury_items[i]);
			
	// Burning favourite number
	fprintf(tc_fp, "%d\n", favn);
	
	fclose(tc_fp);
}

void initialzeIndexes()
{
	ccount = 0;
	for(int i=0; i<4; i++)
		cindexes[i] = -1;
}

int checkIndex(int indx)
{
	for(int i=0; i<ccount; i++)
		if(cindexes[i]==indx)
			return 0;
	return 1;
}

void addIndex(int indx)
{
	cindexes[ccount] = indx;
	ccount+=1;
}

void displayTakenChoices(int wf)
{
	printf("\n");
	if(wf == 1)
	{
		printf("\tSpouse Names Dice:\n");
		for(int i=0; i<4; i++)
		{
			printf("\t---------------------------\n");
			printf("\t|%d| ", i+1);
			if(spouse_names[i][0]!=0)
				printf("%s\n", spouse_names[i]);
			else
				printf("\n");
		}
		printf("\t---------------------------\n");
	}
	else if(wf == 2)
	{
		printf("\tChildren Numbers Dice:\n");
		for(int i=0; i<4; i++)
		{
			printf("\t---------------------------\n");
			printf("\t|%d| ", i+1);
			if(children_numbers[i][0]!=-1)
				printf("%d\n", children_numbers[i][0]);
			else
				printf("\n");
		}
		printf("\t---------------------------\n");
	}
	else 
	{
		printf("\tLuxury Items Dice:\n");
		for(int i=0; i<4; i++)
		{
			printf("\t---------------------------\n");
			printf("\t|%d| ", i+1);
			if(luxury_items[i][0]!=0)
				printf("%s\n", luxury_items[i]);
			else
				printf("\n");
		}
		printf("\t---------------------------\n");
	}
}

void takePreferences()
{	
	// initialize character arrays with 0 at first index
	for(int i=0; i<4; i++)
	{
		spouse_names[i][0] = 0;
		luxury_items[i][0] = 0;
		children_numbers[i][0] = -1;
	}
	
	int index;
	printf("(Use '_' instead of space in string type input)\n\n");
	//spouse_names:
	printf("Choices for spouse names: \n\n");
	initialzeIndexes();
		for(int i=1; i<=3; i++)
		{
			take_spouse_index:
				printf("\t%d. Index: ", i);
				scanf("%d", &index);
				if(index<1 || index >4 || !checkIndex(index)) 
					goto take_spouse_index;
			addIndex(index);
			
			take_spouse_name:
				printf("\tSpouse name at %d: ", index);
				scanf(" %s", spouse_names[index-1]);
				delete_unnecessary_spaces(spouse_names[index-1], "_");
				lowerify(spouse_names[index-1]);
				if((int)strlen(spouse_names[index-1])<3 || !allIsBetweenAlphabets(spouse_names[index-1]))
					goto take_spouse_name;
			printf("\n");
		}
		printf("\n");
		displayTakenChoices(1);
		printf("\n\n");
		
	//take_children_numbers:
	printf("Choices for number of childrens: \n\n");
	initialzeIndexes();
		for(int i=1; i<=3; i++)
		{
			take_children_index:
				printf("\t%d. Index: ", i);
				scanf("%d", &index);
				if(index<1 || index >4 || !checkIndex(index)) 
					goto take_children_index;
			addIndex(index);
			
			take_number_of_childrens:
				printf("\tNumber of childrens at %d: ", index);
				scanf("%d", &children_numbers[index-1][0]);
				if(children_numbers[index-1][0]<0 || children_numbers[index-1][0]>10000000)
					goto take_number_of_childrens;
			printf("\n");
		}
		printf("\n");
		displayTakenChoices(2);
		printf("\n\n");
		
	//take_luxury_items:
	printf("Choices for luxury item: \n\n");
	initialzeIndexes();
		for(int i=1; i<=3; i++)
		{
			take_luxury_index:
				printf("\t%d. Index: ", i);
				scanf("%d", &index);
				if(index<1 || index >4 || !checkIndex(index)) 
					goto take_luxury_index;
			addIndex(index);
				
			take_luxury_item:
				printf("\tLuxury item at %d: ", index);
				scanf(" %s", luxury_items[index-1]);
				delete_unnecessary_spaces(luxury_items[index-1], "_");
				lowerify(luxury_items[index-1]);
				if((int)strlen(luxury_items[index-1])<3 || !allIsBetweenAlphabets(luxury_items[index-1]))
					goto take_luxury_item;
			printf("\n");
		}
		printf("\n");
		displayTakenChoices(3);
		printf("\n\n");
	printf("\t\n");
	favn:
		printf("Favourite Number (1-9): ");
		scanf("%d", &favn);
		if(favn<1 || favn>9)
			goto favn;
	
}

void displayHeader()
{
	printf("\t\t\t--------------------\n");
	printf("\t\t\t| Mash Preferences |\n");
	printf("\t\t\t--------------------\n");
	printf("MASH Says:: \"In reality what we do is we always PLAY with our choices\"\n\n");
}
	
int main()
{
	displayHeader();
	char file_path[200001];
	takePreferences();
	strcpy(file_path, "mash.pref");
	burnPreferences(file_path);

	printf("\nYo! Your preferences are taken carefully!\n\n\a");
	
	return 0;
}
