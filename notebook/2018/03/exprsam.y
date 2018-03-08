%{
%}

%token LEX_TRUE LEX_FALSE

%%

input: boolean_expr;
boolean_expr: LEX_TRUE | LEX_FALSE;

%%


