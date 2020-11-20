#include <stdio.h>
#include "lex.yy.c"

extern int yylex();
extern char* yytext;

int main(){

  printf("\n\n________Test File Output From here______________\n\n");

  extern  FILE *yyin;
  yyin = fopen("ass3_18CS30007_test.c","r");    //file pointer to run test file
  int token;
  while(token=yylex()){

    switch(token) {
        //comments
        case COMM:printf("< COMM, %d, %s>\n",token,yytext); break;    //printing "comment" tokens

        //KeyWords
        case KEYWORD: printf("< KEYWORD, %d, %s >\n",token,yytext); break;    //printing "keywords" tokens
        
        // identifiers
        case IDENTIFIER: printf("< IDENTIFIER, %d, %s>\n",token,yytext); break;   //printing "identifiers" tokens
        
        //constants
        case INTEGER_CONSTANT: printf("< INTEGER_CONSTANT, %d, %s>\n",token,yytext); break;
        case FLOATING_CONSTANT: printf("< FLOATING_CONSTANT, %d, %s>\n",token,yytext); break;
        case CHARACTER_CONSTANT: printf("< CHARACTER_CONSTANT, %d, %s>\n",token,yytext); break;

        
        //string literal
        case STRING_LITERAL: printf("< STRING_LITERAL, %d, %s>\n",token,yytext); break;   //printing "string literal" tokens

        //punctuators
        case PUNCTUATOR: printf("<PUNCTUATOR, %d, %s>\n",token,yytext); break;            //printing "punctuators" tokens
    
        default:
          break;
    }
  }
    fclose(yyin);        //Closing main file after lexical analysis
    return 0;
}
