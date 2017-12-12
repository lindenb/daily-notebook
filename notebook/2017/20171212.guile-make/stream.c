/*  gcc  -pthread -I/usr/include/guile/2.0 stream.c -lguile-2.0 -lgc && ./a.out  */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <libguile.h>
#include <libguile/modules.h>
#define UNUSED
static SCM make_mod = SCM_EOL;

struct Record
	{
	int a;
	int b;
	};

static SCM guile_expand_wrapper(SCM obj)
  {
  return SCM_BOOL_F;
  }

static void guile_define_module (void *data UNUSED)
	{
	scm_c_define_gsubr ("record-a", 1, 0, 0, guile_expand_wrapper);
	scm_c_define_gsubr ("record-b", 1, 0, 0, guile_expand_wrapper);
	}
static void *guile_init (void *arg UNUSED)
	{
	make_mod = scm_c_define_module ("lindenb record", guile_define_module, NULL);
	return NULL;
	}

int main(int argc,char** argv) {
	srand(time(NULL));
	 scm_with_guile (guile_init, NULL);
	for(;;)
		{
		struct Record rec;
		rec.a = rand();
		rec.b = rand();
		printf("%d %d\n",rec.a,rec.b);
		}
	return 0;
	}
