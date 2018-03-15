#include "scheme.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
int main(int argc,char** argv) {
if(argc<=1) return EXIT_FAILURE;
scheme* scm = NULL;
scm = scheme_init_new();
assert(scm!=NULL);
scheme_set_input_port_file(scm, stdin);
scheme_set_output_port_file(scm, stderr);
scheme_load_string(scm, argv[1]);
scheme_deinit(scm);
return 0;
}
