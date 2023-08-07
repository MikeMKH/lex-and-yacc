#define NUMBER_SYM 20  /* maximum number of symbols */

struct symtab {
  char *name;
  double (*funcp)();
  double value;
} symtab[NUMBER_SYM];

struct symtab *symlook();
void addfunc(char*, double (*)());

int yylex();
void yyerror();