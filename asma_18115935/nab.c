#include <stdio.h>

int countNAB(int a, int b, int n)
{
	int count = 0;
	while(a<=b)
	{
		if(a%n==0) count++;
		a++;
	}
	return count;
}

int main()
{
	freopen("nab.in", "r", stdin);
	freopen("nab.out", "w", stdout);


    int a, b, n;
    scanf("%d %d %d", &n, &a, &b);
    printf("%d\n", countNAB(a,b,n));
    return 0;
}
