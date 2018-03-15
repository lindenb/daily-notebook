#include <stdio.h>
#include <stdlib.h>

int main(int argc,char** argv) {
double a;
double total = 0.0;
while(!feof(stdin) && fscanf(stdin,"%lf",&a)==1) {
total+=a;
}
fprintf(stdout,"%f\n",total);
return EXIT_SUCCESS;
}
