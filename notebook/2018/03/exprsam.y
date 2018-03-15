%{
// https://raw.githubusercontent.com/joedemo42/coherent/9dcd40e2f6ac49bdcc3b56014014aa5d8af719c8/COHERENT/romana/relic/d/bin/awk/awk.y
#include <stdio.h>
#include "exprsam.h"

extern int yylex();
void yyerror(const char* msg)
	{
	fprintf(stderr,"[ERROR] %s.",msg);
	exit(EXIT_FAILURE);
	}
	
NODE* yy_compiled_node = NULL;
%}


%union {
	NODE	*u_node;
}


%token LEX_ANDAND LEX_OROR ANOT ANEG OROR_ LEX_OPAR LEX_CPAR
%token <u_node>	ID_ STRING_ NUMBER_ FUNCTION_
%token LEX_TRUE LEX_FALSE

%left	SCON_
%right	ASADD_ ASSUB_ ASMUL_ ASDIV_ ASMOD_ '='
%left	LEX_OROR
%left	LEX_ANDAND
%left	'~' NMATCH_
%nonassoc EQ_ NE_
%nonassoc GE_ LE_ '>' '<'
%left	'+' '-'
%left	'*' '/' '%'
%nonassoc '!' INC_ DEC_
%nonassoc '$'
%nonassoc '(' '['

%start input

%type <u_node>	e terminal
%%

input: e {yy_compiled_node=$1;};


terminal:   LEX_TRUE  {$$ =  node(LEX_TRUE,NULL,NULL);} 
          | LEX_FALSE {$$ =  node(LEX_FALSE,NULL,NULL);}
	;

e:
	LEX_OPAR e LEX_CPAR {
		$$ = $2;
	}
      | e LEX_ANDAND e {
		$$ = node(LEX_ANDAND, $1, $3);
	}
      | e LEX_OROR e {
		$$ = node(LEX_OROR, $1, $3);
	}
      | terminal
      ;
%%


