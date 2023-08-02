%{
#include <stdio.h>
int yylex();
void yyerror();

double variables[26];
%}

%union {
  double val;
  int varno;
}

%token <varno> NAME
%token <val>  NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS
%type <val> expression

%%

statement_list: statement '\n'
  |             statement_list statement '\n'
  ;

statement: NAME '=' expression { variables[$1] = $3; }
  |        expression { printf("= %g\n", $1); }
  ;

expression: expression '+' expression { $$ = $1 + $3; }
  |         expression '-' expression { $$ = $1 - $3; }
  |         expression '*' expression { $$ = $1 * $3; }
  |         expression '/' expression
              {
                if ($3 == 0) yyerror("cannot divide by 0");
                else $$ = $1 / $3;
              }
  |         '-' expression %prec UMINUS { $$ = -$2; }
  |         '(' expression ')' { $$ = $2; }
  |         NUMBER { $$ = $1; }
  |         NAME { $$ = variables[$1]; }
  ;

%%

int main()
{
  yyparse();
}
