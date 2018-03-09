%{
#include "exprsam.h"
#include "exprsam.tab.h"
%}

%%

(true|TRUE) return LEX_TRUE;
(false|FALSE) return LEX_FALSE;
&& return LEX_ANDAND;
\|\| return LEX_OROR;

%%


