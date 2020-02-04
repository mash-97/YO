#include <stdio.h>
#include <math.h>

int main()
{
	double u, theta;		// u in ms^-1 and theta in degree
	double g = 9.81;
	
	scanf("%lf %lf", &u, &theta);
	
	double rad = theta*(3.1415/180);
	
	double R = ((u*u)*sin(2*rad*1.0))/g;
	
	printf("%.2lf meters\n", R);
	
	return 0;
}
