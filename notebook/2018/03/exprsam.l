%{
#include "exprsam.h"
#include "exprsam.tab.h"

%}

%option noyywrap
%%

true return LEX_TRUE;
TRUE return LEX_TRUE;
(false|FALSE) return LEX_FALSE;
&& return LEX_ANDAND;
\|\| return LEX_OROR;
\( return LEX_OPAR;
\) return LEX_CPAR;

%%


