#include <stdio.h>
#include <stdlib.h>

int main(int argc,char** argv) {
double a;
long count = 0L;
double total = 0.0;
while(!feof(stdin) && fscanf(stdin,"%lf",&a)==1) {
total+=a;
count++;
}
fprintf(stdout,"%f\n",total/count);
return EXIT_SUCCESS;
}
