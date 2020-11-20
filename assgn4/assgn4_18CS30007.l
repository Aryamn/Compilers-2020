%{
    #include <stdio.h>
    #include<string.h>
    #include "y.tab.h"
%}
DIGIT						[0-9]
IDENTIFIER_NONDIGIT 		"_"|[a-zA-Z]
IDENTIFIER 					{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*
 
/*Integer Constants*/
NONZERO_DIGIT				[1-9]
INTEGER_CONSTANT			"0"|{NONZERO_DIGIT}({DIGIT})*|([0])+

/*Floating Constants*/
DIGIT_SEQUENCE				{DIGIT}+
SIGN 						"-"|"+"
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT			({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT			({DIGIT_SEQUENCE}{EXPONENT_PART})|({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)

/*Character Constants*/
ESCAPE_SEQUENCE				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			"\'"{C_CHAR_SEQUENCE}"\'"

/*Constants*/
CONSTANT					{CHARACTER_CONSTANT}|{FLOATING_CONSTANT}|{INTEGER_CONSTANT}

/*String Literal*/
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""

/*Comments*/
SINGLE_LINE_COMM			"//"[^\n]*
CONTENT 					[^*]|[*][^/]
MULTI_LINE_COMM 			"/*"{CONTENT}*"*/"
COMM						{SINGLE_LINE_COMM}|{MULTI_LINE_COMM}

/*Whitespaces*/
WS							"\n"|" "|"\t"|{COMM}
%%
"break"				{return BREAK;}
"case"				{return CASE;}
"char"				{return CHAR;}
"continue"			{return CONTINUE;}
"default"			{return DEFAULT;}
"do"				{return DO;}
"double"			{return DOUBLE;}
"else"				{return ELSE;}
"extern"			{return EXTERN;}
"float"				{return FLOAT;}
"for"				{return FOR;}
"goto"				{return GOTO;}
"if"				{return IF;}
"int"				{return INT;}
"long"				{return LONG;}
"return"			{return RETURN;}
"short"				{return SHORT;}
"sizeof"			{return SIZEOF;}
"static"			{return STATIC;}
"switch"			{return SWITCH;}
"typedef"			{return TYPEDEF;}
"union"				{return UNION;}
"unsigned"			{return UNSIGNED;}
"void"				{return VOID;}
"while"				{return WHILE;}
"volatile"			{return VOLATILE;}
"restrict"			{return RESTRICT;}
"const"				{return CONST;}
"inline"			{return INLINE;}

{IDENTIFIER}	{
	return IDENTIFIER;
}

{INTEGER_CONSTANT}	{
	return INTEGER_CONSTANT;
}

{FLOATING_CONSTANT}	{
	return FLOATING_CONSTANT;
}

{CHARACTER_CONSTANT} {
	return CHARACTER_CONSTANT;
}

{STRING_LITERAL} {
	return STRING_LITERAL;
}


"["    {return SQUAREOP;}  
"]"    {return SQUARECL;}
"("    {return ROUNDOP;}
")"    {return ROUNDCL;}
"{"    {return CURLOP;}
"}"    {return CURLCL;}
"."    {return  DOT;}
"->"   {return ARROW;}

"++"   {return INC;}
"--"    {return DEC;}
"&"     {return AMP;}
"*"     {return MUL;}
"+"     {return ADD;}
"-"     {return SUB;}
"~"     {return NEG;}
"!"     {return EXCLAIM;}

"/"     {return DIV;}
"%"     {return MODULO;}
"<<"    {return SHL;}
">>"    {return SHR;}
"<"     {return LT;}
">"     {return GT;}
"<="    {return LTE;}
">="    {return GTE;}
"=="    {return EQ;}
"!="    {return NEQ;}
"^"     {return BITXOR;}
"|"     {return BITOR;}
"&&"    {return AND;}
"||"    {return OR;}
"?"     {return QUESTION;}
":"     {return COLON;}
";"     {return SEMICOLON;}
"..."   {return DOTS;}
"="     {return ASSIGN;}
"*="    {return STAREQ;}
"/="    {return DIVEQ;}
"%="    {return MODEQ;}
"+="    {return PLUSEQ;}
"-="    {return MINUSEQ;}
"<<="   {return SHLEQ;}
">>="   {return SHREQ;}
"&="    {return ANDEQ;}
"^="    {return XOREQ;}
"|="    {return OREQ;}
","     {return COMMA;}
"#"     {return HASH;}
{WS}    {

}
%%