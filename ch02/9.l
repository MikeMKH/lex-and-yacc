%{
int comment, code, whitespace;
%}

%s COMMENT

open_comment ^[ \t]*"/*"
line_comment ^[ \t]*"/*".*"*/"[ \t]*\n
end_comment "*/"

%%
{open_comment}  { BEGIN COMMENT; }
{line_comment}  { comment++; }

<COMMENT>{end_comment}[ \t]*\n  { BEGIN 0; comment++;}
<COMMENT>{end_comment}          { BEGIN 0; }
<COMMENT>\n   { comment++; }
<COMMENT>.\n  { comment++; }

^[ \t]*\n  { whitespace++; }

.+"/*".*"*/".*\n  { code++; }
.*"/*".*"*/".+\n  { code++; }
.+"/*".*\n        { code++; BEGIN COMMENT; }
.\n               { code++; }

. ; /* ignore rest */
%%
int main()
{
  yylex();
  printf("code: %d,\t\tcomments: %d,\t\twhite space: %d\n", code, comment, whitespace);
  return 0;
}
