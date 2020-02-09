#include <stdio.h>
#include <math.h>

double PI = 3.1415;
double g = 9.8;

double projectileRange(double u, double degree)
{
	double rad = degree*(PI/180.0);
	double range = ((u*u)*sin(2*rad))/g;
	return range;
}

int main()
{

	int t;
	scanf("%d", &t);

	double u, theta;
	for(int i=1; i<=t; i++)
	{
		scanf("%lf %lf", &u, &theta);
		printf("%.2lf\n", projectileRange(u, theta));
	}
	return 0;
}
