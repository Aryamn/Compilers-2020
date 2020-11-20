%{
#include <stdio.h>
extern int yylex();
void yyerror(const char*);
%}

%token BREAK
%token EXTERN
%token RETURN
%token VOID
%token CASE
%token FLOAT
%token SHORT
%token CHAR
%token FOR
%token WHILE
%token GOTO
%token SIZEOF
%token BOOL
%token CONTINUE
%token IF
%token STATIC
%token DEFAULT
%token STRUCT
%token DO
%token INT
%token SWITCH
%token DOUBLE
%token LONG
%token TYPEDEF
%token ELSE
%token UNION
%token IDENTIFIER
%token INTEGER_CONSTANT
%token FLOATING_CONSTANT
%token CHARACTER_CONSTANT
%token STRING_LITERAL
%token SQUAREOP
%token SQUARECL
%token ROUNDOP
%token ROUNDCL
%token CURLOP
%token CURLCL
%token DOT
%token ARROW
%token INC
%token DEC
%token AMP
%token MUL
%token ADD
%token SUB
%token NEG
%token EXCLAIM
%token DIV
%token MODULO
%token SHL
%token SHR
%token LT
%token GT
%token LTE
%token GTE
%token EQ
%token NEQ
%token BITXOR
%token BITOR
%token AND
%token OR
%token QUESTION
%token COLON
%token SEMICOLON
%token DOTS
%token ASSIGN
%token STAREQ
%token DIVEQ
%token MODEQ
%token PLUSEQ
%token MINUSEQ
%token SHLEQ
%token SHREQ
%token ANDEQ
%token XOREQ
%token OREQ
%token COMMA
%token HASH
%token VOLATILE
%token CONST
%token	RESTRICT
%token INLINE
%token UNSIGNED

%start translation_unit
%nonassoc THEN 
%nonassoc ELSE
%%
primary_expression:
	IDENTIFIER	{printf("PRIMARY_EXPRESSION\n");}
	|INTEGER_CONSTANT	{printf("PRIMARY_EXPRESSION\n");}
	|FLOATING_CONSTANT	{printf("PRIMARY_EXPRESSION\n");}
	|CHARACTER_CONSTANT 	{printf("PRIMARY_EXPRESSION\n");}
	|STRING_LITERAL	{printf("PRIMARY_EXPRESSION\n");}
	|ROUNDOP expression ROUNDCL	{printf("PRIMARY_EXPRESSION\n");}
	;

argument_expression_list_opt:
 	argument_expression_list
    |
    ;

postfix_expression:
    primary_expression	{printf("POSTFIX_EXPRESSION\n");}
    |postfix_expression SQUAREOP expression SQUARECL	{printf("POSTFIX_EXPRESSION\n");}
    |postfix_expression ROUNDOP argument_expression_list_opt ROUNDCL	{printf("POSTFIX_EXPRESSION\n");}
    |postfix_expression DOT IDENTIFIER	{printf("POSTFIX_EXPRESSION\n");}
    |postfix_expression ARROW IDENTIFIER	{printf("POSTFIX_EXPRESSION\n");}
    |postfix_expression INC	{printf("POSTFIX_EXPRESSION\n");}
	|postfix_expression DEC	{printf("POSTFIX_EXPRESSION\n");}
    |ROUNDOP type_name ROUNDCL CURLOP initializer_list CURLCL	{printf("POSTFIX_EXPRESSION\n");}
    |ROUNDOP type_name ROUNDCL CURLOP initializer_list COMMA CURLCL	{printf("POSTFIX_EXPRESSION\n");}
	 ;



argument_expression_list:
    assignment_expression	{printf("argument_expression_list\n");}
	|argument_expression_list COMMA assignment_expression	{printf("argument_expression_list\n");}

	;

unary_expression:
    postfix_expression	{printf("UNARY_EXPRESSION\n");}
	|INC unary_expression	{printf("UNARY_EXPRESSION\n");}
	|DEC unary_expression	{printf("UNARY_EXPRESSION\n");}
	|unary_operator cast_expression	{printf("UNARY_EXPRESSION\n");}
	|SIZEOF unary_expression	{printf("UNARY_EXPRESSION\n");}
	|SIZEOF ROUNDOP type_name ROUNDCL	{printf("UNARY_EXPRESSION\n");}
	;

unary_operator:
    AMP		{printf("UNARY_OPERATOR\n");}
	|MUL	{printf("UNARY_OPERATOR\n");}
	|ADD	{printf("UNARY_OPERATOR\n");}
	|SUB	{printf("UNARY_OPERATOR\n");}
	|NEG	{printf("UNARY_OPERATOR\n");}
	|EXCLAIM	{printf("UNARY_OPERATOR\n");}

	;

cast_expression:
    unary_expression	{printf("CAST_EXPRESSION\n");}
	|ROUNDOP type_name ROUNDCL cast_expression	{printf("CAST_EXPRESSION\n");}
	;

multiplicative_expression:
    cast_expression	{printf("MULTIPLICATIVE_EXPRESSION\n");}
	|multiplicative_expression MUL cast_expression	{printf("MULTIPLICATIVE_EXPRESSION\n");}
	|multiplicative_expression DIV cast_expression	{printf("MULTIPLICATIVE_EXPRESSION\n");}
	|multiplicative_expression MODULO cast_expression	{printf("MULTIPLICATIVE_EXPRESSION\n");}
	;

additive_expression:
    multiplicative_expression	{printf("ADDITIVE_EXPRESSION\n");}
	|additive_expression ADD multiplicative_expression	{printf("ADDITIVE_EXPRESSION\n");}
	|additive_expression SUB multiplicative_expression	{printf("ADDITIVE_EXPRESSION\n");}
	;

shift_expression:
    additive_expression	{printf("SHIFT_EXPRESSION\n");}
	|shift_expression SHL additive_expression	{printf("SHIFT_EXPRESSION\n");}
	|shift_expression SHR additive_expression	{printf("SHIFT_EXPRESSION\n");}
	;

relational_expression:
    shift_expression	{printf("RELATIONAL_EXPRESSION\n");}
	|relational_expression LT shift_expression	{printf("RELATIONAL_EXPRESSION\n");}
	|relational_expression GT shift_expression	{printf("RELATIONAL_EXPRESSION\n");}
	|relational_expression LTE shift_expression	{printf("RELATIONAL_EXPRESSION\n");}
	|relational_expression GTE shift_expression	{printf("RELATIONAL_EXPRESSION\n");}
	;

equality_expression:
    relational_expression	{printf("EQUALITY_EXPRESSION\n");}
	|equality_expression EQ relational_expression	{printf("EQUALITY_EXPRESSION\n");}
	|equality_expression NEQ relational_expression	{printf("EQUALITY_EXPRESSION\n");}
	;

AND_expression:
    equality_expression	{printf("AND_EXPRESSION\n");}
	|AND_expression AMP equality_expression	{printf("AND_EXPRESSION\n");}
	;

exclusive_OR_expression:
    AND_expression	{printf("EXCLUSIVE_OR_EXPRESSION\n");}
	|exclusive_OR_expression BITXOR AND_expression	{printf("EXCLUSIVE_OR_EXPRESSION\n");}
	;

inclusive_OR_expression:
    exclusive_OR_expression	{printf("INCLUSIVE_OR_EXPRESSION\n");}
	|inclusive_OR_expression BITOR exclusive_OR_expression	{printf("INCLUSIVE_OR_EXPRESSION\n");}
	;

logical_AND_expression:
    inclusive_OR_expression	{printf("LOGICAL_AND_EXPRESSION\n");}
	|logical_AND_expression AND inclusive_OR_expression	{printf("LOGICAL_AND_EXPRESSION\n");}
	;

logical_OR_expression:
    logical_AND_expression	{printf("LOGICAL_OR_EXPRESSION\n");}
	|logical_OR_expression OR logical_AND_expression	{printf("LOGICAL_OR_EXPRESSION\n");}
	;

conditional_expression:
    logical_OR_expression	{printf("CONDITIONAL_EXPRESSION\n");}
	|logical_OR_expression QUESTION expression COLON conditional_expression	{printf("CONDITIONAL_EXPRESSION\n");}	
	;

assignment_expression:
    conditional_expression	{printf("ASSIGNMENT_EXPRESSION\n");}
	|unary_expression assignment_operator assignment_expression	{printf("ASSIGNMENT_EXPRESSION\n");}
	;

assignment_operator:
    ASSIGN	{printf("ASSIGNMENT_OPERATOR\n");}
	|STAREQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|DIVEQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|MODEQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|PLUSEQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|MINUSEQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|SHLEQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|SHREQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|ANDEQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|XOREQ	{printf("ASSIGNMENT_OPERATOR\n");}
	|OREQ	{printf("ASSIGNMENT_OPERATOR\n");}	
	;

expression:
    assignment_expression		{printf("EXPRESSION\n");}
	|expression COMMA assignment_expression	{printf("EXPRESSION\n");}
	;

constant_expression:
    conditional_expression	{printf("CONSTANT_EXPRESSION\n");}
	;

init_declarator_list_opt:
    init_declarator_list
	|;


declaration:
    declaration_specifiers init_declarator_list_opt SEMICOLON	{printf("DECLARATION\n");}
	;

declaration_specifiers_opt:
    declaration_specifiers
	|
	;


declaration_specifiers:
    storage_class_specifier declaration_specifiers_opt	{printf("DECLARATION_SPECIFIERS\n");}
	|type_specifier declaration_specifiers_opt	{printf("DECLARATION_SPECIFIERS\n");}
	|type_qualifier declaration_specifiers_opt	{printf("DECLARATION_SPECIFIERS\n");}
	|function_specifier declaration_specifiers_opt	{printf("DECLARATION_SPECIFIERS\n");}
	;


init_declarator_list:
    init_declarator	{printf("INIT_DECLARATOR_LIST\n");}
	|init_declarator_list COMMA init_declarator	{printf("INIT_DECLARATOR_LIST\n");}
	;

init_declarator:
    declarator	{printf("INIT_DECLARATOR\n");}
	|declarator ASSIGN initializer	{printf("INIT_DECLARATOR\n");}
	;

storage_class_specifier:
     EXTERN	{printf("STORAGE_CLASS_SPECIFIER\n");}
	| STATIC	{printf("STORAGE_CLASS_SPECIFIER\n");}
	;

type_specifier:
     VOID	{printf("TYPE_SPECIFIER\n");}
	| CHAR	{printf("TYPE_SPECIFIER\n");}
	| SHORT	{printf("TYPE_SPECIFIER\n");}
	| INT	{printf("TYPE_SPECIFIER\n");}
	| LONG	{printf("TYPE_SPECIFIER\n");}
	| FLOAT	{printf("TYPE_SPECIFIER\n");}
	| DOUBLE	{printf("TYPE_SPECIFIER\n");}
	;

specifier_qualifier_list_opt:
    specifier_qualifier_list
	|
	;


specifier_qualifier_list: 
    type_specifier specifier_qualifier_list_opt	{printf("SPECIFIER_QUALIFIER_LIST\n");}
	| type_qualifier specifier_qualifier_list_opt {printf("SPECIFIER_QUALIFIER_LIST\n");}
	;



type_qualifier:
    CONST		{printf("TYPE_QUALIFIER\n");}
	|RESTRICT		{printf("TYPE_QUALIFIER\n");}
	|VOLATILE		{printf("TYPE_QUALIFIER\n");}
	;

function_specifier:
    INLINE	{printf("FUNCTION_SPECIFIER\n");}
	;

pointer_opt:
    pointer
	|
	;

declarator:
    pointer_opt direct_declarator	{printf("DECLARATOR\n");}
	;


type_qualifier_list_opt:
    type_qualifier_list
	|
	;

assignment_expression_opt:  
    assignment_expression
	|
	;

identifier_list_opt:
	identifier_list
	|
	;

direct_declarator:
    IDENTIFIER	{printf("DIRECT_DECLARATOR\n");}
	|ROUNDOP declarator ROUNDCL	{printf("DIRECT_DECLARATOR\n");}
	|direct_declarator SQUAREOP type_qualifier_list_opt assignment_expression_opt SQUARECL	{printf("DIRECT_DECLARATOR\n");}
	| direct_declarator SQUAREOP STATIC type_qualifier_list_opt assignment_expression SQUARECL	{printf("DIRECT_DECLARATOR\n");}
	| direct_declarator SQUAREOP type_qualifier_list STATIC assignment_expression SQUARECL	{printf("DIRECT_DECLARATOR\n");}
	| direct_declarator SQUAREOP type_qualifier_list_opt MUL SQUARECL	{printf("DIRECT_DECLARATOR\n");}
	| direct_declarator ROUNDOP parameter_type_list ROUNDCL	{printf("DIRECT_DECLARATOR\n");}
	| direct_declarator ROUNDOP identifier_list_opt ROUNDCL	{printf("DIRECT_DECLARATOR\n");}
	;

pointer:
    MUL type_qualifier_list_opt	{printf("POINTER\n");}
	|MUL type_qualifier_list_opt pointer	{printf("POINTER\n");}
	;

type_qualifier_list:
    type_qualifier	{printf("TYPE_QUALIFIER_LIST\n");}
	|type_qualifier_list type_qualifier	{printf("TYPE_QUALIFIER_LIST\n");}
	;

parameter_type_list:
    parameter_list	{printf("PARAMETER_TYPE_LIST\n");}
	|parameter_list COMMA DOTS	{printf("PARAMETER_TYPE_LIST\n");}
	;

parameter_list:
    parameter_declaration	{printf("PARAMETER_LIST\n");}
	|parameter_list COMMA parameter_declaration	{printf("PARAMETER_LIST\n");}
	;

parameter_declaration:
    declaration_specifiers declarator	{printf("PARAMETER_DECLARATION\n");}
	|declaration_specifiers	{printf("PARAMETER_DECLARATION\n");}
	;

identifier_list:
    IDENTIFIER	{printf("IDENTIFIER_LIST\n");}
	|identifier_list COMMA IDENTIFIER	{printf("IDENTIFIER_LIST\n");}
	;

type_name:
    specifier_qualifier_list	{printf("TYPE_NAME\n");}
	;

initializer:
    assignment_expression	{printf("INITIALIZER\n");}
	|CURLOP initializer_list CURLCL	{printf("INITIALIZER\n");}
	|CURLOP initializer_list COMMA CURLCL	{printf("INITIALIZER\n");}
	;

designation_opt:
    designation
	|
	;

initializer_list:
    designation_opt initializer	{printf("INITIALIZER_LIST\n");}
	|initializer_list COMMA designation_opt initializer	{printf("INITIALIZER_LIST\n");}
	;

designation:
    designator_list ASSIGN	{printf("DESIGNATION\n");}
	;

designator_list:
    designator	{printf("DESIGNATOR_LIST\n");}
	|designator_list designator	{printf("DESIGNATOR_LIST\n");}
	;

designator:
    SQUAREOP constant_expression SQUARECL	{printf("DESIGNATOR\n");}
	|DOT IDENTIFIER	{printf("DESIGNATOR\n");}
	;

statement:
    labeled_statement	{printf("STATEMENT\n");}
	|compound_statement	{printf("STATEMENT\n");}
	|expression_statement	{printf("STATEMENT\n");}
	|selection_statement	{printf("STATEMENT\n");}
	|iteration_statement	{printf("STATEMENT\n");}
	|jump_statement	{printf("STATEMENT\n");}
	;

labeled_statement:
    IDENTIFIER COLON statement	{printf("LABELED_STATEMENT\n");}
	|CASE constant_expression COLON statement	{printf("LABELED_STATEMENT\n");}
	|DEFAULT COLON statement	{printf("LABELED_STATEMENT\n");}
	;

block_item_list_opt:
    block_item_list
	|
	;

compound_statement:
    CURLOP block_item_list_opt CURLCL	{printf("COMPOUND_STATEMENT\n");}
	;

block_item_list:
    block_item	{printf("BLOCK_ITEM_LIST\n");}
	|block_item_list block_item	{printf("BLOCK_ITEM_LIST\n");}
	;

block_item:
    declaration	{printf("BLOCK_ITEM\n");}
	|statement	{printf("BLOCK_ITEM\n");}
	;

expression_opt:
    expression
	|
	;

expression_statement:
    expression_opt SEMICOLON	{printf("EXPRESSION_STATEMENT\n");}
	;

selection_statement:	
	IF ROUNDOP expression ROUNDCL statement %prec THEN	{printf("SELECTION_STATEMENT\n");}
	|IF ROUNDOP expression ROUNDCL statement ELSE statement	{printf("SELECTION_STATEMENT\n");}
	|SWITCH ROUNDOP expression ROUNDCL statement	{printf("SELECTION_STATEMENT\n");}
	;

iteration_statement:
    WHILE ROUNDOP expression ROUNDCL statement	{printf("ITERATION_STATEMENT\n");}
	|DO statement WHILE ROUNDOP expression ROUNDCL SEMICOLON	{printf("ITERATION_STATEMENT\n");}
	|FOR ROUNDOP expression_opt SEMICOLON expression_opt SEMICOLON expression_opt ROUNDCL statement	{printf("ITERATION_STATEMENT\n");}
	|FOR ROUNDOP declaration expression_opt SEMICOLON expression_opt ROUNDCL statement	{printf("ITERATION_STATEMENT\n");}
	;

jump_statement:
    GOTO IDENTIFIER SEMICOLON		{printf("JUMP_STATEMENT\n");}
	|CONTINUE SEMICOLON		{printf("JUMP_STATEMENT\n");}
	|BREAK SEMICOLON		{printf("JUMP_STATEMENT\n");}
	|RETURN expression_opt SEMICOLON	{printf("JUMP_STATEMENT\n");}
	;

translation_unit:
    external_declaration	{printf("TRANSLATION_UNIT\n");}
	|translation_unit external_declaration	{printf("TRANSLATION_UNIT\n");}
	;

external_declaration:
    function_definition	{printf("EXTERNAL_DECLARATION\n");}
	|declaration	{printf("EXTERNAL_DECLARATION\n");}
	;

declaration_list_opt:
    declaration_list
	|
	;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement
	{printf("FUNCTION_DEFINITION\n");}
	;

declaration_list:
    declaration	{printf("DECLARATION_LIST\n");}
	|declaration_list declaration	{printf("DECLARATION_LIST\n");}
	;



%%

void yyerror(const char *s) {
    printf("%s\n",s);
}
