%{
#include "mgl.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int screen_done = 1;
char *act_str;
char *cmd_str;
char *item_str;
%}

%union {
  char *string; /* buffer */
  int cmd; /* value */
}

%token <string> QSTRING ID COMMENT 
%token <cmd> SCREEN TITLE ITEM COMMAND ACTION EXECUTE EMPTY
%token <cmd> MENU QUIT IGNORE ATTRIBUTE VISIBLE INVISIBLE END

%type <cmd> action line attribute command
%type <string> id qstring

%start screens

%%

screens: /* empty */
       | screens screen
       ;

screen: screen_name screen_contents screen_terminator
      | screen_name screen_terminator
      ;

screen_name: SCREEN ID { start_screen($2); }
           | SCREEN { start_screen(strdup("default")); }
           ;

screen_terminator: END ID { end_screen($2); }
                 | END { end_screen(strdup("default")); }
                 ;

screen_contents: titles lines
               ;

titles: /* empty */
      | titles title
      ;

title: TITLE QSTRING { add_title($2); }
     ;
     
items: /* empty */
     | items item
     ;

lines: /* empty */
     | lines line
     ;

line: ITEM QSTRING command ACTION action attribute
    ;

item: ITEM command action
    ;

command: /* empty */
       | COMMAND ID
       ;

action: EXECUTE QSTRING
      {
        act_str = $2;
        $$ = EXECUTE;
      }
      | MENU ID
      {
        act_str = malloc(strlen($2) + 6);
        strcpy(act_str, "menu_");
        strcat(act_str, $2);
        free($2);
        $$ = MENU;
      }
      | QUIT { $$ = QUIT; }
      | IGNORE { $$ = IGNORE; }
      ;

attribute: /* empty */ { $$ = VISIBLE; }
         | ATTRIBUTE VISIBLE { $$ = VISIBLE; }
         | ATTRIBUTE INVISIBLE { $$ = INVISIBLE; }
         ;

id: ID { $$ = $1; }
  | QSTRING { $$ = $1; }
  ;

qstring: QSTRING { $$ = $1; }
       | ID { $$ = $1; }
       ;
%%

char *progname = "mgl";
int lineno = 1;

#define DEFAULT_OUTFILE "screen.out"

char *usage = "%s: usage [infile] [outfile]\n";

void main(int argc, char **argv)
{
  char *outfile;
  char *infile;
  extern FILE *yyin, *yyout;
  
  progname = argv[0];
  
  if (argc > 3)
  {
    fprintf(stderr, usage, progname);
    exit(1);
  }
  
  if (argc > 1)
  {
    infile = argv[1];
    yyin = fopen(infile, "r");
    if (yyin == NULL)
    {
      fprintf(stderr, "%s: cannot read from %s\n", progname, infile);
      exit(1);
    }
  }
  if (argc > 2)
  {
    outfile = argv[2];
  }
  else
  {
    outfile = DEFAULT_OUTFILE;
  }
  yyout = fopen(outfile, "w");
  if (yyout == NULL)
  {
    fprintf(stderr, "%s: cannot write to %s\n", progname, infile);
    exit(1);
  }
  
  yyparse();
  
  end_file();
  if (!screen_done)
  {
    warning("premature EOF", (char *)0);
    unlink(outfile);
    exit(1);
  }
  exit(0);
}

void warning(char *s, char *t)
{
  fprintf(stderr, "%s: %s", progname, s);
  if (t)
  {
    fprintf(stderr, "%s", t);
  }
  fprintf(stderr, "line: %d\n", lineno);
}