%{
#include "4.tab.h"
#include "4.h"
#include <math.h>
%}

%%

(([0-9]+|([0-9]*\.[0-9]+))([eE][-+]?[0-9]+)?) {
    yylval.val = atof(yytext);
    return NUMBER;
}

[ \t] ; /* ignore white space */

[A-Za-z][A-Za-z0-9]*  {
    yylval.symp = symlook(yytext); /* return symbol pointer */
    return NAME;
}

"$" { return 0; }

\n |
.  return yytext[0];
