#ifndef TRANSLATE
#define TRANSLATE
#include <bits/stdc++.h>

#define CHAR_SIZE 		    1
#define INT_SIZE  		    4
#define DOUBLE_SIZE		    8
#define POINTER_SIZE		4

extern  char* yytext;
extern  int yyparse();

using namespace std;


////////////////////////////////////Forward class declarations to avoid conflicts
class sym;						// Entry in a symbol ST
class symboltype;					// curr_var of a symbol in symbol ST
class symtable;					// Symbol Table
class quad;						// Entry in quad Array
class quadArray;				// QuadArray

extern symtable* ST;						// Current Symbol Table
extern symtable* globalST;				// Global Symbol Table
extern quadArray q;							// Array of Quads
extern sym* curr_sym;					// Pointer to just encountered symbol

class symboltype { // curr_var of symbols in symbol ST
public:
	symboltype(string type, symboltype* ptr = NULL, int width = 1);
	string type;
	int width;					// Size of Array (in case of arrays)
	symboltype* ptr;				// for 2d arrays and pointers
};

class sym { // Symbols class
public:
	string name;				// Name of the symbol
	symboltype *type;				// curr_var of the Symbol
	string initial_value;		// Symbol initial valus (if any)
	string category;			// global, local, param
	int size;					// Size of the symbol
	int offset;					// Offset of symbol
	symtable* nested;				// Pointer to nested symbol ST

	sym (string name, string t="INTEGER", symboltype* ptr = NULL, int width = 0); //constructor declaration
	sym* update(symboltype * t); 	// A method to update different fields of an existing entry.
};

class symtable { // Symbol Table class
public:
	string name;				// Name of Table
	int count;					// Count of temporary variables
	list<sym> ST; 			// The ST of symbols
	symtable* parent;				// Immediate parent of the symbol ST
	map<string, int> ar;		// activation record
	symtable (string name="NULL");
	sym* lookup (string name);								// Lookup for a symbol in symbol ST
	void print();					            			// Print the symbol ST
	void update();						        			// Update offset of the complete symbol ST
};

class quad { // Quad Class
public:
	string op;					// Operator
	string result;				// Result
	string arg1;				// Argument 1
	string arg2;				// Argument 2

	void print ();								// Print Quad
	quad (string result, string arg1, string op = "=", string arg2 = "");			//constructors
	quad (string result, int arg1, string op = "=", string arg2 = "");				//constructors
	quad (string result, float arg1, string op = "=", string arg2 = "");			//constructors
};

class quadArray { // Array of quads
public:
	vector <quad> Array;;		                // Vector of quads
	void print ();								// Print the quadArray
};

//Attributes for expressions
struct expr {
	string type; 							//to store whether the expression is of type int or bool

	// Valid for non-bool type
	sym* loc;								// Pointer to the symbol ST entry

	// Valid for bool type
	list<int> truelist;						// Truelist valid for boolean
	list<int> falselist;					// Falselist valid for boolean expressions

	// Valid for statement expression
	list<int> nextlist;
};

struct statement {
	list<int> nextlist;				// Nextlist for statement
};

//Attributes for Array
struct Array {
	string cat;
	sym* loc;					// Temporary used for computing Array address
	sym* Array;					// Pointer to symbol ST
	symboltype* type;				// type of the subarray generated
};


sym* gentemp (symboltype* t, string init = "");		// Generate a temporary variable and insert it in current symbol ST

void emit(string op, string result, int arg1, string arg2 = "");		  //emits for adding quads to quadArray (arg1 is int)
void emit(string op, string result, float arg1, string arg2 = "");        //emits for adding quads to quadArray (arg1 is float)
void emit(string op, string result, string arg1="", string arg2 = "");    //emits for adding quads to quadArray

void backpatch (list <int> lst, int i);
list<int> makelist (int i);							        // Make a new list contaninig an integer
list<int> merge (list<int> &lst1, list <int> &lst2);		// Merge two lists into a single list

bool typecheck(sym* &s1, sym* &s2);					// Checks if two symbols have same type
bool typecheck(symboltype* t1, symboltype* t2);			//checks if two symboltype objects have same type

expr* convertInt2Bool (expr*);				// convert any expression (int) to bool
expr* convertBool2Int (expr*);				// convert bool to expression (int)

int nextinstr();									// Returns the next instruction number

sym* conv (sym*, string);							// TAC for curr_var conversion in program

int size_type (symboltype*);							// Calculate size of any symbol type
string print_type(symboltype*);						// For printing type of symbol recursive printing of type

void changeTable (symtable* newtable);               //for changing the current sybol ST

#endif