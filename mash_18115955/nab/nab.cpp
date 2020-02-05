#include <iostream>
#include <cmath>
#include <cstdio>

using namespace std;

int countNAB(int a, int b, int n)
{
	a += a%n!=0 ? n-(a%n) : 0;
	if(a>b) return 0;
	return a==b ? 1 :((b-a)/n)+1;
}

long long int countNABa(long long int n, long long int a, long long int b)
{
	a += a%n!=0 ? n-(a%n) : 0;
	
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

	int t;
	scanf("%d", &t);
	long long int a, b, n;
	for(int i=1; i<=t; i++)
	{
		scanf("%lld %lld %lld", &n, &a, &b);
		printf("%lld\n", countNABa(n,a,b));
	}
	
	return 0;
}
