#include <stdio.h>
#define swapls(a,b) {long long int c=a;a=b;b=c;}
long long int countNABa(long long int n, long long int a, long long int b)
{
	long long int count = 0;
	while(a<=b)
	{
		if(a%n==0) count++;
		a++;
	}
	return count;
}
long long int countNABc(long long int n, long long int a, long long int b)
{
	a = (a%n!=0) ? (a+(n-(a%n))) : a;
	if(a>b)
		swapls(a,b);
		
	return a==b ? 1 :((b-a)/n)+1;
}
int main()
{
	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);

	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);
	
	long long int a, b, n;
	int c = 0;
	scanf("%d", &c);
	
	for(int i=1; i<=c; i++)
	{
   	 	scanf("%lld %lld %lld", &n, &a, &b);
   	 	printf("%lld\n", countNABc(n, a, b));
   	}
    
    return 0;
}
