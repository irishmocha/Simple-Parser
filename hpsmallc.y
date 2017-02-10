%{
#include <stdio.h>
#include <stdlib.h>
#include "symboltable.c"
#define ARRAY_MAX	10

int yylex (void);		/* type of yylex() */
void yyerror (char const *s);
#define YYDEBUG 1		/* enables compilation with trace */


char data=' ';
int i;
int j;
int commacount = 0;


%}

%union {
	int integer;
	float real;
	char* string;
  char character;
}

%token INT FLOAT IF ELSE SPACE NG_OP EQ_OP
%token <integer> INTVALUE <real> FLOATVALUE
%token '(' ')' '{' '}' '[' ']' ';' ',' '=' '\n' ' '
%token exit_command
%type <integer> declaretype declaration

%token <character> ID
%type <character> var
%type <character> additional_declaration declaration_finalizer array_declaration
%type <real> exp factor term NUMBER

%left '-' '+'
%left '*' '/'
%left UNEG UPOS
%nonassoc IFX
%nonassoc ELSE
%nonassoc ')'

%%

program: declarations statements
;

line:			'\n'
;

declarations:
| declarations declaration
;

declaration:
declaretype ID declaration_finalizer line { symbolTypeSetter($1, $2);
                                            if((int)$3 < ARRAY_MAX)
                                              arraySetter($2, (int)$3); }

;

declaration_finalizer:
';'
| additional_declaration declaration_finalizer  { $$ = $1; }
| array_declaration  declaration_finalizer      { $$ = $1; }
;

additional_declaration:
',' ID		{symbolTypeSetter(99, $2);}
;

array_declaration:
'[' INTVALUE ']'   {$$=$2; }
;

declaretype:
 INT              { $$ = 1; }
| FLOAT           { $$ = 2; }
;

statements:
| statements statement
;

statement:
';'
| assignment
| ifelse
| line
;

assignment:
var '=' exp              { setValue($1,$3); }
;


var:	ID										{$$=$1; }
| ID '[' INTVALUE ']'					{$$=$1; setIndex($3);}
;

ifelse:
IF '(' exp ')' '{' statements '}'
;

exp: factor {$$ = $1; }
 | exp '+' factor { $$ = $1 + $3; }
 | exp '-' factor { $$ = $1 - $3; }
 ;

factor: term {$$ = $1;}
 | factor '*' term { $$ = $1 * $3; }
 | factor '/' term { $$ = $1 / $3; }
 ;

term: NUMBER {$$ = $1;}
|ID '[' NUMBER ']' {$$= getArrayValue($1, $3);	}
;

NUMBER:
INTVALUE					{$$=$1;}
|FLOATVALUE				{$$=$1;}
;

%%
int main() {
  initializer();
	int resultOfyyparse;
	resultOfyyparse = yyparse();
	printSymbolTable();
	return resultOfyyparse;
}

void yyerror (char const *s) { fprintf(stderr, "%s\n", s); }
