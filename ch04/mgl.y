%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
%}

%union {
  char *string; /* buffer */
}

%token ACTION EXECUTE COMMAND IGNORE ITEM TITLE
%token <string> QSTRING ID

%%

screens: /* empty */
       | screens screen
       ;

screen: screen_name screen_contents screen_terminator
      | screen_name screen_terminator
      ;

screen_name: SCREEN ID
           | SCREEN
           ;

screen_terminator: END ID
                 | END
                 ;

screen_contents: titles lines
               ;

titles: /* empty */
      | titles title
      ;

title: TITLE QSTRING
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
      | MENU ID
      | QUIT
      | IGNORE
      ;

attribute: /* empty */
         | ATTRIBUTE VISIBLE
         | ATTRIBUTE INVISIBLE
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