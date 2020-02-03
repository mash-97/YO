#include <iostream>
#include <cmath>
#include <cstdio>

using namespace std;

int countNABc(int a, int b, int n)
{
	a = (a%n!=0) ? (a+(n-(a%n))) : a;
	if(a>b) return 0;
	return a==b ? 1 :((b-a)/n)+1;
}

int countNABb(int n, int a, int b)
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

int countNABa(int n, int a, int b)
{
	int count = 0;
	for(int i = a; i<=b; i++)
		if(i%n==0)
			count++;
	return count;
}

int main()
{
	freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

		freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

	int a, b, n;
	
	scanf("%d %d %d", &n, &a, &b);
	printf("%d\n", countNABa(n,a,b));
	
	return 0;
}
