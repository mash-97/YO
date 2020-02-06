#include <stdio.h>
#include <math.h>

int main()
{

	int t;
	scanf("%d", &t);
	double u, theta;		// u in ms^-1 and theta in degree
	double g = 9.8;
	double rad;
	double R;
	for(int i=1; i<=t; i++)
	{
		scanf("%lf %lf", &u, &theta);
		rad = theta*(3.1415/180);
		R = ((u*u)*sin(2*rad*1.0))/g;

		printf("%.2lf\n", R);
	}

	return 0;
}
