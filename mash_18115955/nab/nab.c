#include <stdio.h>
#define lli long long int

lli nab(lli n, lli a, lli b)
{
	a += a%n!=0 ? (n-(a%n)) : 0;
	if(a>b) return 0;
	return a==b ? 1 : ((b-a)/n)+1;
}

int main()
{

	int t;
	scanf("%d", &t);
	lli n, a, b;
	while(t--)
	{
		scanf("%lld %lld %lld", &n, &a, &b);
		printf("%lld\n", nab(n, a, b));
	}
	
	return 0;
}

