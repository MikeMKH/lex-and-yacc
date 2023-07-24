%{
/*
 * lexical analyzer to be used for a reverse polish notation calculator
 */

#include "rpny.h"	/* token codes from the parser */
%}

%%

\n	{ return(RESULT); }

^\+	{ return(ADD); }

[0-9]+ { return(NUMBER); }

.	;

%%
