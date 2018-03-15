
#include "exprsam.h"
#include "exprsam.tab.h"
#include "lex.yy.h"
NODE* node_new() {
	NODE* n = calloc(1UL,sizeof(NODE));
	return n;
	}

	
void scalar_free(Scalar* sc)
	{
	if(sc!=NULL) free(sc);
	}
Scalar* scalar_new() {
	Scalar* sc = calloc(1UL,sizeof(Scalar));
	sc->free_callback = scalar_free;
	return sc;
	}
Scalar* scalar_new_int(int v) {
	Scalar* sc = scalar_new();
	sc->type = SCALAR_TYPE_INT;
	sc->data.t_int = v;
	return sc;
	}
static Scalar* eval_true(NODE* myself) {
	Scalar* sc = scalar_new();
	sc->type = SCALAR_TYPE_INT;
	sc->data.t_int = 1;
	return sc;
	}

static Scalar* eval_false(NODE* myself) {
	Scalar* sc = scalar_new();
	sc->type = SCALAR_TYPE_INT;
	sc->data.t_int = 0;
	return sc;
	}
static Scalar* eval_andand(NODE* myself) {
	Scalar* scL = myself->next->eval_callback(myself->next);
	Scalar* scR = myself->next->next->eval_callback(myself->next->next);
	scalar_free(scL);
	scalar_free(scR);
	Scalar* sc = scalar_new();
	sc->type = SCALAR_TYPE_INT;
	sc->data.t_int = 0;
	return sc;
	}
static Scalar* eval_oror(NODE* myself) {
	Scalar* sc = scalar_new();
	sc->type = SCALAR_TYPE_INT;
	sc->data.t_int = 0;
	return sc;
	}

NODE* node(int opcode,NODE* L,NODE* R)
	{
	NODE* n = NULL;
	switch(opcode)
		{
		case LEX_TRUE: 
			{
			n = node_new();
			n-> eval_callback = eval_true;
			break;
			};
		case LEX_FALSE: 
			{
			n = node_new();
			n-> eval_callback = eval_false;
			break;
			}
		case LEX_ANDAND :
			{
			n = node_new();
			n->next = L;
			n->next->next = R;
			n-> eval_callback = eval_andand;
			break;
			}
		case LEX_OROR :
			{
			n = node_new();
			n->next = L;
			n->next->next = R;
			n-> eval_callback = eval_oror;
			break;
			}
		default: fprintf(stderr,"undefined opcode %d\n",opcode);exit(EXIT_FAILURE);
		}
	fprintf(stderr,"n=%p",n);
	return n;
	}

NODE* compile_sam_filter_expr( char* expr)
	{
	yy_scan_string(expr);
	yyparse();
	return yy_compiled_node;
	}

int main(int argc,char** argv) {
	NODE* compiled = NULL;
	if(argc<2)
		{
		fprintf(stderr,"expression missing\n");
		return EXIT_FAILURE;
		}
	compiled = compile_sam_filter_expr(argv[1]);
	if( compiled == NULL)
		{
		fprintf(stderr,"cannot compile expression %s.\n",argv[1]);
		return EXIT_FAILURE;
		}
	return 0;
	}
