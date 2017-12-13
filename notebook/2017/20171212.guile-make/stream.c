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

static SCM guile_expand_wrapper(SCM obj1,SCM obj2)
  {
  fprintf(stderr,"called %p %d.\n",obj1,(int)scm_is_bool(obj2));
  return SCM_BOOL_T;
  }

static void guile_define_module (void *data UNUSED)
	{
	scm_c_define_gsubr ("call1", 1, 1, 0, guile_expand_wrapper);
	scm_c_define_gsubr ("call2", 1, 1, 0, guile_expand_wrapper);
	}
static void *guile_init (void *arg UNUSED)
	{
	//make_mod = scm_c_define_module ("lindenb record", guile_define_module, NULL);
	guile_define_module(NULL);
	return NULL;
	}

int main(int argc,char** argv) {
	if(argc!=2) return -1;
	
	srand(time(NULL));
	/* Start up the Guile interpeter */
	scm_init_guile();
	scm_with_guile (guile_init, NULL);
	//scm_c_eval_string ("(use-modules (lindenb record))");
	
	long max_iter=100000;
	while(--max_iter>0)
		{
		struct Record rec;
		rec.a = rand();
		rec.b = rand();
		
		scm_c_define("rec-a", scm_from_int(rec.a));
		scm_c_define("rec-b", scm_from_int(rec.b));
		//  obj_to_str = scm_variable_ref (scm_c_module_lookup (make_mod, "obj-to-str"));
		SCM ret=scm_c_eval_string (argv[1]);
		if(!scm_is_bool(ret))
			{
			fprintf(stderr,"Not a boolean...\n");
			continue;
			}
		int success = scm_to_bool (ret);
		if(success) printf("%d %d\n",rec.a,rec.b);
		
		
		}
	return 0;
	}
