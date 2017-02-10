#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE 100

typedef struct SymbolTable {
  int datatype;
  char name;
  int linenumber;
  double value;
  int* array;
} SymbolTable;

int globaldatatype = 1;
int arraySize;
static SymbolTable symbolTable[MAX_SIZE];
int indexOfArray;

void addSymbol(char* name, int linenumber) {
  int i;
  char c = ' ';
  char temp = name[0];

  for(i=0; i<MAX_SIZE; i++) {
    if(temp == symbolTable[i].name) {
      break;
    }
    if(symbolTable[i].name == c) {
      symbolTable[i].name = temp;
      symbolTable[i].linenumber = linenumber;
      break;
    }
  }
}

void initializer() {
  int i;

  for(i=0; i<MAX_SIZE; i++) {
    symbolTable[i].datatype = 0;
    symbolTable[i].name = ' ';
    symbolTable[i].linenumber = 0;
    symbolTable[i].value = 0;
  }
  printf("Initialized\n");
}

void symbolTypeSetter(int datatype, char name) {
  int i, j;
  for(i=0; i<MAX_SIZE; i++) {
    if(symbolTable[i].name == name) {
      symbolTable[i].datatype = globaldatatype;
      break;
    }
  }
  if(datatype == 1){
    globaldatatype = 2;
  }
  if(datatype == 2){
    globaldatatype = 1;
  }
}

void arraySetter(char name, int size) {
  int i;
  arraySize = size;
  for(i=0; i<MAX_SIZE; i++) {
    if(symbolTable[i].name == name) {
      symbolTable[i].array = (int*)malloc(arraySize*sizeof(int));
      symbolTable[i].array[0] = 0;
      symbolTable[i].array[1] = 0;
      symbolTable[i].array[2] = 0;
      break;
    }
  }
}

void setValue(char name, double value) {
  int i;
  int j;

  for(i=0; i<MAX_SIZE; i++) {
    if(name == 'i'){
        if(symbolTable[i].name == name) {
          symbolTable[i].array[indexOfArray] = value;
        }
    }
    if(symbolTable[i].name == name) {
      if(symbolTable[i].datatype == 1){   // INT datatype
          symbolTable[i].value = (int)value;
          break;
        }
        else if(symbolTable[i].datatype == 2) { // FLOAT datatype
          symbolTable[i].value = value;
          break;
      }
    }
  }
}

int getArrayValue(char name, int index){
  int i;
    for(i=0; i<MAX_SIZE; i++) {
      if(symbolTable[i].name == name){
        return symbolTable[i].array[index];
      }
    }
}

void setIndex(int index) {
  indexOfArray = index;
}

void printSymbolTable() {
  int i;
  printf("datatype\tname\tlinenumber\tvalue\t\n");
  for(i=0; i<9; i++) {
    printf("%d\t\t%c\t%d\t\t%.1f\n", symbolTable[i].datatype, symbolTable[i].name, symbolTable[i].linenumber, symbolTable[i].value);
  }
}
