#include <stdio.h>

long long int countNABc(long long int n, long long int a, long long int b)
{
	a += (a%n!=0) ? n-(a%n) : 0;
	if(a>b) return 0;
	return a==b ? 1 : ((b-a)/n)+1;
}

int main()
{

	long long int a, b, n;
	int c = 0;
	scanf("%d", &c);

	for(int i=1; i<=c; i++)
	{
		scanf("%lld %lld %lld", &n, &a, &b);
		printf("%lld\n", countNABc(n,a,b));
	}

	return 0;
}
