%{
#include <stdio.h>
#include <string.h>
#include "asgn6_18CS30007_translator.h"
#include "y.tab.h"
%}

%option noyywrap

/* Regular Expression Definitions */

/*COMMENTS*/
SINGLE_LINE_COMMENT			[/][/][^\n]*
SEQUENCE 					[^*]|[*][^/]
MULTI_LINE_COMMENT 			[/][*]{SEQUENCE}*[*][/]

/*IDENTIFIERS*/
DIGIT						[0-9]
IDENTIFIER_NONDIGIT 		[_a-zA-Z]
IDENTIFIER 					{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*
 

/*CONSTANTS*/

/*INTEGER CONSTANT*/
NONZERO_DIGIT				[1-9]
INTEGER_CONSTANT			[0]+|{NONZERO_DIGIT}({DIGIT})*

/*FLOATING CONSTANT*/
DIGIT_SEQUENCE				{DIGIT}+
SIGN 						"+"|"-"
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT			({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT			({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})

/*CHARACTER CONSTANT*/
ESCAPE_SEQUENCE				[\\][\'\"?\\abfnrtv]
C_CHAR 						[^\'\\\n]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			([']{C_CHAR_SEQUENCE}['])

/*STRING LITERALS*/
S_CHAR  					[^\"\\\n]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				(["]{S_CHAR_SEQUENCE}?["])

WS							[ \n\t]

%%


{SINGLE_LINE_COMMENT}   {}
{MULTI_LINE_COMMENT}    {}


"break"					{return BREAK;}
"float"					{return FLOAT;}
"static"				{return STATIC;}
"case"					{return CASE;}
"for"					{return FOR;}
"struct"				{return STRUCT;}
"char"					{return CHAR;}
"goto"					{return GOTO;}
"switch"				{return SWITCH;}
"continue"				{return CONTINUE;}
"if"					{return IF;}
"typedef"				{return TYPEDEF;}
"default"				{return DEFAULT;}
"int"					{return INT;}
"union"					{return UNION;}
"do"					{return DO;}
"long"					{return LONG;}
"void"					{return VOID;}
"double"				{return DOUBLE;}
"return"				{return RETURN;}
"while"					{return WHILE;}
"else"					{return ELSE;}
"short"					{return SHORT;}
"extern" 				{return EXTERN;}
"const"					{return CONST;}
"restrict"				{return RESTRICT;}
"volatile"				{return VOLATILE;}
"inline"				{return INLINE;}

"["						{return SQROPEN;}
"]"						{return SQRCLOSE;}
"("						{return CIROPEN;}
")"						{return CIRCLOSE;}
"{"						{return CUROPEN;}
"}"						{return CURCLOSE;}
"."						{return DOT;}
"->"					{return ARW;}
"++"					{return INCR;}
"--"					{return DECR;}
"&"						{return BINAND;}
"*"						{return MUL;}
"+"						{return ADD;}
"-"						{return SUB;}
"~"						{return NEG;}
"!"						{return EXC;}
"/"						{return DIV;}
"%"						{return REM;}
"<<"					{return LFTSHF;}
">>"					{return RGTSHF;}
"<"						{return LST;}
">"						{return GRT;}
"<="					{return LSTEQL;}
">="					{return GRTEQL;}
"=="					{return ISEQL;}
"!="					{return NEQL;}
"^"						{return XOR;}
"|"						{return BINOR;}
"&&"					{return AND;}
"||"					{return OR;}
"?"						{return QST;}
":"						{return COL;}
";"						{return SEMICOL;}
"..."					{return THRDOT;}
"="						{return ASG;}
"*="					{return MULEQL;}
"/="					{return DIVEQL;}
"%="					{return REMEQL;}
"+="					{return ADDEQL;}
"-="					{return SUBEQL;}
"<<="					{return LFTEQL;}
">>="					{return RGTEQL;}
"&="					{return ANDEQL;}
"^="					{return XOREQL;}
"|="					{return OREQL;}
","						{return COMMA;}
"#"						{return HASH;}

{IDENTIFIER}    {
	yylval.symp = ST->lookup(yytext);
	return IDENTIFIER;
}
{INTEGER_CONSTANT} {
	yylval.intval = atoi(yytext);
	return INTEGER_CONSTANT;
}
{FLOATING_CONSTANT}   {
	yylval.charval = yytext;
	return FLOATING_CONSTANT;
}
{CHARACTER_CONSTANT}    {
	yylval.charval = yytext;
	return CHARACTER_CONSTANT;
}

{STRING_LITERAL}    {
	yylval.charval = yytext;
	return STRING_LITERAL;
}

{WS}					{}

%%

