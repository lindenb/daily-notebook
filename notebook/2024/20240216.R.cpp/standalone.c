#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Rinternals.h>
#include <Rembedded.h>
#include <R_ext/Parse.h>

int main(int argc,char** argv) {
	char *r_argv[] = {"R","--silent","--no-save","--gui=none",NULL};
	fprintf(stderr,"init::start\n");
	Rf_initEmbeddedR(4, r_argv);
	fprintf(stderr,"init::done\n");
	Rf_endEmbeddedR(0);
	fprintf(stderr,"init::end\n");
	return 0;
	}
