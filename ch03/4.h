#define NUMBER_SYM 20  /* maximum number of symbols */

struct symtab {
  char *name;
  double value;
} symtab[NUMBER_SYM];

struct symtab *symlook();

int yylex();
void yyerror();