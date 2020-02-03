#include <iostream>
#include <cmath>
#include <cstdio>

using namespace std;

int countNAB(int a, int b, int n)
{
	a = (a%n!=0) ? (a+(n-(a%n))) : a;
	if(a>b) return 0;
	return a==b ? 1 :((b-a)/n)+1;
}

int countNABa(int a, int b, int n)
{
	a = (a%n!=0) ? (a+(n-(a%n))) : a;
	
	int count = 0;
	while(a<=b)
	{
		count+=1;
		a+=n;
	}
	return count;
}

int main()
{
	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);
	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);
	
	int a, b, n;
	for(int i=1; i<=3000000; i++)
	{
		scanf("%d %d %d", &n, &a, &b);
		printf("a: %d, b: %d, n: %d\n", a, b, n);
		printf("%d ---\a---- %d\n", countNAB(a, b, n), countNABa(a, b, n));
		if(countNAB(a,b,n) != countNABa(a,b,n))
		{
			for(int i=1; i<=100000; i++) printf("\a");
			printf("\t\tNot Matched!\n");
		}
		printf("\n");
	}
	
	return 0;
}
