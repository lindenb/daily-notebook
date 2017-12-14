#include "config.h"
#include <stdio.h>

#ifdef HAVE_GUILE
#include <libguile.h>
#endif

int main(int argc,char** argv) {
#ifdef HAVE_GUILE
	printf("Guile supported\n");
	scm_init_guile();
#else
	printf("Guile not supported\n");
#endif
return 0;
}
