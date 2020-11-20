%{
#include <stdio.h>
#include <string.h>
#define KEYWORD				1
#define IDENTIFIER 			2
#define	CONSTANT			3
#define STRING_LITERAL 		4
#define PUNCTUATOR			5
#define COMM 				6
#define INTEGER_CONSTANT	7
#define	FLOATING_CONSTANT	8
#define CHARACTER_CONSTANT	9
#define NICE				69
%}
/*Identifiers*/
DIGIT						[0-9]
IDENTIFIER_NONDIGIT 		"_"|[a-zA-Z]
IDENTIFIER 					{IDENTIFIER_NONDIGIT}({IDENTIFIER_NONDIGIT}|{DIGIT})*
 
/*Integer Constants*/
NONZERO_DIGIT				[1-9]
INTEGER_CONSTANT			"0"|{NONZERO_DIGIT}({DIGIT})*|([0])+

/*Punctuators*/
PUNCTUATOR					"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|","|"#"|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="

/*Keywords*/
KEYWORD						"break"|"case"|"char"|"continue"|"default"|"do"|"double"|"else"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"return"|"short"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"void"|"while"

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
WS							"\n"|" "|"\t"
%%
{COMM}	{
	
}

{KEYWORD} {
	return KEYWORD;
}

{INTEGER_CONSTANT}	{
	return INTEGER_CONSTANT;
}

{FLOATING_CONSTANT}	{
	return FLOATING_CONSTANT;
}

{CHARACTER_CONSTANT}	{
	return CHARACTER_CONSTANT;
}

{STRING_LITERAL} {
	return STRING_LITERAL;
}

{IDENTIFIER}	{
	return IDENTIFIER;
}

{PUNCTUATOR}	{
	return PUNCTUATOR;
}

{WS}	{

}
%%
