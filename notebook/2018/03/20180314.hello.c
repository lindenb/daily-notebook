#include "scheme.h"
#include "scheme-private.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

typedef struct Filename {
char path[FILENAME_MAX];
} Filename;

/*
static pointer first_bytes(scheme *sc, pointer args) {
for(; args != sc->NIL ;  args = pair_cdr( args ) )
		{
		if(is_real(arg)) {
			v += rvalue( arg );
			N++;
		  }
		}
}*/



static pointer fun_average(scheme *sc, pointer args)
	{
	double v=0.0;
	double N=0.0;
	pointer retval;

	for(; args != sc->NIL ;  args = pair_cdr( args ) )
		{
		pointer arg = pair_car(args);
		if(is_real(arg)) {
			v += rvalue( arg );
			N++;
		} else {
		fprintf(stderr,"No a real.");
		exit(EXIT_FAILURE);
		}
		}
	return mk_real(sc,v/N);
	}

int main(int argc,char** argv) {
pointer rv;
char buffer[1000];
if(argc<=1) return EXIT_FAILURE;	
scheme* scm = NULL;
	scm = scheme_init_new();
	assert(scm!=NULL);
	scheme_set_input_port_file(scm, stdin);
	scheme_set_output_port_file(scm, stderr);
	scheme_define(scm,scm->global_env,mk_symbol(scm,"my-average"),mk_foreign_func(scm, fun_average));
	
	
	sprintf(buffer,"(define x %s)",argv[1]);



	mk_symbol(scm,"sym1");	
	scheme_load_string(scm, buffer);
	rv = scheme_eval(scm, mk_symbol(scm, "x"));
	if(rv==NULL)
		{
		fprintf(stderr,"NULL\n");
		}
	if(is_number(rv)) fprintf(stderr,"number\n");
	if(is_integer(rv)) fprintf(stderr,"integer %ld\n",ivalue(rv));
	if(is_string(rv)) fprintf(stderr,"string\n");
	if(is_real(rv)) fprintf(stderr,"real %f\n",rvalue( rv ));
	if(scm->NIL == rv ) fprintf(stderr,"nil\n");
	if(scm->T == rv ) fprintf(stderr,"true\n");
	if(scm->F == rv ) fprintf(stderr,"false\n");

	scheme_deinit(scm);
return 0;

}
