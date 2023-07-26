%{
#include <limits.h>
long result = 0;
%}

%s SUM
%s PRODUCT
%s OR
%s AND

%%
end { BEGIN 0; printf("total: %ld\n", result); }

<SUM>[0-9]+  { result += atoi(yytext); }
sum          { BEGIN SUM; result = 0; }

<PRODUCT>[0-9]+  { result *= atoi(yytext); }
product          { BEGIN PRODUCT; result = 1; }

<OR>[0-9]+  { result |= atoi(yytext); }
or          { BEGIN OR; result = 0; }

<AND>[0-9]+  { result &= atoi(yytext); }
and          { BEGIN AND; result = LLONG_MAX; }

.+       ECHO;
%%

int main()
{
  yylex();
}
