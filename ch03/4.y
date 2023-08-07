%{
#include "4.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
%}

%union {
  double val;
  struct symtab *symp;
}
%token <symp> NAME
%token <val> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <val> expression

%%

statement_list:  statement '\n'
  |              statement_list statement '\n'
  ;

statement:  NAME '=' expression { $1->value = $3; }
  |         expression { printf("= %g\n", $1); }
  ;

expression:  expression '+' expression { $$ = $1 + $3; }
  |          expression '-' expression { $$ = $1 - $3; }
  |          expression '*' expression { $$ = $1 * $3; }
  |          expression '/' expression { 
               if($3 == 0.0)
                 yyerror("divide by zero");
               else
                 $$ = $1 / $3;
             }
  |          '-' expression %prec UMINUS { $$ = -$2; }
  |          '(' expression ')' { $$ = $2; }
  |          NUMBER
  |          NAME { $$ = $1->value; }
  |          NAME '(' expression ')' {
               if($1->funcp)
                 $$ = ($1->funcp)($3);
               else
                 printf("%s not a function", $1->name);
             }
  ;

%%

int main()
{
  extern double sqrt(), exp(), log();
  addfunc("sqrt", sqrt);
  addfunc("exp" , exp);
  addfunc("log" , log);
  
  yyparse();
}

/* look up a symbol table entry, add if not present */
struct symtab * symlook(char *s)
{
  char *p;
  struct symtab *sp;
  
  for(sp = symtab; sp < &symtab[NUMBER_SYM]; sp++) {
    /* if we already have it return it */
    if(sp->name && !strcmp(sp->name, s))
      return sp;
    
    /* if entry is free use it */
    if(!sp->name) {
      /* need to copy yytext, otherwise you loss it on the next scan */
      sp->name = strdup(s);
      return sp;
    }
    /* otherwise continue to next entry */
  }
  yyerror("Too many symbols");
  exit(1);
}

void addfunc(char* name, double (*f)())
{
  struct symtab *sp = symlook(name);
  sp->funcp = f;
}