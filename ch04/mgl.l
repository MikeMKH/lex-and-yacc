ws [ \t]+
qstring \"[^\"\n]*[\"\n]
id [a-zA-Z][a-zA-Z0-9]*
nl \n

%%

{ws} ; /* ignore */
{qstring} {
  yylval.string = strdup(yytext+1); /* skip openning quote */
  
  if (yylval.string[yyleng-2] != '"')
    warning("unterminated quoted string", (char*)0);
  else
    yylval.string[yyleng-2] = '\0'; /* remove closing quote */

  return QSTRING;
}
{id} {
  yylval.string = strdup(yytext);
  return ID;
}

action { return ACTION; }
execute { return EXECUTE; }
command { return COMMAND; }
ignore { return IGNORE; }
item { return ITEM; }
title { return TITLE; }

{nl} { lineno++; }
. { return }