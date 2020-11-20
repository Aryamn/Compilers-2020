%{
	#include <stdio.h>
	#include "ass5_18CS30007_18CS10006_translator.h"

	extern int yylex();
	void yyerror(const char*);
	extern string curr_var;
%}

%union {            

	int intval;		//integer value		
	char* charval;	//char value

	int instr_number;		//instruction number
	int num_params;			//number of parameters

	Expression* exprsn;		//expression
	Statement* stmnt;		//statement	

	char unaryOp;	//unary Operator		

	symboltype* sym_type;	//symbol type  
	sym* symp;		//symbol
	Array* A;  //Array 
		
} 

%token BREAK
%token FLOAT
%token STATIC
%token CASE
%token FOR
%token STRUCT
%token CHAR
%token GOTO
%token SWITCH
%token CONTINUE
%token IF
%token TYPEDEF
%token DEFAULT
%token INT
%token UNION
%token DO
%token LONG
%token VOID
%token DOUBLE
%token RETURN
%token WHILE
%token ELSE
%token SHORT
%token EXTERN
%token SIZEOF 
%token CONST
%token RESTRICT 
%token VOLATILE
%token INLINE
%token SQROPEN
%token SQRCLOSE
%token CIROPEN
%token CIRCLOSE
%token CUROPEN
%token CURCLOSE
%token DOT
%token ARW
%token INCR
%token DECR
%token BINAND
%token MUL
%token ADD
%token SUB
%token NEG
%token EXC
%token DIV
%token REM
%token LFTSHF
%token RGTSHF
%token LST
%token GRT
%token LSTEQL
%token GRTEQL
%token ISEQL
%token NEQL
%token XOR
%token BINOR
%token AND
%token OR
%token QST
%token COL
%token SEMICOL
%token THRDOT
%token ASG
%token MULEQL
%token DIVEQL
%token REMEQL
%token ADDEQL
%token SUBEQL
%token LFTEQL
%token RGTEQL
%token ANDEQL
%token XOREQL
%token OREQL
%token COMMA
%token HASH

%token <symp> IDENTIFIER 		 		
%token <intval> INTEGER_CONSTANT			
%token <charval> FLOATING_CONSTANT			
%token <charval> CHARACTER_CONSTANT				
%token <charval> STRING_LITERAL 	

%type <unaryOp> unary_operator

//number of parameters
%type <num_params> argument_expression_list argument_expression_list_opt


//Expressions
%type <exprsn> expression
%type <exprsn> primary_expression 
%type <exprsn> multiplicative_expression
%type <exprsn> additive_expression
%type <exprsn> shift_expression
%type <exprsn> relational_expression
%type <exprsn> equality_expression
%type <exprsn> AND_expression
%type <exprsn> exclusive_OR_expression
%type <exprsn> inclusive_OR_expression
%type <exprsn> logical_AND_expression
%type <exprsn> logical_OR_expression
%type <exprsn> conditional_expression
%type <exprsn> assignment_expression
%type <exprsn> expression_statement

//Statements
%type <stmnt> statement
%type <stmnt> compound_statement
%type <stmnt> selection_statement
%type <stmnt> iteration_statement
%type <stmnt> labeled_statement 
%type <stmnt> jump_statement
%type <stmnt> block_item
%type <stmnt> block_item_list
%type <stmnt> block_item_list_opt

//symbol type
%type <sym_type> pointer

//symbol
%type <symp> initializer
%type <symp> direct_declarator init_declarator declarator

//arr1s
%type <A> postfix_expression
%type <A> unary_expression
%type <A> cast_expression

//Non-terminals M and N for guarding and Backpatching
%type <instr_number> M
%type <stmnt> N


%nonassoc THEN
%nonassoc ELSE

%start translation_unit

%%

/*EXPRESSIONS*/

primary_expression:
		IDENTIFIER
		{ 
			$$=new Expression();                      //New Expression Created and Stored in symbol table			
			update_nextinstr();		  
			$$->loc=$1;
			update_nextinstr();
			$$->type="not-boolean";
			update_nextinstr();	
		}
		|INTEGER_CONSTANT
		{    
			$$=new Expression();					  //New Expression Created and Stored in temporary							
			string p = convInt2String($1); 
			update_nextinstr();
			$$->loc=gentemp(new symboltype("int"),p);
			update_nextinstr();
			emit("=",$$->loc->name,p);
			update_nextinstr();	
		}
		|FLOATING_CONSTANT
		{ 	
			$$=new Expression();					  //New Expression Created and Stored in temporary
			update_nextinstr();																			
			$$->loc=gentemp(new symboltype("float"),$1);
			update_nextinstr();
			emit("=",$$->loc->name,string($1));
			update_nextinstr();
		}	
		|CHARACTER_CONSTANT
		{ 	
			$$=new Expression();					  //New Expression Created and Stored in temporary
			update_nextinstr();																			
			$$->loc=gentemp(new symboltype("char"),$1);
			update_nextinstr();
			emit("=",$$->loc->name,string($1));
			update_nextinstr();	
		}
		|STRING_LITERAL
		{   	
			$$=new Expression();					  //New Expression Created and Stored in temporary
			update_nextinstr();																			
			$$->loc=gentemp(new symboltype("ptr"),$1);
			update_nextinstr();
			$$->loc->type->arrtype=new symboltype("char");
			update_nextinstr();	
		}
		|CIROPEN expression CIRCLOSE
		{ $$=$2;}									  
		;			

postfix_expression
		: primary_expression      				       //New array created 
		{ 
			$$=new Array();
			update_nextinstr();
			$$->Array=$1->loc;	
			update_nextinstr();
			$$->type=$1->loc->type;	
			update_nextinstr();
			$$->loc=$$->Array;
			update_nextinstr();
		}
		| postfix_expression SQROPEN expression SQRCLOSE
		{ 	
			$$=new Array();
			update_nextinstr();
			$$->type=$1->type->arrtype;				// type of element	
			update_nextinstr();			
			$$->Array=$1->Array;						// copy the base
			update_nextinstr();
			$$->loc=gentemp(new symboltype("int"));		// store computed address
			update_nextinstr();
			$$->atype="arr";						
			update_nextinstr();
			if($1->atype=="arr") 
			{											//if an array update size of array 
				sym* t=gentemp(new symboltype("int"));
				update_nextinstr();
				int p=size_calc($$->type);
				update_nextinstr();
				string str=convInt2String(p);
				update_nextinstr();
				emit("*",t->name,$3->loc->name,str);
				update_nextinstr();	
				emit("+",$$->loc->name,$1->loc->name,t->name);
				update_nextinstr();
			}
			else 
			{                        
				int p=size_calc($$->type);		//initiating size of 1D array
				update_nextinstr();
				string str=convInt2String(p);
				update_nextinstr();
				emit("*",$$->loc->name,$3->loc->name,str);
				update_nextinstr();
				
			}
		}
		| postfix_expression CIROPEN argument_expression_list_opt CIRCLOSE      
		//call the function
		{
			
			$$=new Array();	
			update_nextinstr();
			$$->Array=gentemp($1->type);
			update_nextinstr();
			string str=convInt2String($3);
			update_nextinstr();
			emit("call",$$->Array->name,$1->Array->name,str);
			update_nextinstr();
			
		}
		| postfix_expression DOT IDENTIFIER {  }
		| postfix_expression ARW IDENTIFIER  {  }
		| postfix_expression INCR               //Increment Assignment
		{ 
			
			$$=new Array();
			update_nextinstr();
			$$->Array=gentemp($1->Array->type);
			update_nextinstr();	
			emit("=",$$->Array->name,$1->Array->name);
			update_nextinstr();
			
			emit("+",$1->Array->name,$1->Array->name,"1");
			update_nextinstr();
			
		}
		| postfix_expression DECR                //Decrement Assignment
		{
			
			$$=new Array();	
			update_nextinstr();
			$$->Array=gentemp($1->Array->type);
			update_nextinstr();
			emit("=",$$->Array->name,$1->Array->name);
			update_nextinstr();
			
			emit("-",$1->Array->name,$1->Array->name,"1");
			update_nextinstr();
			
		}
		| CIROPEN type_name CIRCLOSE CUROPEN initializer_list CURCLOSE {  }
		| CIROPEN type_name CIRCLOSE CUROPEN initializer_list COMMA CURCLOSE {  }
		;

argument_expression_list_opt
	: argument_expression_list    { $$=$1; }   
	| %empty { $$=0; }            
	;

argument_expression_list
	: assignment_expression    
	{
		
		$$=1;                                      //if having only one argument
		update_nextinstr();
		emit("param",$1->loc->name);	
		update_nextinstr();
		
	}
	| argument_expression_list COMMA assignment_expression     
	{
		
		$$=$1+1;                                  //if more than one argument	
		update_nextinstr();	 
		emit("param",$3->loc->name);
		update_nextinstr();
		
	}
	;

unary_expression
	: postfix_expression   { $$=$1; } 					  //Increment Assignment
	| INCR unary_expression                           
	{  	
		
		emit("+",$2->Array->name,$2->Array->name,"1");
		update_nextinstr();
		
		$$=$2;
		update_nextinstr();
	}
	| DECR unary_expression                           //Decrement Assignment
	{
		
		emit("-",$2->Array->name,$2->Array->name,"1");
		update_nextinstr();
		
		$$=$2;
		update_nextinstr();
	}
	| unary_operator cast_expression                       //Unary Operator
	{			
				  	
		$$=new Array();
		update_nextinstr();
		switch($1)
		{	  
			case '&':                                       //Generate a temporary then emit quad
				
				$$->Array=gentemp((new symboltype("ptr")));
				update_nextinstr();
				$$->Array->type->arrtype=$2->Array->type; 
				update_nextinstr();
				emit("=&",$$->Array->name,$2->Array->name);
				update_nextinstr();
				
				break;
			case '*':                          				//Generate a temporary then emit the quad	
				$$->atype="ptr";
				update_nextinstr();
				$$->loc=gentemp($2->Array->type->arrtype);
				update_nextinstr();
				$$->Array=$2->Array;
				update_nextinstr();
				emit("=*",$$->loc->name,$2->Array->name);
				update_nextinstr();
				
				break;
			case '+':  										//Redundant
				$$=$2;
				
				break;                    
			case '-':				   //Generate temporary and make it negative then emit quad
				$$->Array=gentemp(new symboltype($2->Array->type->type));
				update_nextinstr();
				emit("uminus",$$->Array->name,$2->Array->name);
				update_nextinstr();
				
				break;
			case '~':                   //Generate temporary then invert it then emit quad
				$$->Array=gentemp(new symboltype($2->Array->type->type));
				update_nextinstr();
				emit("~",$$->Array->name,$2->Array->name);
				update_nextinstr();
				
				break;
			case '!':				//Generate temporary then invert it then emit quad
				$$->Array=gentemp(new symboltype($2->Array->type->type));
				update_nextinstr();
				emit("!",$$->Array->name,$2->Array->name);
				update_nextinstr();
				
				break;
		}
	}
	| SIZEOF unary_expression  {  }
	| SIZEOF CIROPEN type_name CIRCLOSE  {  }
	;

unary_operator		//Operators  corresponding to their names
	: BINAND 	
	{ 
		$$='&'; 
		update_nextinstr();
		
	}        
	| MUL  		
	{
		$$='*'; 
		update_nextinstr();
		
	}
	| ADD  		
	{ 
		$$='+'; 
		update_nextinstr();
		
	}
	| SUB  		
	{ 
		$$='-'; 
		update_nextinstr();
		
	}
	| NEG  
	{ 
		$$='~'; 
		update_nextinstr();
		
	} 
	| EXC  
	{
		$$='!'; 
		update_nextinstr();
		
	}
	;

cast_expression
	: unary_expression  { $$=$1; }                      
	| CIROPEN type_name CIRCLOSE cast_expression          //Type Casting
	{ 
		
		$$=new Array();	
		update_nextinstr();
		$$->Array=convType1ToType2($4->Array,curr_var);             //New symbol of the given type
		update_nextinstr();
		
	}
	;

multiplicative_expression
	: cast_expression  
	{
		
		$$ = new Expression();             //generating Expression	
		update_nextinstr();						    
		if($1->atype=="arr") 			   //Type Array
		{
			$$->loc = gentemp($1->loc->type);	
			update_nextinstr();
			emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);     //Emit array attributes
			update_nextinstr();
			
		}
		else if($1->atype=="ptr")         //Type pointer
		{ 
			$$->loc = $1->loc;        //Make same location
			update_nextinstr();
			
		}
		else
		{
			$$->loc = $1->Array;
			update_nextinstr();
			
		}
	}
	| multiplicative_expression MUL cast_expression    //Multiplication      
	{ 
		
		if(!typecheck($1->loc, $3->Array))  //If numbers are not compatibile emit error       
			cout<<"Type Error in Program"<< endl;	
		else 								 		//else generate new quad having product
		{
			$$ = new Expression();	
			update_nextinstr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			update_nextinstr();
			emit("*", $$->loc->name, $1->loc->name, $3->Array->name);
			update_nextinstr();
			
		}
	}
	| multiplicative_expression DIV cast_expression      //Division
	{
		
		if(!typecheck($1->loc, $3->Array))		//If numbers are not compatibile emit error 
			cout << "Type Error in Program"<< endl;
		else    										//else generate new quad having quotient
		{
			$$ = new Expression();
			update_nextinstr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			update_nextinstr();
			emit("/", $$->loc->name, $1->loc->name, $3->Array->name);
			update_nextinstr();	
									
		}
	}
	| multiplicative_expression REM cast_expression    //Modulo
	{
		
		if(!typecheck($1->loc, $3->Array))		//If numbers are not compatibile emit error 
			cout << "Type Error in Program"<< endl;		//else generate new quad having remainder
		else 		 	
		{
			$$ = new Expression();
			update_nextinstr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			update_nextinstr();
			emit("%", $$->loc->name, $1->loc->name, $3->Array->name);	
			update_nextinstr();	
				
		}
	}
	;

additive_expression
	: multiplicative_expression   { $$=$1; }            
	| additive_expression ADD multiplicative_expression      //Addition
	{
		
		if(!typecheck($1->loc, $3->loc))
			cout << "Type Error in Program"<< endl;
		else    	//if types are compatible, generate new temporary and equate to the sum
		{
			$$ = new Expression();	
			update_nextinstr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			update_nextinstr();
			emit("+", $$->loc->name, $1->loc->name, $3->loc->name);
			update_nextinstr();
			
		}
	}
	| additive_expression SUB multiplicative_expression    //if we have subtraction
	{
		
		if(!typecheck($1->loc, $3->loc))		//If numbers are not compatibile emit error 
			cout << "Type Error in Program"<< endl;		
		else        									//else generate new quad having Addition
		{	
			$$ = new Expression();	
			update_nextinstr();
			$$->loc = gentemp(new symboltype($1->loc->type->type));
			update_nextinstr();
			emit("-", $$->loc->name, $1->loc->name, $3->loc->name);
			update_nextinstr();
			
		}
	}
;

shift_expression
	: additive_expression   { $$=$1; }             
	| shift_expression LFTSHF additive_expression   
	{ 
		
		if(!($3->loc->type->type == "int"))				//if additive_expression is not of type int generate error
			cout << "Type Error in Program"<< endl; 		
		else            								//if compatibile generate temporary with left shift Operator
		{		
			$$ = new Expression();	
			update_nextinstr();
			$$->loc = gentemp(new symboltype("int"));
			update_nextinstr();
			emit("<<", $$->loc->name, $1->loc->name, $3->loc->name);
			update_nextinstr();
			
		}
	}
	| shift_expression RGTSHF additive_expression
	{ 	
		if(!($3->loc->type->type == "int"))				//if additive_expression is not of type int generate error
		{
			
			cout << "Type Error in Program"<< endl; 		
		}
		else  											//if compatibile generate temporary with right shift Operator
		{		
			
			$$ = new Expression();	
			update_nextinstr();
			$$->loc = gentemp(new symboltype("int"));
			update_nextinstr();
			emit(">>", $$->loc->name, $1->loc->name, $3->loc->name);
			update_nextinstr();
			
		}
	}
	;

relational_expression
	: shift_expression   { $$=$1; }              
	| relational_expression LST shift_expression
	{
		if(!typecheck($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{     	
										
			$$ = new Expression();
			update_nextinstr();
			$$->type = "bool";                         //Type of generated quad is bool
			update_nextinstr();		
			$$->truelist = makelist(nextinstr());      //Initialize truelist and falselist
			update_nextinstr();
			$$->falselist = makelist(nextinstr()+1);
			update_nextinstr();
			emit("<", "", $1->loc->name, $3->loc->name);     
			update_nextinstr();
			
			emit("goto", "");	
			update_nextinstr();
			
		}
	}
	| relational_expression GRT shift_expression         
	{
		if(!typecheck($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			$$ = new Expression();	
			update_nextinstr();
			$$->type = "bool";
			update_nextinstr();
			$$->truelist = makelist(nextinstr());
			update_nextinstr();
			$$->falselist = makelist(nextinstr()+1);
			update_nextinstr();
			emit(">", "", $1->loc->name, $3->loc->name);
			update_nextinstr();
			
			emit("goto", "");
			update_nextinstr();
			
		}	
	}
	| relational_expression LSTEQL shift_expression			 
	{
		if(!typecheck($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{		
			
			$$ = new Expression();		
			update_nextinstr();
			$$->type = "bool";
			update_nextinstr();
			$$->truelist = makelist(nextinstr());
			update_nextinstr();
			$$->falselist = makelist(nextinstr()+1);
			update_nextinstr();
			emit("<=", "", $1->loc->name, $3->loc->name);
			update_nextinstr();
			
			emit("goto", "");
			update_nextinstr();
			
		}		
	}
	| relational_expression GRTEQL shift_expression 			
	{
		if(!typecheck($1->loc, $3->loc))
		{
			 
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			$$ = new Expression();
			update_nextinstr();
			$$->type = "bool";
			update_nextinstr();
			$$->truelist = makelist(nextinstr());
			update_nextinstr();
			$$->falselist = makelist(nextinstr()+1);
			update_nextinstr();
			emit(">=", "", $1->loc->name, $3->loc->name);
			update_nextinstr();
			
			emit("goto", "");
			update_nextinstr();
			
		}
	}
	;

equality_expression
	: relational_expression  { $$=$1; }						
	| equality_expression ISEQL relational_expression 
	{
		if(!typecheck($1->loc, $3->loc))               
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			convBool2Int($1);                 
			update_nextinstr();	
			convBool2Int($3);
			update_nextinstr();
			$$ = new Expression();
			update_nextinstr();
			$$->type = "bool";
			update_nextinstr();
			$$->truelist = makelist(nextinstr());            //Intializing list
			update_nextinstr();								//Initialize truelist and falselist
			$$->falselist = makelist(nextinstr()+1); 
			update_nextinstr();
			emit("==", "", $1->loc->name, $3->loc->name);     
			update_nextinstr();
			
			emit("goto", "");				
			update_nextinstr();
			
		}
		
	}

	| equality_expression NEQL relational_expression   //Similar to above
	{
		if(!typecheck($1->loc, $3->loc)) 
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{			
			
			convBool2Int($1);	
			update_nextinstr();
			convBool2Int($3);
			update_nextinstr();
			$$ = new Expression();                 //Type of generated quad is bool
			update_nextinstr();						//Initialize truelist and falselist
			$$->type = "bool";
			update_nextinstr();
			$$->truelist = makelist(nextinstr());
			update_nextinstr();
			$$->falselist = makelist(nextinstr()+1);
			update_nextinstr();
			emit("!=", "", $1->loc->name, $3->loc->name);
			update_nextinstr();
			
			emit("goto", "");
			update_nextinstr();
			
		}
	}
	;

AND_expression
	: equality_expression  { $$=$1; }						
	| AND_expression BINAND equality_expression 
	{
		if(!typecheck($1->loc, $3->loc))         //compatibility
		{
					
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			              
			convBool2Int($1);                             //convert bool to int
			update_nextinstr();
			convBool2Int($3);
			update_nextinstr();
			$$ = new Expression();
			update_nextinstr();
			$$->type = "not-boolean";                  
			update_nextinstr();
			$$->loc = gentemp(new symboltype("int"));
			update_nextinstr();
			emit("&", $$->loc->name, $1->loc->name, $3->loc->name);              
			update_nextinstr();
			
		}
	}
	;

exclusive_OR_expression
	: AND_expression  { $$=$1; }				
	| exclusive_OR_expression XOR AND_expression    
	{
		if(!typecheck($1->loc, $3->loc))    //same as above
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			convBool2Int($1);	
			update_nextinstr();
			convBool2Int($3);
			update_nextinstr();
			$$ = new Expression();
			update_nextinstr();
			$$->type = "not-boolean";
			update_nextinstr();
			$$->loc = gentemp(new symboltype("int"));
			update_nextinstr();
			emit("^", $$->loc->name, $1->loc->name, $3->loc->name);
			update_nextinstr();
			
		}
	}
	;

inclusive_OR_expression
	: exclusive_OR_expression { $$=$1; }			
	| inclusive_OR_expression BINOR exclusive_OR_expression          
	{ 
		if(!typecheck($1->loc, $3->loc))   //same as above
		{
			
			cout << "Type Error in Program"<< endl;
		}
		else 
		{
			
			convBool2Int($1);		
			update_nextinstr();
			convBool2Int($3);
			update_nextinstr();
			$$ = new Expression();
			update_nextinstr();
			$$->type = "not-boolean";
			update_nextinstr();
			$$->loc = gentemp(new symboltype("int"));
			update_nextinstr();
			emit("|", $$->loc->name, $1->loc->name, $3->loc->name);
			update_nextinstr();
			
		} 
	}
	;

logical_AND_expression
	: inclusive_OR_expression  { $$=$1; }				
	| logical_AND_expression N AND M inclusive_OR_expression      //Guarding and backpatching
	{ 
		
		convInt2Bool($5);         //convert inclusive_OR_expression int to bool
		update_nextinstr();
		backpatch($2->nextlist, nextinstr());        //$2->nextlist goes to next instruction
		update_nextinstr();
		convInt2Bool($1);                  //convert logical_AND_expression to bool
		update_nextinstr();
		$$ = new Expression();     //make new boolean expression 
		update_nextinstr();
		$$->type = "bool";
		update_nextinstr();
		backpatch($1->truelist, $4);        //if $1 is true, we move to $5
		update_nextinstr();
		$$->truelist = $5->truelist;        //if $5 is also true, we get truelist for $$
		update_nextinstr();
		$$->falselist = merge($1->falselist, $5->falselist);    //merge their falselists
		update_nextinstr();
		
	}
	;

logical_OR_expression
	: logical_AND_expression   { $$=$1; }				//simply equate
	| logical_OR_expression N OR M logical_AND_expression        //backpatching involved here
	{ 
		
		convInt2Bool($5);			 //convert logical_AND_expression int to bool
		update_nextinstr();
		backpatch($2->nextlist, nextinstr());	//$2->nextlist goes to next instruction
		update_nextinstr();
		convInt2Bool($1);			//convert logical_OR_expression to bool
		update_nextinstr();
		$$ = new Expression();			//Type of generated variable is bool
		update_nextinstr();
		$$->type = "bool";
		update_nextinstr();
		backpatch($1->falselist, $4);		//Backpatching
		update_nextinstr();
		$$->truelist = merge($1->truelist, $5->truelist);		
		update_nextinstr();
		$$->falselist = $5->falselist;		 	
		update_nextinstr();
		
	}
	;

conditional_expression 
	: logical_OR_expression {$$=$1;}      
	| logical_OR_expression N QST M expression N COL M conditional_expression 
	{
		
		//normal conversion method to get conditional expressions
		$$->loc = gentemp($5->loc->type);       //generate temporary for expression
		update_nextinstr();
		$$->loc->update($5->loc->type);
		update_nextinstr();
		emit("=", $$->loc->name, $9->loc->name);      //make it equal to sconditional_expression
		update_nextinstr();
		
		list<int> l = makelist(nextinstr());        //makelist next instruction
		emit("goto", "");              //prevent fallthrough
		update_nextinstr();
		
		backpatch($6->nextlist, nextinstr());        //after N, go to next instruction
		update_nextinstr();
		emit("=", $$->loc->name, $5->loc->name);
		update_nextinstr();
		
		list<int> m = makelist(nextinstr());         //makelist next instruction
		update_nextinstr();
		l = merge(l, m);						//merge the two lists
		update_nextinstr();
		emit("goto", "");						//prevent fallthrough
		update_nextinstr();
		
		backpatch($2->nextlist, nextinstr());   //backpatching
		update_nextinstr();
		convInt2Bool($1);                   //convert expression to boolean
		update_nextinstr();
		backpatch($1->truelist, $4);           //$1 true goes to expression
		update_nextinstr();
		backpatch($1->falselist, $8);          //$1 false goes to conditional_expression
		update_nextinstr();
		backpatch(l, nextinstr());
		update_nextinstr();
		
	}
	;

assignment_expression
	: conditional_expression {$$=$1;}         //simply equate
	| unary_expression assignment_operator assignment_expression 
	 {
		if($1->atype=="arr")       //if type is arr, simply check if we need to convert and emit
		{
			
			$3->loc = convType1ToType2($3->loc, $1->type->type);
			update_nextinstr();
			emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);		
			update_nextinstr();
			
		}
		else if($1->atype=="ptr")     //if type is ptr, simply emit
		{
			
			emit("*=", $1->Array->name, $3->loc->name);		
			update_nextinstr();
			
		}
		else                              //otherwise assignment
		{
			
			$3->loc = convType1ToType2($3->loc, $1->Array->type->type);
			emit("=", $1->Array->name, $3->loc->name);
			update_nextinstr();
			
		}
		
		$$ = $3;
		
		
	}
	;


assignment_operator
	: ASG       {  }
	| MULEQL    {  }
	| DIVEQL    {  }
	| REMEQL    {  }
	| ADDEQL    {  }
	| SUBEQL    {  }
	| LFTEQL    {  }
	| RGTEQL    {  }
	| ANDEQL    {  }
	| XOREQL    {  }
	| OREQL     {  }
	;

expression
	: assignment_expression {  $$=$1;  }
	| expression COMMA assignment_expression {   }
	;

constant_expression
	: conditional_expression {   }
	;

declaration
	: declaration_specifiers init_declarator_list SEMICOL {	}
	| declaration_specifiers SEMICOL {  	}
	;


declaration_specifiers
	: storage_class_specifier declaration_specifiers {	}
	| storage_class_specifier {	}
	| type_specifier declaration_specifiers {	}
	| type_specifier {	}
	| type_qualifier declaration_specifiers {	}
	| type_qualifier {	}
	| function_specifier declaration_specifiers {	}
	| function_specifier {	}
	;

init_declarator_list
	: init_declarator {	}
	| init_declarator_list COMMA init_declarator {	}
	;

init_declarator
	: declarator {$$=$1;}
	| declarator ASG initializer 
	{
		
		if($3->val!="") $1->val=$3->val;        //Emit Initial value
		emit("=", $1->name, $3->name);
		update_nextinstr();
		
	}
	;

storage_class_specifier
	: EXTERN  { }
	| STATIC  { }
	;

type_specifier
	: VOID   { curr_var="void"; }           
	| CHAR   { curr_var="char"; }
	| SHORT  { }
	| INT   { curr_var="int"; }
	| LONG   {  }
	| FLOAT   { curr_var="float"; }
	| DOUBLE   { }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list_opt   {  }
	| type_qualifier specifier_qualifier_list_opt  {  }
	;

specifier_qualifier_list_opt
	: %empty {  }
	| specifier_qualifier_list  {  }
	;

type_qualifier
	: CONST   {  }
	| RESTRICT   {  }
	| VOLATILE   {  }
	;

function_specifier
	: INLINE   {  }
	;

declarator
	: pointer direct_declarator 
	{
		
		symboltype *t = $1;
		update_nextinstr();
		while(t->arrtype!=NULL) t = t->arrtype;           //Traverse till get the base type
		update_nextinstr();
		t->arrtype = $2->type;                			 //add the base type 
		update_nextinstr();
		$$ = $2->update($1);                  
		update_nextinstr();
		
	}
	| direct_declarator {   }
	;

direct_declarator
	: IDENTIFIER                
	{
		
		$$ = $1->update(new symboltype(curr_var));
		update_nextinstr();
		curr_sym = $$;
		update_nextinstr();
		
		
	}
	| CIROPEN declarator CIRCLOSE{$$=$2;}       
	| direct_declarator SQROPEN type_qualifier_list assignment_expression SQRCLOSE{	}
	| direct_declarator SQROPEN type_qualifier_list SQRCLOSE{	}
	| direct_declarator SQROPEN assignment_expression SQRCLOSE
	{
		
		symboltype *t = $1 -> type;
		update_nextinstr();
		symboltype *prev = NULL;
		update_nextinstr();
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;      //Traverse till get the base type
			update_nextinstr();
		}
		if(prev==NULL) 
		{
			
			int temp = atoi($3->loc->val.c_str());      //get initial value
			update_nextinstr();
			symboltype* s = new symboltype("arr", $1->type, temp);        //create new symbol with that initial value
			update_nextinstr();
			$$ = $1->update(s);   
			update_nextinstr();
			
		}
		else 
		{
			
			prev->arrtype =  new symboltype("arr", t, atoi($3->loc->val.c_str()));     //similar as above		
			update_nextinstr();
			$$ = $1->update($1->type);
			update_nextinstr();
			
		}
	}
	| direct_declarator SQROPEN SQRCLOSE
	{
		
		symboltype *t = $1 -> type;
		update_nextinstr();
		symboltype *prev = NULL;
		update_nextinstr();
		while(t->type == "arr") 
		{
			prev = t;	
			t = t->arrtype;         //Traverse till get the base type
			update_nextinstr();
		}
		if(prev==NULL) 
		{
			
			symboltype* s = new symboltype("arr", $1->type, 0);    //Initialize with 0 if not already
			update_nextinstr();
			$$ = $1->update(s);
			update_nextinstr();
				
		}
		else 
		{
			
			prev->arrtype =  new symboltype("arr", t, 0);
			update_nextinstr();
			$$ = $1->update($1->type);
			update_nextinstr();
			
		}
	}
	| direct_declarator SQROPEN STATIC type_qualifier_list assignment_expression SQRCLOSE{	}
	| direct_declarator SQROPEN STATIC assignment_expression SQRCLOSE{	}
	| direct_declarator SQROPEN type_qualifier_list MUL SQRCLOSE{	}
	| direct_declarator SQROPEN MUL SQRCLOSE{	}
	| direct_declarator CIROPEN F parameter_type_list CIRCLOSE
	{
		
		ST->name = $1->name;
		update_nextinstr();
		if($1->type->type !="void") 
		{
			sym *s = ST->lookup("return");         //lookup for return value	
			s->update($1->type);
			update_nextinstr();
			
		}
		$1->nested=ST;       
		update_nextinstr();	
		ST->parent = globalST;
		update_nextinstr();
		changeTable(globalST);				// Changing table to globalsymbol table
		update_nextinstr();
		curr_sym = $$;
		update_nextinstr();
		
	}
	| direct_declarator CIROPEN identifier_list CIRCLOSE{	}
	| direct_declarator CIROPEN F CIRCLOSE
	{        
		
		ST->name = $1->name;
		update_nextinstr();
		if($1->type->type !="void") 
		{
			sym *s = ST->lookup("return");
			s->update($1->type);
			update_nextinstr();
						
		}
		$1->nested=ST;
		update_nextinstr();
		ST->parent = globalST;
		update_nextinstr();
		changeTable(globalST);				// Changing table to globalsymbol table
		update_nextinstr();
		curr_sym = $$;
		update_nextinstr();
		
	}
	;

type_qualifier_list_opt
	: %empty   {  }
	| type_qualifier_list      {  }
	;

pointer										//Create New Pointer
	: MUL type_qualifier_list_opt   
	{ 
		$$ = new symboltype("ptr");
		update_nextinstr();
		  
	}          
	| MUL type_qualifier_list_opt pointer 
	{ 
		$$ = new symboltype("ptr",$3);
		update_nextinstr();
		 
	}
	;

type_qualifier_list
	: type_qualifier   {  }
	| type_qualifier_list type_qualifier   {  }
	;

parameter_type_list
	: parameter_list   {  }
	| parameter_list COMMA THRDOT   {  }
	;

parameter_list
	: parameter_declaration   {  }
	| parameter_list COMMA parameter_declaration    {  }
	;

parameter_declaration
	: declaration_specifiers declarator   {  }
	| declaration_specifiers    {  }
	;

identifier_list
	: IDENTIFIER	{  }		  
	| identifier_list COMMA IDENTIFIER   {  }
	;

type_name
	: specifier_qualifier_list   {  }
	;

initializer
	: assignment_expression   { $$=$1->loc; }    
	| CUROPEN initializer_list CURCLOSE  {  }
	| CUROPEN initializer_list COMMA CURCLOSE  {  }
	;

initializer_list
	: designation_opt initializer  {  }
	| initializer_list COMMA designation_opt initializer   {  }
	;

designation_opt
	: %empty   {  }
	| designation   {  }
	;

designation
	: designator_list ASG   {  }
	;

designator_list
	: designator    {  }
	| designator_list designator   {  }
	;

designator
	: SQROPEN constant_expression SQRCLOSE  {  }
	| DOT IDENTIFIER {  }
	;

//Statements

statement
	: labeled_statement   {  }
	| compound_statement   { $$=$1; }
	| expression_statement   
	{ 
		$$=new Statement();              //Make new Statement
		$$->nextlist=$1->nextlist; 
	}
	| selection_statement   { $$=$1; }
	| iteration_statement   { $$=$1; }
	| jump_statement   { $$=$1; }
	;

labeled_statement
	: IDENTIFIER COL statement   {  }
	| CASE constant_expression COL statement   {  }
	| DEFAULT COL statement   {  }
	;

compound_statement
	: CUROPEN block_item_list_opt CURCLOSE   { $$=$2; }  
	;

block_item_list_opt
	: %empty  { $$=new Statement(); }      //Make new statement
	| block_item_list   { $$=$1; }        
	;

block_item_list
	: block_item   { $$=$1; }			
	| block_item_list M block_item    
	{ 
		$$=$3;
		backpatch($1->nextlist,$2);     //backpatching
	}
	;

block_item
	: declaration   { $$=new Statement(); }          //Make new statement
	| statement   { $$=$1; }				
	;

expression_statement
	: expression SEMICOL {$$=$1;}			
	| SEMICOL {$$ = new Expression();}      //Make New  expression
	;

selection_statement
	: IF CIROPEN expression N CIRCLOSE M statement N %prec THEN      //if clause with guarding and backpatching
	{
		
		backpatch($4->nextlist, nextinstr());        //nextlist of N goes to nextinstr
		update_nextinstr();
		convInt2Bool($3);         //convert expression to bool
		update_nextinstr();
		$$ = new Statement();        //make new statement
		update_nextinstr();
		backpatch($3->truelist, $6);        //is expression is true, go to M and save label of start of statement
		update_nextinstr();
		list<int> temp = merge($3->falselist, $7->nextlist);   //merge 
		update_nextinstr();
		$$->nextlist = merge($8->nextlist, temp);
		update_nextinstr();
		
	}
	| IF CIROPEN expression N CIRCLOSE M statement N ELSE M statement   //if else clause with guarding and backpatching
	{
		
		backpatch($4->nextlist, nextinstr());		//nextlist of N goes to nextinstr
		update_nextinstr();
		convInt2Bool($3);        //convert expression to bool
		update_nextinstr();
		$$ = new Statement();       //make new statement
		update_nextinstr();
		backpatch($3->truelist, $6);    //if expression is true, go to M1 else go to M2
		update_nextinstr();
		backpatch($3->falselist, $10);	//backpatching
		update_nextinstr();
		list<int> temp = merge($7->nextlist, $8->nextlist);       //merge 
		update_nextinstr();
		$$->nextlist = merge($11->nextlist,temp);	
		update_nextinstr();
			
	}
	| SWITCH CIROPEN expression CIRCLOSE statement {	}      
	;

iteration_statement	
	: WHILE M CIROPEN expression CIRCLOSE M statement      //while statement with guarding and backpatching
	{
		
		$$ = new Statement();    //create statement
		update_nextinstr();
		convInt2Bool($4);     //convert expression to bool
		update_nextinstr();
		backpatch($7->nextlist, $2);	// M1 to go back to expression again
		update_nextinstr();
		backpatch($4->truelist, $6);	// M2 to go to statement if the expression is true
		update_nextinstr();
		$$->nextlist = $4->falselist;   //if expression is flase go to next instruction of statement
		update_nextinstr();
		// Emit to prevent fallthrough
		string str=convInt2String($2);			
		update_nextinstr();
		emit("goto", str);
		update_nextinstr();
		
			
	}
	| DO M statement M WHILE CIROPEN expression CIRCLOSE SEMICOL      //do while statement
	{
		
		$$ = new Statement();     //create statement
		update_nextinstr();
		convInt2Bool($7);      //convert to bool
		update_nextinstr();
		backpatch($7->truelist, $2);						// M1 to go back to statement if expression is true
		update_nextinstr();
		backpatch($3->nextlist, $4);						// M2 to go to check expression if statement is complete
		update_nextinstr();
		$$->nextlist = $7->falselist;                       //move out if statement is false
		update_nextinstr();
				
	}
	| FOR CIROPEN expression_statement M expression_statement CIRCLOSE M statement      //for loop with guarding and backpatching without updation rule
	{
		
		$$ = new Statement();   //create new statement
		update_nextinstr();
		convInt2Bool($5);    //convert check expression to boolean
		update_nextinstr();
		backpatch($5->truelist,$7);        //if expression is true, go to M2
		update_nextinstr();
		backpatch($8->nextlist,$4);        //after statement, go back to M1
		update_nextinstr();
		string str=convInt2String($4);
		update_nextinstr();
		emit("goto", str);                 //prevent fallthrough
		update_nextinstr();
		
		$$->nextlist = $5->falselist;      //move out if statement is false
		update_nextinstr();
		
	}
	| FOR CIROPEN expression_statement M expression_statement M expression N CIRCLOSE M statement  //for loop with guarding and backpatching with updation rule
	{
		
		$$ = new Statement();		 //create new statement
		update_nextinstr();
		convInt2Bool($5);  //convert check expression to boolean
		update_nextinstr();
		backpatch($5->truelist, $10);	//if expression is true, go to M2
		update_nextinstr();
		backpatch($8->nextlist, $4);	//after N, go back to M1
		update_nextinstr();
		backpatch($11->nextlist, $6);	//statement go back to expression
		update_nextinstr();
		string str=convInt2String($6);
		update_nextinstr();
		emit("goto", str);				//prevent fallthrough
		update_nextinstr();
		
		$$->nextlist = $5->falselist;	//move out if statement is false	
		update_nextinstr();
			
	}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOL { $$ = new Statement(); }            
	| CONTINUE SEMICOL { $$ = new Statement(); }			   
	| BREAK SEMICOL { $$ = new Statement(); }				 
	| RETURN expression SEMICOL               
	{
		
		$$ = new Statement();
		update_nextinstr();
		emit("return",$2->loc->name);               //emit return 
		update_nextinstr();
		
		
	}
	| RETURN SEMICOL 
	{
		
		$$ = new Statement();
		update_nextinstr();
		emit("return","");                         //emit return
		update_nextinstr();
		
	}
	;

// External Definitions

translation_unit
	: external_declaration { }
	| translation_unit external_declaration { } 
	;

external_declaration
	: function_definition {  }
	| declaration   {  }
	;

function_definition
	:declaration_specifiers declarator declaration_list_opt F compound_statement  
	{
		
		int next_instr=0;	 
		update_nextinstr();
		ST->parent=globalST;
		update_nextinstr();
		changeTable(globalST);                     //Change table to global Symbol table
		update_nextinstr();
		
	}
	;

declaration_list
	: declaration   {  }
	| declaration_list declaration    {  }
	;				   										  				   

declaration_list_opt
	: %empty {  }
	| declaration_list   {  }
	;

M
	: %empty 
	{
		// Used in various control statements
		$$=nextinstr();
	}   
	;

N
	: %empty
	{
		
		$$ =new Statement();           
		$$->nextlist=makelist(nextinstr());	 //MakeList for next instruction
		emit("goto","");				//goto statement used to guard agaisnt fallthrough
	}
	;

F
	: %empty 
	{ 														
		if(curr_sym->nested==NULL) 
		{
			
			changeTable(new symtable(""));	
			update_nextinstr();
		}
		else 
		{
			
			changeTable(curr_sym ->nested);					
			update_nextinstr();
			emit("label", ST->name);
			update_nextinstr();
			
		}
	}
	;


%%

void yyerror(const char *s) 
{
    printf("Error occured : %s\n",s);
}