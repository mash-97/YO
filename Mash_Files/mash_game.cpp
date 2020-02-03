#include <iostream>
#include <cstdio>
#include <cmath>
#include <cstring>

using namespace std;

char first_person_name[40], second_person_name[40];
int total_turn_value;

// Fields
char mash[4][40];
char spouse_names[4][40];
char children_numbers[4][40];
char luxury_items[4][40];

void initialize_fields()
{
	// Initailize mash 
	strcpy(mash[0], "Mansion");
	strcpy(mash[1], "Apartment");
	strcpy(mash[2], "Shack");
	strcpy(mash[3], "House");
	
	// place 0 in all
	for(int i=0; i<4; i++)
	{
		spouse_names[i][0] = 0;
		children_numbers[i][0] = 0;
		luxury_items[i][0] = 0;
	}
}

int getAVoidIndexFor(char items[4][40])
{
	for(int i=0; i<4; i++)
		if(items[i][0]==0)
			return i;
	return -1;
}


void getPlayerChoicesFor(char field[4][40])
{
	char item[40];
	int index;
	
	for(int j=1; j<=3; j++)
	{
		scanf("%d %s", &index, item);
		strcpy(field[index-1], item);
	}
}

void getAttackerChoices()
{
	char spouse_name[40];
	char children_number[40];
	char luxury_item[40];
	scanf(" %s %s %s", spouse_name, children_number, luxury_item);
	
	strcpy(spouse_names[getAVoidIndexFor(spouse_names)], spouse_name);
	strcpy(children_numbers[getAVoidIndexFor(children_numbers)], children_number);
	strcpy(luxury_items[getAVoidIndexFor(luxury_items)], luxury_item);
}

void getTotalTurnValue()
{
	int player_choice, attacker_choice;
	scanf("%d %d", &player_choice, &attacker_choice);
	total_turn_value = player_choice + attacker_choice;
}

void getPlayerNames()
{
	scanf(" %s %s", first_person_name, second_person_name);
}

int countItemsOf(char field[4][40])
{
	int count = 0;
	for(int i=0; i<4; i++)
		if(field[i][0]!=0)
			count++;
	
	return count;
}


int getValIndexOf(char field[4][40])
{
	for(int i=0; i<4; i++)
		if(field[i][0]!=0)
			return i;
	return -1;
}


int driveThrough(int i, char field[4][40])
{
	for(int j=0; countItemsOf(field)>1 && j<4; j++)
	{
		if(field[j][0]!=0)
		{
			if(i==1)
			{
				i=total_turn_value;
				field[j][0] = 0;
			}
			else i--;
		}
	}
	
	return i;
}


void startMASH()
{
	int i = total_turn_value;
	while(countItemsOf(spouse_names) > 1 || countItemsOf(children_numbers) > 1 || countItemsOf(luxury_items) > 1)
	{
		i = driveThrough(i, mash);
		i = driveThrough(i, spouse_names);
		i = driveThrough(i, children_numbers);
		i = driveThrough(i, luxury_items);
	}
}
				
			
			


int main()
{
	// Interactive input and output with input.txt and output.txt
	freopen("mash_game.in", "r", stdin);
	freopen("mash_game.out", "w", stdout);
	
	initialize_fields();
	
	getPlayerNames();							// player_name attacker_name
	getPlayerChoicesFor(spouse_names);			// 3 times: index spouse_name
	getPlayerChoicesFor(children_numbers);		// 3 times: index children_number
	getPlayerChoicesFor(luxury_items);			// 3 times: index luxury_item_name
	getAttackerChoices();						// spouse_name children_number luxury_item_name
	getTotalTurnValue();						// player's_turn_value attacker_turn_value
	
	startMASH();								// Start the game.
	
	printf("%s %s %s %s\n", mash[getValIndexOf(mash)], spouse_names[getValIndexOf(spouse_names)], 
								children_numbers[getValIndexOf(children_numbers)],
									luxury_items[getValIndexOf(luxury_items)]);
	
	return 0;
}
