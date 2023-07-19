%{
/*
   check if a number is divisible by 2, aka even
 */

%}
%%

[\t ]+		/* ignore white space */ ;

[0-9]*[02468]  { printf("%s: is even\n", yytext); }

[0-9]*  { printf("%s: is odd\n", yytext); }

[a-zA-Z]+  { printf("%s: is not a number\n", yytext); }

.|\n  { ECHO; /* normal default anyway */ }
%%

int main()
{
	yylex();
}
