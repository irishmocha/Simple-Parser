%{

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "hpsmallc.tab.h"
int line_count = 0;

int yylex(void);

%}

%option noyywrap
%option yylineno
%x CMNT


DELIM			([ \t])
WHITESPACES		({DELIM}+)
POSI_DECI		([1-9])
DECI			(0|{POSI_DECI})
LOWER			([a-z])
LETTER			({LOWER}|[:upper:]|_)
IDENTIFIER		({LETTER}({LETTER}|{DECI})*)
REAL			([0-9]+"."[0-9]*)|([0-9]*"."[0-9]+)
DECIMAL			(0|{POSI_DECI}{DECI}*)
INT			([1-9][0-9]*|0)
ARRAY			([A-Z|a-z]*\[[0-9]*])
INTARRAY		({IDENTIFIER}" "{ARRAY})

%%
"/*"			{BEGIN CMNT;}
<CMNT>.			{;}
<CMNT>\n		{++line_count;}
<CMNT>"*/"		{BEGIN INITIAL;}
\n			{
				++line_count;
				return (int) '\n';
			}
{WHITESPACES}		{ ; }
"exit"			{return exit_command;}
if				{ return IF; }
else			{ return ELSE; }
int				{ return INT; }
float			{ return FLOAT; }

\(			{ return (int)'('; }
\)			{ return (int)')'; }
\{			{ return (int)'{'; }
\}			{ return (int)'}'; }
\[			{ return (int)'['; }
\]			{ return (int)']'; }
;			{ return (int)';'; }
,			{ return (int)','; }
=			{ return (int)'='; }
"+"				{
						yylval.integer = (int)'+';
						return yylval.integer;
					}
"-"				{
						yylval.integer = (int)'-';
						return yylval.integer;
					}
"*"			{
				yylval.integer = (int)'*';
				return yylval.integer;
			}
"/"		{
				yylval.integer = (int)'/';
				return yylval.integer;
			}
"=="	{
				yylval.string=(char *)malloc((yyleng+1)*(sizeof(char)));
				strncpy(yylval.string, yytext, yyleng + 1);
				return EQ_OP;
			}
"!="	{
				yylval.string=(char *)malloc((yyleng+1)*(sizeof(char)));
				strncpy(yylval.string, yytext, yyleng + 1);
				return NG_OP;
			}
"!"		{
				yylval.integer = (int)'!';
				return yylval.integer;
			}
{REAL} {
				yylval.real = atof(yytext);
			 	return FLOATVALUE;
		  	}

{IDENTIFIER} {
							/*yylval.string=(char *)malloc((yyleng+1)*(sizeof(char)));
							strncpy(yylval.string, yytext, yyleng + 1);*/
							yylval.character=yytext[0];
							addSymbol(yytext, yylineno);
							
							return ID;
						}
{DECIMAL}		{
				yylval.integer=atoi(yytext);
				return INTVALUE;
			}

.		{ ; }
%%
/* The function yywrap() int yywrap() {return 1;}

int main() {
	yylex();
	return 0;
}
*/
