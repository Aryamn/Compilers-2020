%{
#include <stdio.h>
#include "asgn6_18CS30007_translator.h"
extern int yylex();
void yyerror(const char *s);
extern string curr_var;
vector <string> defined_strings;
%}


%union {
  int intval;
  float floatval;
  char* charval;
  int instr;
  int num_params;
  sym* symp;
  symboltype* symtp;
  expr* E;
  statement* S;
  Array* A;
  char unaryOperator;
}

%token ARW
%token INCR
%token DECR
%token LFTSHF
%token RGTSHF
%token LSTEQL
%token GRTEQL
%token ISEQL
%token NEQL
%token AND
%token OR
%token THRDOT

%token MULEQL
%token DIVEQL
%token REMEQL
%token ADDEQL
%token SUBEQL
%token LFTEQL
%token RGTEQL
%token ANDEQL
%token OREQL
%token XOREQL

%token RESTRICT
%token UNSIGNED
%token BREAK 
%token EXTERN
%token RETURN
%token VOID
%token CASE 
%token FLOAT
%token SHORT
%token VOLATILE
%token CHAR
%token FOR
%token WHILE
%token CONST 
%token GOTO
%token CONTINUE
%token IF
%token STATIC
%token DEFAULT
%token INLINE
%token STRUCT
%token DO
%token INT
%token SWITCH
%token DOUBLE
%token LONG
%token TYPEDEF
%token ELSE
%token UNION
%token <symp> IDENTIFIER
%token <intval> INTEGER_CONSTANT
%token <charval> FLOATING_CONSTANT
%token <charval> CHARACTER_CONSTANT
%token <charval> STRING_LITERAL


%token SQROPEN
%token SQRCLOSE
%token CIROPEN
%token CIRCLOSE
%token CUROPEN
%token CURCLOSE
%token QST
%token COL
%token SEMICOL
%token ASG
%token XOR
%token BINOR
%token BINAND
%token MUL
%token ADD
%token SUB
%token NEG
%token EXC
%token DOT
%token DIV
%token REM
%token LST
%token GRT
%token COMMA
%token HASH


%token WS


// Expressions
%type <E>	expression
%type <E>	primary_expression 
%type <E>	multiplicative_expression
%type <E>	additive_expression
%type <E>	shift_expression
%type <E>	relational_expression 
%type <E>	equality_expression
%type <E>	AND_expression
%type <E>	XOR_expression
%type <E>	OR_expression
%type <E>	logical_AND_expression
%type <E>	logical_OR_expression
%type <E>	conditional_expression
%type <E>	assignment_expression
%type <E>	expression_statement

%type <intval> argument_expression_list
%type <intval> argument_expression_list_opt

// Array to be used later
%type <A> postfix_expression
%type <A>	unary_expression
%type <A>	cast_expression

%type <unaryOperator> unary_operator
%type <symp> constant initializer
%type <symp> direct_declarator init_declarator declarator
%type <symtp> pointer

// Auxillary non terminals M and N
%type <instr> M
%type <S> N


// Statements
%type <S>  statement
%type <S>	labeled_statement 
%type <S>	compound_statement
%type <S>	selection_statement
%type <S>	iteration_statement
%type <S>	jump_statement
%type <S>	block_item
%type <S>	block_item_list
%type <S> 	block_item_list_opt

//Start from translation_unit block
%start translation_unit

// to remove else ambiguity
%right THEN ELSE 

%%

primary_expression: IDENTIFIER
	{
		$$ = new expr();
		$$->loc = $1;
		$$->type = "not-boolean";
	}
	| constant 
	{
		$$ = new expr();
		$$->loc = $1;
	}
	| STRING_LITERAL 
	{
		$$ = new expr();
		symboltype* tmp = new symboltype("PTR");
		$$->loc = gentemp(tmp, $1);
		$$->loc->type->ptr = new symboltype("CHAR");

		defined_strings.push_back($1);
		stringstream strs;
		strs << defined_strings.size()-1;
		string temp_str = strs.str();
		char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		emit("EQUALSTR", $$->loc->name, str);

	}
	| CIROPEN expression CIRCLOSE
	{
		$$ = $2;
	}
	;

constant: INTEGER_CONSTANT
	{
		stringstream strs;
		strs << $1;			//strs is string 
		string temp_str = strs.str();	//temp_str = strs
		char* intStr = (char*) temp_str.c_str(); //convert into character pointer
		string str = string(intStr);
		$$ = gentemp(new symboltype("INTEGER"), str);
		emit("=", $$->name, $1);
	}

	| FLOATING_CONSTANT
	{
		$$ = gentemp(new symboltype("DOUBLE"), string($1));
		emit("=", $$->name, string($1));
	}
	| CHARACTER_CONSTANT
	{
		$$ = gentemp(new symboltype("CHAR"),$1);
		emit("=", $$->name, string($1));
	}
	;

postfix_expression: primary_expression
	{
		$$ = new Array ();
		$$->Array = $1->loc;
		$$->loc = $$->Array;
		$$->type = $1->loc->type;
	}
	| postfix_expression SQROPEN expression SQRCLOSE
	{
		$$ = new Array();
		$$->Array = $1->loc;					// copy the base
		$$->type = $1->type->ptr;				// type = type of element
		$$->loc = gentemp(new symboltype("INTEGER"));		// store computed address
		$$->cat = "ARR";
		
		if ($1->cat=="ARR") {						
			sym* t = gentemp(new symboltype("INTEGER"));
			stringstream strs;
		    strs <<size_type($$->type);
		    string temp_str = strs.str();
		    char* intStr = (char*) temp_str.c_str();
			string str = string(intStr);				
 			emit ("*", t->name, $3->loc->name, str);
			emit ("+", $$->loc->name, $1->loc->name, t->name);
		}
 		else {
 			stringstream strs;
		    strs <<size_type($$->type);
		    string temp_str = strs.str();
		    char* intStr1 = (char*) temp_str.c_str();
			string str1 = string(intStr1);		
	 		emit("*", $$->loc->name, $3->loc->name, str1);
 		}
 		// Mark that it contains Array address and first time computation is done
	}
	| postfix_expression CIROPEN CIRCLOSE
	{
		// no semantic action required at this stage
	}
	| postfix_expression CIROPEN argument_expression_list_opt CIRCLOSE
	{
		$$ = new Array();
		$$->Array = gentemp($1->type);
		stringstream strs;
	    strs <<$3;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);		
		emit("CALL", $$->Array->name, $1->Array->name, str);
	}
	| postfix_expression DOT IDENTIFIER
	{
		// no semantic action required at this stage
	}
	| postfix_expression ARW IDENTIFIER
	{
		// no semantic action required at this stage
	}
	| postfix_expression INCR
	{
		$$ = new Array();

		// copy $1 to $$
		$$->Array = gentemp($1->Array->type);
		emit ("=", $$->Array->name, $1->Array->name);

		// Increment $1
		emit ("+", $1->Array->name, $1->Array->name, "1");
	}
	| postfix_expression DECR
	{
		$$ = new Array();

		// copy $1 to $$
		$$->Array = gentemp($1->Array->type);
		emit ("=", $$->Array->name, $1->Array->name);

		// Decrement $1
		emit ("-", $1->Array->name, $1->Array->name, "1");
	}
	| CIROPEN type_name CIRCLOSE CUROPEN initializer_list CURCLOSE
	{
		$$ = new Array();
		$$->Array = gentemp(new symboltype("INTEGER"));
		$$->loc = gentemp(new symboltype("INTEGER"));
	}
	|  CIROPEN type_name CIRCLOSE CUROPEN initializer_list COMMA CURCLOSE
	{
		$$ = new Array();
		$$->Array = gentemp(new symboltype("INTEGER"));
		$$->loc = gentemp(new symboltype("INTEGER"));
	}
	;
argument_expression_list_opt: argument_expression_list    { $$=$1; }   
	| %empty { $$=0; }            
	;

argument_expression_list: assignment_expression
	{
		emit ("PARAM", $1->loc->name);
		$$ = 1;
	}
	| argument_expression_list COMMA assignment_expression
	{
		emit ("PARAM", $3->loc->name);
		$$ = $1+1;
	}
	;

unary_expression: postfix_expression
	{
		$$ = $1;
	}
	| INCR unary_expression
	{
		// Increment $2
		emit ("+", $2->Array->name, $2->Array->name, "1");

		// Use the same value as $2
		$$ = $2;
	}
	| DECR unary_expression
	{
		// Decrement $2
		emit ("-", $2->Array->name, $2->Array->name, "1");

		// Use the same value as $2
		$$ = $2;
	}
	| unary_operator cast_expression
	{
		$$ = new Array();
		switch ($1) {
			case '&':
				$$->Array = gentemp((new symboltype("PTR")));
				$$->Array->type->ptr = $2->Array->type; 
				emit ("=&", $$->Array->name, $2->Array->name);
				break;
			case '*':
				$$->cat = "PTR";
				$$->loc = gentemp ($2->Array->type->ptr);
				emit ("=*", $$->loc->name, $2->Array->name);
				$$->Array = $2->Array;
				break;
			case '+':
				$$ = $2;
				break;
			case '-':
				$$->Array = gentemp(new symboltype($2->Array->type->type));
				emit ("-", $$->Array->name, $2->Array->name);
				break;
			case '~':
				$$->Array = gentemp(new symboltype($2->Array->type->type));
				emit ("~", $$->Array->name, $2->Array->name);
				break;
			case '!':
				$$->Array = gentemp(new symboltype($2->Array->type->type));
				emit ("!", $$->Array->name, $2->Array->name);
				break;
			default:
				break;
		}
	}
	;

unary_operator: BINAND
	{
		$$ = '&';
	}
	| MUL 
	{
		$$ = '*';
	}
	| ADD
	{
		$$ = '+';
	}
	| SUB
	{
		$$ = '-';
	}
	| NEG
	{
		$$ = '~';
	}
	| EXC
	{
		$$ = '!';
	}
	;		

cast_expression: unary_expression
	{
		$$=$1;
	}
	| CIROPEN type_name CIRCLOSE cast_expression
	{
		$$=new Array();
		$$->Array = conv($4->Array,curr_var);
	}
	;

multiplicative_expression: cast_expression
	{
		$$ = new expr();
		if ($1->cat=="ARR") { // Array
			$$->loc = gentemp($1->loc->type);
			emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);
		}
		else if ($1->cat=="PTR") { // Pointer
			$$->loc = $1->loc;
		}
		else { // otherwise
			$$->loc = $1->Array;
		}
	}
	| multiplicative_expression MUL cast_expression
	{
		if (!typecheck ($1->loc, $3->Array) )  
		{
			cout << "curr_var Error in Program"<< endl;
		}

		else 
		{
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("*", $$->loc->name, $1->loc->name, $3->Array->name);
		}
	}
	| multiplicative_expression DIV cast_expression
	{
		if (!typecheck ($1->loc, $3->Array) ) 
		{
			cout << "curr_var Error in Program"<< endl;
		}
		
		else 
		{
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("/", $$->loc->name, $1->loc->name, $3->Array->name);
		}
		
	}
	| multiplicative_expression REM cast_expression
	{
		if (!typecheck ($1->loc, $3->Array) ) 
		{
			cout << "curr_var Error in Program"<< endl;
		}

		else
		{
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("%", $$->loc->name, $1->loc->name, $3->Array->name);
		}
		
	}
	;

additive_expression: multiplicative_expression 
	{
		$$=$1;
	}

	|additive_expression ADD multiplicative_expression 
	{
		if (!typecheck ($1->loc, $3->loc) )
			cout << "curr_var Error in Program"<< endl;

		else
		{
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("+", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		 
	}
	|additive_expression SUB multiplicative_expression 
	{
		if (!typecheck ($1->loc, $3->loc)) 
			cout << "curr_var Error in Program"<< endl;

		else
		{
			$$ = new expr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			emit ("-", $$->loc->name, $1->loc->name, $3->loc->name);
		}

		
	}
	;

shift_expression: additive_expression  {$$=$1;}
	|shift_expression LFTSHF additive_expression 
	{
		if (!($3->loc->type->type == "INTEGER"))
			cout << "curr_var Error in Program"<< endl;

		else 
		{
			$$ = new expr();
			$$->loc = gentemp (new symboltype("INTEGER"));
			emit ("<<", $$->loc->name, $1->loc->name, $3->loc->name);
		}
	 
	}


	|shift_expression RGTSHF additive_expression
	{
		if (!($3->loc->type->type == "INTEGER"))
			cout << "curr_var Error in Programm"<< endl;

		else 
		{
			$$ = new expr();
			$$->loc = gentemp (new symboltype("INTEGER"));
			emit (">>", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		 
	}
	;	

relational_expression: shift_expression {$$=$1;}
	|relational_expression LST shift_expression 
	{
		if (!typecheck ($1->loc, $3->loc))
			cout << "curr_var Error in Program"<< endl;

		else 
		{
			$$ = new expr();
			$$->type = "bool";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("<", "", $1->loc->name, $3->loc->name);
			emit ("GOTO", "");
		}
		
	}
	|relational_expression GRT shift_expression 
	{
		if (!typecheck ($1->loc, $3->loc) ) 
			cout << "curr_var Error in Program"<< endl;
		
		else
		{
			$$ = new expr();
			$$->type = "bool";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit(">", "", $1->loc->name, $3->loc->name);
			emit ("GOTO", "");
		}
		
	}
	|relational_expression LSTEQL shift_expression 
	{
		if (!typecheck ($1->loc, $3->loc))
			cout << "curr_var Error in Program"<< endl;
		else 
		{
			$$ = new expr();
			$$->type = "bool";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("<=", "", $1->loc->name, $3->loc->name);
			emit ("GOTO", "");
		}
		
	}
	|relational_expression GRTEQL shift_expression 
	{
		if (!typecheck ($1->loc, $3->loc))
			cout << "curr_var Error in Program"<< endl;

		else 
		{
			$$ = new expr();
			$$->type = "bool";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit(">=", "", $1->loc->name, $3->loc->name);
			emit ("GOTO", "");
		}

		
	}
	;

equality_expression: relational_expression {$$=$1;}

	|equality_expression ISEQL relational_expression 
	{
		if (!typecheck ($1->loc, $3->loc)) 
			cout << "curr_var Error in Program"<< endl;
		
		else
		{
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "bool";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("==", "", $1->loc->name, $3->loc->name);
			emit ("GOTO", "");
		}
		
	}
	|equality_expression NEQL relational_expression 
	{
		if (!typecheck ($1->loc, $3->loc)) 
			cout << "curr_var Error in Program"<< endl;
		else
		{
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "bool";

			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("!=", "", $1->loc->name, $3->loc->name);
			emit ("GOTO", "");
		}
		
	}
	;

AND_expression: equality_expression	{$$=$1;}
	|AND_expression BINAND equality_expression 
	{
		if (!typecheck ($1->loc, $3->loc) ) 
			cout << "curr_var Error in Program"<< endl;

		else
		{
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			
			$$ = new expr();
			$$->type = "not-boolean";

			$$->loc = gentemp (new symboltype("INTEGER"));
			emit ("&", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		
	}
	;

XOR_expression: AND_expression {$$=$1;}
	|XOR_expression XOR AND_expression 
	{
		if (!typecheck ($1->loc, $3->loc) ) 
			cout << "curr_var Error in Program"<< endl;
		else
		{
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			
			$$ = new expr();
			$$->type = "not-boolean";

			$$->loc = gentemp (new symboltype("INTEGER"));
			emit ("^", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		
	}
	;

OR_expression: XOR_expression {$$=$1;}
	| OR_expression BINOR XOR_expression
	{
		if (typecheck ($1->loc, $3->loc) ) 
			cout << "curr_var Error"<< endl;
		else
		{
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			
			$$ = new expr();
			$$->type = "not-boolean";

			$$->loc = gentemp (new symboltype("INTEGER"));
			emit ("|", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		 
	}
	;

logical_AND_expression: OR_expression {$$=$1;}
	| logical_AND_expression N AND M OR_expression 
	{
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);

		$$ = new expr();
		$$->type = "bool";

		backpatch($1->truelist, $4);
		$$->truelist = $5->truelist;
		$$->falselist = merge ($1->falselist, $5->falselist);
	}
	;

logical_OR_expression: logical_AND_expression	{$$=$1;}
	|logical_OR_expression N OR M logical_AND_expression 
	{
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);

		$$ = new expr();
		$$->type = "bool";

		backpatch ($$->falselist, $4);
		$$->truelist = merge ($1->truelist, $5->truelist);
		$$->falselist = $5->falselist;
	}
	;

M: %empty{	// To store the address of the next instruction
		$$ = nextinstr();
	};

N: %empty { 	// gaurd against fallthrough by emitting a goto
		$$  = new statement();
		$$->nextlist = makelist(nextinstr());
		emit ("GOTO","");
	}

conditional_expression: logical_OR_expression	{$$=$1;}
	|logical_OR_expression N QST M expression N COL M conditional_expression 
	{
		$$->loc = gentemp($5->loc->type);
		$$->loc->update($5->loc->type);
		emit("=", $$->loc->name, $9->loc->name);
		list<int> l = makelist(nextinstr());
		emit ("GOTO", "");

		backpatch($6->nextlist, nextinstr());
		emit("=", $$->loc->name, $5->loc->name);
		list<int> m = makelist(nextinstr());
		l = merge (l, m);
		emit ("GOTO", "");

		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		backpatch ($1->truelist, $4);
		backpatch ($1->falselist, $8);
		backpatch (l, nextinstr());
	}
	;

assignment_expression: conditional_expression	{$$=$1;}
	|unary_expression assignment_operator assignment_expression 
	{
		if($1->cat=="ARR") 
		{
			$3->loc = conv($3->loc, $1->type->type);
			emit("[]=", $1->Array->name, $1->Array->name, $3->loc->name);	
		}

		else if($1->cat=="PTR") 
		{
			emit("*=", $1->Array->name, $3->loc->name);	
		}

		else
		{
			$3->loc = conv($3->loc, $1->Array->type->type);
			emit("=", $1->Array->name, $3->loc->name);
		}
		$$ = $3;
	}
	;

assignment_operator: ASG
	{
		// no semantic action required at this stage
	}
	| MULEQL
	{
		// no semantic action required at this stage
	}
	| DIVEQL
	{
		// no semantic action required at this stage
	}
	| REMEQL
	{
		// no semantic action required at this stage
	}
	| ADDEQL
	{
		// no semantic action required at this stage
	}
	| SUBEQL	
	{
		// no semantic action required at this stage
	}
	| LFTEQL	
	{
		// no semantic action required at this stage
	}
	| RGTEQL
	{
		// no semantic action required at this stage
	}
	| ANDEQL
	{
		// no semantic action required at this stage
	}
	| XOREQL
	{
		// no semantic action required at this stage
	}
	| OREQL
	{
		// no semantic action required at this stage
	}
	;

expression: assignment_expression	{$$=$1;}
	| expression COMMA assignment_expression
	{
		// no semantic action required at this stage
	}
	;

constant_expression: conditional_expression
	{
		// no semantic action required at this stage
	}
	;


declaration: declaration_specifiers SEMICOL
	{
		// no semantic action required at this stage
	}
	| declaration_specifiers init_declarator_list SEMICOL
	{
		// no semantic action required at this stage
	}
	;

declaration_specifiers: storage_class_specifier
	{
		// no semantic action required at this stage
	}
	| storage_class_specifier declaration_specifiers
	{
		// no semantic action required at this stage
	}
	| type_specifier
	{
		// no semantic action required at this stage
	}
	| type_specifier declaration_specifiers
	{
		// no semantic action required at this stage
	}
	| type_qualifier
	{
		// no semantic action required at this stage
	}
	| type_qualifier declaration_specifiers
	{
		// no semantic action required at this stage
	}
	| function_specifier 
	{
		// no semantic action required at this stage
	}
	| function_specifier declaration_specifiers
	{
		// no semantic action required at this stage
	}
	;	

init_declarator_list: init_declarator
	{
		// no semantic action required at this stage
	}
	| init_declarator_list COMMA init_declarator
	{
		// no semantic action required at this stage
	}
	;

init_declarator: declarator	{$$=$1;}
	| declarator ASG initializer
	{
		if ($3->initial_value!="") 
			$1->initial_value=$3->initial_value;
		emit ("=", $1->name, $3->name);
	}
	;

storage_class_specifier: EXTERN
	{
		// no semantic action required at this stage
	}
	| STATIC
	{
		// no semantic action required at this stage
	}
	;	

type_specifier: VOID 
	{
		curr_var="VOID";
	}
	| CHAR 
	{
		curr_var="CHAR";
	}
	| SHORT 
	| INT 
	{
		curr_var="INTEGER";
	}
	| LONG
	| FLOAT	
	{
		curr_var="FLOAT";
	}
	| DOUBLE 
	{
		
	}
	| UNSIGNED
	
	;


specifier_qualifier_list: type_specifier specifier_qualifier_list_opt
	{
		// no semantic action required at this stage
	}
	
	| type_qualifier specifier_qualifier_list_opt
	{
		// no semantic action required at this stage
	}
	;

specifier_qualifier_list_opt: %empty {  }
	| specifier_qualifier_list  {  }
	;	

type_qualifier: CONST
	{
		// no semantic action required at this stage
	}
	| VOLATILE
	{
		// no semantic action required at this stage
	}
	| RESTRICT
	{
		// no semantic action required at this stage
	}
	;

function_specifier: INLINE
	{
		// no semantic action required at this stage
	}
	;

declarator: pointer direct_declarator
	{
		symboltype * t = $1;
		while (t->ptr !=NULL) t = t->ptr;
		t->ptr = $2->type;
		$$ = $2->update($1);
	}
	| direct_declarator
	{
		// no semantic action required at this stage
	}
	;

direct_declarator: IDENTIFIER
	{
		$$ = $1->update(new symboltype(curr_var));
		curr_sym = $$;
	}
	| CIROPEN declarator CIRCLOSE	{$$=$2;}
	| direct_declarator SQROPEN  type_qualifier_list assignment_expression SQRCLOSE
	{
		// no semantic action required at this stage
	}
	| direct_declarator SQROPEN  type_qualifier_list SQRCLOSE
	{
		// no semantic action required at this stage
	}
	| direct_declarator SQROPEN assignment_expression SQRCLOSE
	{
		symboltype * t = $1 -> type;
		symboltype * prev = NULL;
		while (t->type == "ARR") 
		{
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL)
		{
			int temp = atoi($3->loc->initial_value.c_str());
			symboltype* s = new symboltype("ARR", $1->type, temp);
			$$ = $1->update(s);
		}
		else 
		{
			prev->ptr =  new symboltype("ARR", t, atoi($3->loc->initial_value.c_str()));
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator SQROPEN SQRCLOSE
	{
		symboltype * t = $1 -> type;
		symboltype * prev = NULL;
		while (t->type == "ARR") 
		{
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) 
		{
			symboltype* s = new symboltype("ARR", $1->type, 0);
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symboltype("ARR", t, 0);
			$$ = $1->update ($1->type);
		}
	}
	| direct_declarator SQROPEN STATIC type_qualifier_list_opt assignment_expression SQRCLOSE
	{
		// no semantic action required at this stage
	}
	| direct_declarator SQROPEN type_qualifier_list_opt MUL SQRCLOSE
	{
		// no semantic action required at this stage
	}
	| direct_declarator CIROPEN F parameter_type_list CIRCLOSE
	{
		ST->name = $1->name;

		if ($1->type->type !="VOID") {
			sym *s = ST->lookup("return");
			s->update($1->type);		
		}
		$1->nested=ST;
		$1->category = "function";
		ST->parent = globalST;
		changeTable (globalST);				// Come back to globalsymbol ST
		curr_sym = $$;
	}
	| direct_declarator CIROPEN identifier_list CIRCLOSE
	{
		// no semantic action required at this stage
	}
	| direct_declarator CIROPEN F CIRCLOSE
	{
		ST->name = $1->name;

		if ($1->type->type !="VOID") {
			sym *s = ST->lookup("return");
			s->update($1->type);		
		}
		$1->nested=ST;
		$1->category = "function";
		ST->parent = globalST;
		changeTable (globalST);				// Come back to globalsymbol ST
		curr_sym = $$;
	}
	;

F: %empty 
	{ 															// Used for changing to symbol ST for a function
		if (curr_sym->nested==NULL) 
			changeTable(new symtable(""));	// Function symbol ST doesn't already exist
		else 
		{
			changeTable (curr_sym ->nested);						// Function symbol ST already exists
			emit ("FUNC", ST->name);
		}
	}
	;

type_qualifier_list_opt: %empty{}
	| type_qualifier_list{}
	;	

pointer:  MUL type_qualifier_list_opt
	{
		$$ = new symboltype("PTR");
	}
	
	| MUL type_qualifier_list_opt pointer
	{
		$$ = new symboltype("PTR", $3);
	}
	;

type_qualifier_list: type_qualifier
	{
		// no semantic action required at this stage
	}
	| type_qualifier_list type_qualifier
	{
		// no semantic action required at this stage
	}
	;


parameter_type_list: parameter_list
	{
		// no semantic action required at this stage
	}
	| parameter_list COMMA THRDOT
	{
		// no semantic action required at this stage
	}
	;

parameter_list: parameter_declaration
	{
		// no semantic action required at this stage
	}
	| parameter_list COMMA parameter_declaration
	{
		// no semantic action required at this stage
	}
	;

parameter_declaration: declaration_specifiers declarator
	{
		$2->category = "param";
	}
	| declaration_specifiers
	{
		// no semantic action required at this stage
	}
	;

identifier_list: IDENTIFIER
	{
		// no semantic action required at this stage
	}
	| identifier_list COMMA IDENTIFIER
	{
		// no semantic action required at this stage
	}
	;

type_name: specifier_qualifier_list
	{
		// no semantic action required at this stage
	}
	;


initializer: assignment_expression	{$$ = $1->loc;}
	| CUROPEN initializer_list CURCLOSE
	{
		// no semantic action required at this stage
	}
	| CUROPEN initializer_list COMMA CURCLOSE
	{
		// no semantic action required at this stage
	}
	;

initializer_list: 
	designation_opt initializer
	{
		// no semantic action required at this stage
	}
	| initializer_list COMMA designation_opt initializer
	{
		// no semantic action required at this stage
	}
	;

designation_opt: %empty   {  }
	| designation   {  }
	;

designation: designator_list ASG
	{
		// no semantic action required at this stage
	}
	;

designator_list: designator
	{
		// no semantic action required at this stage
	}
	| designator_list designator
	{
		// no semantic action required at this stage
	}
	;

designator: SQROPEN constant_expression SQRCLOSE
	{
		// no semantic action required at this stage
	}
	| DOT IDENTIFIER
	{
		// no semantic action required at this stage
	}
	;	

statement: labeled_statement
	{
		// no semantic action required at this stage
	}
	| compound_statement
	{
		$$=$1;
	}
	| expression_statement
	{
		$$ = new statement();
		$$->nextlist = $1->nextlist;
	}
	| selection_statement
	{
		$$=$1;
	}
	| iteration_statement
	{
		$$=$1;
	}
	| jump_statement
	{
		$$=$1;
	}
	;

labeled_statement: IDENTIFIER COL statement
	{
		$$ = new statement();
	}
	| CASE constant_expression COL statement
	{
		$$ = new statement();
	}
	| DEFAULT COL statement
	{
		$$ = new statement();
	}
	;

compound_statement: CUROPEN block_item_list_opt CURCLOSE
	{
		$$=$2;
	}
	;

block_item_list_opt: %empty  { $$=new statement(); }      
	| block_item_list   { $$=$1; }        
	;

block_item_list: block_item
	{
		$$=$1;
	}
	| block_item_list M block_item
	{
		$$=$3;
		backpatch ($1->nextlist, $2);
	}
	;

block_item: declaration
	{
		$$ = new statement();
	}
	| statement
	{
		$$ = $1;
	}
	;	

expression_statement: SEMICOL
	{
		$$ = new expr();
	}
	| expression SEMICOL
	{
		$$=$1;
	}
	;

selection_statement: IF CIROPEN expression N CIRCLOSE M statement N %prec THEN
	{
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		list<int> temp = merge ($3->falselist, $7->nextlist);
		$$->nextlist = merge ($8->nextlist, temp);
	}
	|IF CIROPEN expression N CIRCLOSE M statement N ELSE M statement 
	{
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		backpatch ($3->falselist, $10);
		list<int> temp = merge ($7->nextlist, $8->nextlist);
		$$->nextlist = merge ($11->nextlist,temp);
	}
	|SWITCH CIROPEN expression CIRCLOSE statement 
	{
		// no semantic action required at this stage
	}
	;

iteration_statement:
	WHILE M CIROPEN expression CIRCLOSE M statement 
	{
		$$ = new statement();
		convertInt2Bool($4);
		// M1 to go back to boolean again
		// M2 to go to statement if the boolean is true
		backpatch($7->nextlist, $2);
		backpatch($4->truelist, $6);
		$$->nextlist = $4->falselist;
		// Emit to prevent fallthrough
		stringstream strs;
	    strs << $2;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);

		emit ("GOTO", str);
	}
	|DO M statement M WHILE CIROPEN expression CIRCLOSE SEMICOL 
	{
		$$ = new statement();
		convertInt2Bool($7);
		// M1 to go back to statement if expression is true
		// M2 to go to check expression if statement is complete
		backpatch ($7->truelist, $2);
		backpatch ($3->nextlist, $4);

		$$->nextlist = $7->falselist;
	}
	|FOR CIROPEN expression_statement M expression_statement CIRCLOSE M statement
	{
		$$ = new statement();
		convertInt2Bool($5);
		backpatch ($5->truelist, $7);
		backpatch ($8->nextlist, $4);
		stringstream strs;
	    strs << $4;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);

		emit ("GOTO", str);
		$$->nextlist = $5->falselist;
	}
	|FOR CIROPEN expression_statement M expression_statement M expression N CIRCLOSE M statement
	{
		$$ = new statement();
		convertInt2Bool($5);
		backpatch ($5->truelist, $10);
		backpatch ($8->nextlist, $4);
		backpatch ($11->nextlist, $6);
		stringstream strs;
	    strs << $6;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		emit ("GOTO", str);
		$$->nextlist = $5->falselist;
	}
	;


jump_statement: GOTO IDENTIFIER SEMICOL
	{
		$$ = new statement();
	}
	| CONTINUE SEMICOL
	{
		$$ = new statement();
	}
	| BREAK SEMICOL
	{
		$$ = new statement();
	}
	| RETURN expression SEMICOL
	{
		$$ = new statement();
		emit("RETURN",$2->loc->name);
	}
	| RETURN SEMICOL
	{
		$$ = new statement();
		emit("RETURN","");
	}
	;

translation_unit:external_declaration
	{
		// no semantic action required at this stage
	}
	| translation_unit external_declaration
	{
		// no semantic action required at this stage
	}
	;

external_declaration: function_definition
	{
		// no semantic action required at this stage
	}
	| declaration
	{
		// no semantic action required at this stage
	}
	;

function_definition: declaration_specifiers declarator declaration_list_opt F compound_statement
	{
		emit("FUNCEND", ST->name);
		ST->parent = globalST;
		changeTable (globalST);
	}
	;

declaration_list: declaration
	{
		// no semantic action required at this stage
	}
	| declaration_list declaration
	{
		// no semantic action required at this stage
	}
	;

declaration_list_opt: %empty {  }
	| declaration_list   {  }
	;
%%

void yyerror(const char *s) 
{
	printf("Error occured : %s\n",s);
}
