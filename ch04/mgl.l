ws [ \t]+
comment #.*
qstring \"[^\"\n]*[\"\n]
id [a-zA-Z][a-zA-Z0-9]*
nl \n

%%

{ws} ; /* ignore */
{comment} ; /* ignore */
{qstring} {
  yylval.string = strdup(yytext+1); /* skip openning quote */
  
  if (yylval.string[yyleng-2] != '"')
    warning("unterminated quoted string", (char*)0);
  else
    yylval.string[yyleng-2] = '\0'; /* remove closing quote */

  return QSTRING;
}

screen { return SCREEN; }
title { return TITLE; }
item { return ITEM; }
command { return COMMAND; }
action { return ACTION; }
execute { return EXECUTE; }
menu { return MENU; }
quit { return QUIT; }
ignore { return IGNORE; }
attribute { return ATTRIBUTE; }
visible { return VISIBLE; }
invisible { return INVISIBLE; }
end { return END; }

{id} {
  yylval.string = strdup(yytext);
  return ID;
}
{nl} { lineno++; }
. { return }

%%