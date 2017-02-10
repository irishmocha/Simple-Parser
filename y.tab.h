#ifndef _Y_TAB_H
#define _Y_TAB_H

#define INT		258
#define	FLOAT 		259
#define ID		260
#define IF		261
#define ELSE		262
#define INTVALUE	263
#define FLOATVALUE	264
#define BIN_OP		310
#define UPOS		265
#define UNEG		266
//#define ARRAY				311
//#define INTARRAY		314


int yylex(void);
typedef union {
	//char id;
	char charcter;
	int integer;
	float real;
	int sizeOfArray;
	int indexOfArray;

} yylType;

#endif
