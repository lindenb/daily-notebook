#include <stdio.h>
#include <libguile.h>


struct Global {
    int value;
    char buffer[2048];//should be large enough
    };

static struct Global global;

/** retrieve the next record, return #t on success */
static SCM _next () {
  global.value++;
  return global.value<100?SCM_BOOL_T:SCM_BOOL_F;
}
/** get current number */
static SCM _get () {
  return scm_from_int(global.value);
}

/** output current number */
static SCM _emit () {
  fprintf(stderr,"%d\n",global.value);
  return SCM_BOOL_T;
}

/** dispose memory associated */
static SCM _dispose () {
  return SCM_BOOL_T;
}


static void*
inner_main (void *data)
{
    struct Global* g= (struct Global*)data;
    scm_c_define_gsubr("_next", 0, 0, 0, _next);
    scm_c_define_gsubr("_get", 0, 0, 0, _get);
    scm_c_define_gsubr("_emit", 0, 0, 0, _emit);
    scm_c_define_gsubr("_dispose", 0, 0, 0, _dispose);
    scm_c_eval_string(g->buffer);
    return 0;
}

int main(int argc,char** argv) {
    if(argc!=2) return -1;
    global.value=1;
    sprintf(global.buffer,"(while (_next) (if %s  (_emit)   ) (_dispose) )  ",argv[1]);
    scm_with_guile(inner_main,(void*)&global);
    return 0;
    }
