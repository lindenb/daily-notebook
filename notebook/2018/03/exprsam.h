#ifndef EXPR_SAM_H
#define EXPR_SAM_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

enum SCALAR_TYPE  {SCALAR_TYPE_INT};

typedef struct Scalar {
union {
	int t_int;
	} data;
int type;
void (*free_callback)(struct Scalar* s);
} Scalar;




typedef	struct	NODE {
	
	Scalar* (*eval_callback)(struct	NODE* myself);
	struct	NODE* next;
}	NODE;

NODE* node(int,NODE*,NODE*);
NODE* compile_sam_filter_expr( char* s);
extern NODE* yy_compiled_node;
#endif

