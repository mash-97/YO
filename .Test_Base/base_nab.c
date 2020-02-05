#include <stdio.h>

long long int countNABc(long long int n, long long int a, long long int b)
{
	a += (a%n!=0) ? n-(a%n) : 0;
	if(a>b) return 0;
	return a==b ? 1 : ((b-a)/n)+1;
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
		scanf("%lld %d %lld", &n, &a, &b);
		printf("%lld\n", countNABc(n,a,b));
	}
	
	return 0;
}
