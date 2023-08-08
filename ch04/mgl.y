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