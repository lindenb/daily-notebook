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
 struct  Record* rec;
 fprintf(stderr,"called ok\n");
 
  fprintf(stderr,"called %d undefined2=%d.\n",SCM_UNDEFINED == obj2,SCM_UNDEFINED == obj2);
  
  rec=(struct Record*)scm_to_pointer(obj1);
  fprintf(stderr,"[1]ptr=%p\n",rec);
  
   fprintf(stderr," AND -> %d %d\n",rec->a,rec->b);
  return SCM_BOOL_T;
  }

static void guile_define_module (void *data UNUSED)
	{
	scm_c_define_gsubr ("call1", 1, 1, 0, guile_expand_wrapper);
	scm_c_define_gsubr ("call2", 1, 1, 0, guile_expand_wrapper);
	scm_c_export("call1","call2",NULL);
	}
static void *guile_init (void *arg UNUSED)
	{
	make_mod = scm_c_define_module ("lindenb", guile_define_module, NULL);
	return NULL;
	}

int main(int argc,char** argv) {
	if(argc!=2) return -1;
	
	srand(time(NULL));
	/* Start up the Guile interpeter */
	scm_init_guile();
	scm_with_guile (guile_init, NULL);
	scm_c_use_module("lindenb");
	fprintf(stderr,"Read user's script\n");
	scm_c_eval_string (argv[1]);
	fprintf(stderr,"lookup...\n");
	SCM filterfun = scm_c_lookup("zz");
	if(scm_is_false(scm_variable_p(filterfun)))
		{
		fprintf(stderr,"not a proc...\n");
		//return -1;
		}
	fprintf(stderr,"lookup ok...\n");
	
	
	SCM filterproc=scm_variable_ref(filterfun);
	
	long max_iter=100000;
	while(--max_iter>0)
		{
		struct Record rec;
		rec.a = rand();
		rec.b = rand();
		//fprintf(stderr,"[0]ptr=%p\n",&rec);
		SCM sc_ptr = scm_from_pointer((void*)&rec,NULL);
		scm_c_define("rec-a", scm_from_int(rec.a));
		scm_c_define("rec-b", scm_from_int(rec.b));
		//SCM myptr = scm_c_define("myptr",sc_ptr);
		
		SCM ret=scm_call_1(filterproc,sc_ptr);
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
