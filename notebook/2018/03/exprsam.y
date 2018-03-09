%{
// https://raw.githubusercontent.com/joedemo42/coherent/9dcd40e2f6ac49bdcc3b56014014aa5d8af719c8/COHERENT/romana/relic/d/bin/awk/awk.y
#include <stdio.h>
#include "exprsam.h"
%}


%union {
	int	u_char;
	CHAR	*u_charp;
	NODE	*u_node;
	int	(*u_func)();
}


%token LEX_ANDAND LEX_OROR ANOT ANEG OROR_
%token <u_node>	ID_ STRING_ NUMBER_ FUNCTION_
%token <u_node>	LEX_TRUE LEX_FALSE

%left	SCON_
%right	ASADD_ ASSUB_ ASMUL_ ASDIV_ ASMOD_ '='
%left	OROR_
%left	ANDAND_
%left	'~' NMATCH_
%nonassoc EQ_ NE_
%nonassoc GE_ LE_ '>' '<'
%left	'+' '-'
%left	'*' '/' '%'
%nonassoc '!' INC_ DEC_
%nonassoc '$'
%nonassoc '(' '['

%type <u_node>	e terminal constant
%%

input: e;


terminal: LEX_TRUE | LEX_FALSE
	;

e:
	'(' e ')' {
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


