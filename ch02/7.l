%s TAG

%%
<TAG>end { BEGIN 0; printf("<==stop tagging=="); }
<TAG>.+  { printf("  tag:"); ECHO; }
tag      { BEGIN TAG; printf("==stop tagging==>"); }
.+       ECHO;
%%

int main()
{
  yylex();
}
