%{
unsigned charCount = 0, wordCount = 0, lineCount = 0;
%}

word [^ \t\n]+
eol  \n

%%

{word}	{ wordCount++; charCount += yyleng; }
{eol}	{ charCount++; lineCount++; }
.	charCount++;

%%

int main(int argc, char **argv)
{
	for (int i = 1; i < argc; i++) {
		FILE *file = fopen(argv[i], "r");
		
    if (!file) {
			fprintf(stderr, "could not open %s\n", argv[i]);
      continue;
		}
    
		yyin = file;
    yylex();
	  printf("%d\t%d\t%d\t%s\n", charCount, wordCount, lineCount, argv[i]);
	}

	return 0;
}
