#include "scheme.h"
#include "scheme-private.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
int main(int argc,char** argv) {
pointer rv;
char buffer[1000];
if(argc<=1) return EXIT_FAILURE;	
scheme* scm = NULL;
	scm = scheme_init_new();
	assert(scm!=NULL);
	scheme_set_input_port_file(scm, stdin);
	scheme_set_output_port_file(scm, stderr);
	sprintf(buffer,"(define x %s)",argv[1]);
	
	scheme_load_string(scm, buffer);
	rv = scheme_eval(scm, mk_symbol(scm, "x"));
	if(rv==NULL)
		{
		fprintf(stderr,"NULL\n");
		}
	if(is_number(rv)) fprintf(stderr,"number\n");
	if(is_string(rv)) fprintf(stderr,"string\n");
	if(scm->NIL == rv ) fprintf(stderr,"nil\n");
	if(scm->T == rv ) fprintf(stderr,"true\n");
	if(scm->F == rv ) fprintf(stderr,"false\n");

	scheme_deinit(scm);
return 0;

}
