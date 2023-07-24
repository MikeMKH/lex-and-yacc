%{
/*
   lexer for the basic grammar to use for a reverse polish notation calculator
 */
#include <stdio.h>
int yylex();
void yyerror();
void print_result();
void add();

#define push(sp, n) (*((sp)++) = (n))
#define pop(sp) (*--(sp))

int stack[2];
int *sp;
%}

%token ADD NUMBER RESULT

%%
expression: ADD	{ add(); }
  | NUMBER
	;

compute : RESULT { print_result(); }
%%

extern FILE *yyin;

int main()
{
  sp = stack;
  
	while(!feof(yyin)) {
		yyparse();
	}
}

void yyerror(s)
char *s;
{
    fprintf(stderr, "%s\n", s);
}

void add()
{
  int result = 0;
  result += pop(sp);
  result += pop(sp);
  push(sp, result);
}

void print_result()
{
  int result = pop(sp);
  printf("\t%d\n", result);
}
