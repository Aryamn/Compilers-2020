#ifndef _ASS5_18CS30007_18CS10006_TRANSLATE_H
#define _ASS5_18CS30007_18CS10006_TRANSLATE_H

#include <bits/stdc++.h>

extern  char* yytext;
extern  int yyparse();

using namespace std;

class sym;						//entry in ST
class symboltype;				//the type of a symbol in ST
class symtable;					//Symbol Table
class quad;						//single entry in the quad Array
class quadArray;				//the Array of quads

class sym 
{                      //the fields of ST are defined here
	public:
		string name;				//the name of the symbol
		symboltype *type;			//the type of the symbol
		int size;					//the size of the symbol
		int offset;					//the offset of symbol in ST
		symtable* nested;			//points to the nested symbol table
		string val;				    //initial value of the symbol 

		sym (string , string t="int", symboltype* ptr = NULL, int width = 0);
		sym* update(symboltype*); 	// used to update different fields of existing symbol
};

class symboltype 
{                      //the type of symbol is processed using this class
	public:
		string type;					//the type of symbol. 
		int width;					    //the size of Array(default size = 1)
		symboltype* arrtype;			//for matrix we have made a pointer of arrays

		symboltype(string , symboltype* ptr = NULL, int width = 1);
};

class symtable 
{ 				
	public:
		string name;				//Table Name
		int count;					//Count of the temporary variables
		list<sym> table; 			//The table of symbols which is essentially a list of sym
		symtable* parent;			//Current ST's Parent ST 
		//Constructor
		symtable (string name="NULL");
		//Lookup for a symbol in ST
		sym* lookup (string);		
		//Print the ST						
		void print();	
		//Update the ST				            			
		void update();						        			
};

class quad 
{ 		
	public:
		string res;					// Result
		string op;					// Operator
		string arg1;				// Argument 1
		string arg2;				// Argument 2

		void print();	
		void type1();      //printing quads(Three Address Codes)
		void type2();
				
		quad (string , string , string op = "=", string arg2 = "");			
		quad (string , int , string op = "=", string arg2 = "");				
		quad (string , float , string op = "=", string arg2 = "");			
};

class quadArray 
{ 	
	public:
		vector<quad> Array;		                    
		void print();								
};

class normType 
{                        //basic type
	public:
		vector<string> type;                    //type name
		vector<int> size;                       //size
		void pushType(string ,int );
};

extern symtable* ST;						//the current Symbol Table
extern symtable* globalST;				    //the Global Symbol Table
extern sym* curr_sym;					    //the latest encountered symbol
extern quadArray Qarr;						//the quad Array
extern normType keytype;                    //the Type ST
extern long long int instr_count;			//count of instructions

//Other structures
struct Statement {
	list<int> nextlist;			//nextlist for Statement
};

struct Array {
	string atype;				//Used for type of Array: may be ptr or arr
	sym* loc;					//Location used to compute address of Array
	sym* Array;					//pointer to the symbol table entry
	symboltype* type;			//type of the subarr1 generated (important for multidimensional arr1s)
};

struct Expression {
	sym* loc;								//pointer to the symbol table entry
	string type; 							//to store whether the expression is of type int or bool or float or char
	list<int> truelist;						//fruelist for boolean expressions
	list<int> falselist;					//falselist for boolean expressions
	list<int> nextlist;						//for statement expressions
};

//Extra Functions
string convInt2String(int );               //to convert int value to string
string convFloat2String(float );           //to convert float value to string
void output_indent(int );                  //to indent ouput for better look

/* --------------------------------------Functions mentioned in the assignment-------------------------------------------*/

sym* gentemp (symboltype* , string init = "");	  //used to generate a temporary variable and insert it in the current ST

//Emit Functions
void emit(string , string , string arg1="", string arg2 = "");  
void emit(string , string , int, string arg2 = "");		  
void emit(string , string , float , string arg2 = "");   

//Backpatching and its processing functions
void backpatch (list <int> , int );
list<int> makelist (int );							    //used to make a new list contaninig an integer
list<int> merge (list<int> &l1, list <int> &l2);		//used to merge two lists into a single list

bool typecheck(sym* &s1, sym* &s2);						//used to check for same type of two symbol table entries
bool typecheck(symboltype*, symboltype*);				//used to check for same type of two symboltype objects

Expression* convInt2Bool(Expression*);				//used convert int expression to boolean
Expression* convBool2Int(Expression*);				//used convert boolean expression to int

/* --------------------------------------------------------------------------------------------------------------------- */

//other useful functions
int nextinstr();										//gives the number of the next instruction
void update_nextinstr();								//updates the number of the next instruction

sym* convType1ToType2(sym*, string);							//for type conversion
int size_calc (symboltype *);							//used to calculate size of symbol type
string printType(symboltype *);							//to print type of symbol
void changeTable (symtable* );							//used to change current table

#endif