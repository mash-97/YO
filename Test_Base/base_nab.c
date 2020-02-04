#include <stdio.h>

using namespace std;

long long int countNABc(long long int n, long long int a, long long int b)
{
	a = (a%n!=0) ? (a+(n-(a%n))) : a;
	if(a>b) return 0;
	return a==b ? 1 :((b-a)/n)+1;
}

long long int countNABb(long long int n, long long int a, long long int b)
{
	a = (a%n!=0) ? (a+(n-(a%n))) : a;
	
	long long int count = 0;
	while(a<=b)
	{
		count+=1;
		a+=n;
	}
	return count;
}

long long int countNABa(long long int n, long long int a, long long int b)
{
	long long int count = 0;
	for(long long int i = a; i<=b; i++)
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

	freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

	freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

	freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

	freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

	freopen("base_nab.in", "r", stdin);
	freopen("base_nab.out", "w", stdout);

	
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
