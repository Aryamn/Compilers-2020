#include <stdio.h>
#include "y.tab.h"
extern int yyparse();
extern int yylex();
extern char* yytext; 
int main()
{
    printf("\n\n________Parser_Starts_from_here_________\n\n");
    extern  FILE *yyin;
    yyin = fopen("ass4_18CS30007_test.c","r");

    extern int yydebug;         //give all information about reduction , push , pop in stack
    yydebug = 0;                //Set yydebug=1 to show all information about the stack 


    int res=yyparse();
    if(res==1)
    {  
        printf("\n\n________Compiler__Result_________\n\n"); 
        printf("Syntax Error\n\n");
    }
    else if(res==0)
    {
        printf("\n\n________Compiler__Result_________\n\n");
        printf("Compiled Successfuly\n\n");
    }

    else
    {
        printf("\n\n________Compiler__Result_________\n\n");
        printf("Memory Exhausation\n\n");
    }
    
    return 0;
}