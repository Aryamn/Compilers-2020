#include "asgn6_18CS30007_translator.h"
#include <sstream>

using namespace std;

//reference to global variables declared in header file 
symtable* globalST;					// Global Symbbol Table
quadArray q;							// Quad Array
string curr_var;							// Stores latest type
symtable* ST;						// Points to current symbol ST
sym* curr_sym; 					// points to current symbol

symboltype::symboltype(string type, symboltype* ptr, int width): 
	type (type), 
	ptr (ptr), 
	width (width) {};

quad::quad (string result, string arg1, string op, string arg2):
	result (result), arg1(arg1), arg2(arg2), op (op){};

quad::quad (string result, int arg1, string op, string arg2):
	result (result), arg2(arg2), op (op) {
		stringstream strs;
	    strs << arg1;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		this->arg1 = str;
	}

quad::quad (string result, float arg1, string op, string arg2):
	result (result), arg2(arg2), op (op) 
	{
		std::ostringstream buff;
   		buff<<arg1;
		this->arg1 = buff.str();
	}

void printQuadArray() {
	cout << "==============================" << endl;
	cout << "Quad Translation" << endl;
	cout << "------------------------------" << endl;
	cout << "------------------------------"<< endl;
}

void quad::print () {
	// Binary Operations
	if (op=="+")					cout << result << " = " << arg1 << " + " << arg2;
	else if (op=="-")				cout << result << " = " << arg1 << " - " << arg2;
	else if (op=="*")			cout << result << " = " << arg1 << " * " << arg2;
	else if (op=="/")			cout << result << " = " << arg1 << " / " << arg2;
	else if (op=="%")			cout << result << " = " << arg1 << " % " << arg2;
	else if (op=="^")				cout << result << " = " << arg1 << " ^ " << arg2;
	else if (op=="|")			cout << result << " = " << arg1 << " | " << arg2;
	else if (op=="&")			cout << result << " = " << arg1 << " & " << arg2;
	// Shift Operations
	else if (op=="<<")			cout << result << " = " << arg1 << " << " << arg2;
	else if (op==">>")			cout << result << " = " << arg1 << " >> " << arg2;
	else if (op=="=")			cout << result << " = " << arg1 ;				
	// Relational Operations
	else if (op=="==")			cout << "if " << arg1 <<  " == " << arg2 << " goto " << result;
	else if (op=="!=")			cout << "if " << arg1 <<  " != " << arg2 << " goto " << result;
	else if (op=="<")				cout << "if " << arg1 <<  " < "  << arg2 << " goto " << result;
	else if (op==">")				cout << "if " << arg1 <<  " > "  << arg2 << " goto " << result;
	else if (op==">=")				cout << "if " << arg1 <<  " >= " << arg2 << " goto " << result;
	else if (op=="<=")				cout << "if " << arg1 <<  " <= " << arg2 << " goto " << result;
	else if (op=="GOTO")			cout << "goto " << result;		
	//Unary Operators
	else if (op=="=&")			cout << result << " = &" << arg1;
	else if (op=="=*")			cout << result	<< " = *" << arg1 ;
	else if (op=="*=")			cout << "*" << result	<< " = " << arg1 ;
	else if (op=="-")			cout << result 	<< " = -" << arg1;
	else if (op=="~")			cout << result 	<< " = ~" << arg1;
	else if (op=="!")			cout << result 	<< " = !" << arg1;

	else if (op=="=[]")	 		cout << result << " = " << arg1 << "[" << arg2 << "]";
	else if (op=="[]=")	 		cout << result << "[" << arg1 << "]" <<" = " <<  arg2;
	else if (op=="RETURN") 			cout << "ret " << result;
	else if (op=="PARAM") 			cout << "param " << result;
	else if (op=="CALL") 			cout << result << " = " << "call " << arg1<< ", " << arg2;
	else if (op=="FUNC") 			cout << result << ": ";
	else if (op=="FUNCEND") 		cout << "";
	else							cout << op;			
	cout << endl;
}

void quadArray::print() {
	cout << "=============================="<< endl;
	cout << "Quad Translation" << endl;
	cout << "------------------------------" << endl;
	
	for(int i=0;i<Array.size();++i)
	{
		if (Array[i].op == "FUNC") 
		{
			cout << "\n";
			Array[i].print();
			// cout << '\n';
		}
		else if (Array[i].op == "FUNCEND") {}
		else 
		{
			cout << "\t" << i << ":\t";
			Array[i].print();
			// cout << "\n";
		}
	}


	cout << "------------------------------" << endl;
}


sym::sym (string name, string t, symboltype* ptr, int width): name(name)  {
	type = new symboltype (t, ptr, width);
	nested = NULL;
	initial_value = "";
	category = "";
	offset = 0;
	size = size_type(type);
}

sym* sym::update(symboltype* t) {
	type = t;
	this -> size = size_type(t);
	return this;
}

symtable::symtable (string name): name (name), count(0) {}

void symtable::print() {
	list<symtable*> tablelist;
	cout << "==================================================================================================================="<< endl;
	cout << "Symbol Table: " << "                                  "  << this -> name ;
	cout << right << setw(25) << "Parent: ";
	if (this->parent!=NULL)
		cout << this -> parent->name;
	else cout << "null" ;
	cout << endl;
	cout << "-------------------------------------------------------------------------------------------------------------------" << endl;
	cout << "Name";
	cout << "               curr_var";
	cout << "               Category";
	cout << "               Initial Value";
	cout << "        Size";
	cout << "        Offset";
	cout << "        Nested" << endl;
	cout << "-------------------------------------------------------------------------------------------------------------------" << endl;
	
	
	for (list <sym>::iterator it = ST.begin(); it!=ST.end(); it++) {
		cout << left << setw(20) << it->name;
		string stype = print_type(it->type);
		cout << left << setw(25) << stype;
		cout << left << setw(17) << it->category;
		cout << left << setw(17) << it->initial_value;
		cout << left << setw(12) << it->size;
		cout << left << setw(11) << it->offset;
		cout << left;
		if (it->nested == NULL) {
			cout << "null" <<  endl;	
		}
		else {
			cout << it->nested->name <<  endl;
			tablelist.push_back (it->nested);
		}
	}
	
	cout << setw(115) << setfill ('-') << "-"<< setfill (' ') << endl;
	cout << endl;


	for (list<symtable*>::iterator iterator = tablelist.begin();
			iterator != tablelist.end();
			++iterator) 
		{
	    	(*iterator)->print();
		}		

}

void symtable::update() {
	list<symtable*> tablelist;
	int off;
	for (list <sym>::iterator it = ST.begin(); it!=ST.end(); it++) {
		if (it==ST.begin()) {
			it->offset = 0;
			off = it->size;
		}
		else {
			it->offset = off;
			off = it->offset + it->size;
		}
		if (it->nested!=NULL) tablelist.push_back (it->nested);
	}
	for (list<symtable*>::iterator iterator = tablelist.begin(); 
			iterator != tablelist.end(); 
			++iterator) {
	    (*iterator)->update();
	}
}

bool checktype(sym*& s1, sym*& s2){ 	// Check if the symbols have same type or not
	symboltype* type1 = s1->type;
	symboltype* type2 = s2->type;
	if ( typecheck (type1, type2) ) return true;
	else if (s1 = conv (s1, type2->type) ) return true;
	else if (s2 = conv (s2, type1->type) ) return true;
	else return false;
}

string join(string a,string b,string c)
{
	string x;
	x = a+b+c;
	return x;
}

string convInt2String(int a)                    //to convert int to string
{
	stringstream strs;                     
    strs<<a; 
    string temp=strs.str();
    char* integer=(char*) temp.c_str();
	string str=string(integer);
	return str;                              
}

string convFloat2String(float x)                        //Convert Float to String
{
	std::ostringstream buff;
	buff<<x;
	return buff.str();
}


sym* symtable::lookup (string name) {
	sym* s;
	list <sym>::iterator it;
	for (it = ST.begin(); it!=ST.end(); it++) {
		if (it->name == name ) break;
	}
	if (it!=ST.end() ) {
		return &*it;
	}
	else {
		//new symbol to be added to ST
		s =  new sym (name);
		s->category = "local";
		ST.push_back (*s);
		return &ST.back();
		}
}


void emit(string op, string result, string arg1, string arg2) 
{
	q.Array.push_back(*(new quad(result,arg1,op,arg2)));
}
void emit(string op, string result, int arg1, string arg2) {
	q.Array.push_back(*(new quad(result,arg1,op,arg2)));
}
void emit(string op, string result, float arg1, string arg2) {
	q.Array.push_back(*(new quad(result,arg1,op,arg2)));
}


sym* conv (sym* s, string t) {
	sym* temp = gentemp(new symboltype(t));
	if (s->type->type=="INTEGER" ) {
		if (t=="DOUBLE") {
			emit ("=", temp->name, "int2double(" + s->name + ")");
			return temp;
		}
		else if (t=="CHAR") {
			emit ("=", temp->name, "int2char(" + s->name + ")");
			return temp;
		}
		return s;
	}
	else if (s->type->type=="DOUBLE" ) {
		if (t=="INTEGER") {
			emit ("=", temp->name, "double2int(" + s->name + ")");
			return temp;
		}
		else if (t=="CHAR") {
			emit ("=", temp->name, "double2char(" + s->name + ")");
			return temp;
		}
		return s;
	}
	else if (s->type->type=="CHAR") {
		if (t=="INTEGER") {
				emit ("=", temp->name, "char2int(" + s->name + ")");
				return temp;
			}
		if (t=="DOUBLE") {
				emit ("=", temp->name, "char2double(" + s->name + ")");
				return temp;
			}
		return s;
	}
	return s;
}


bool typecheck(sym*& s1, sym*& s2){ 	// Check if the symbols have same type or not
	symboltype* type1 = s1->type;
	symboltype* type2 = s2->type;
	if ( typecheck (type1, type2) ) return true;
	else if (s1 = conv (s1, type2->type) ) return true;
	else if (s2 = conv (s2, type1->type) ) return true;
	else return false;
}

bool typecheck(symboltype* t1, symboltype* t2){ 	// Check if the symbol types are same or not
	if (t1 != NULL || t2 != NULL) {
		if (t1==NULL) return false;
		if (t2==NULL) return false;
		if (t1->type==t2->type) return typecheck(t1->ptr, t2->ptr);
		else return false;
	}
	return true;
}

void backpatch (list <int> l, int addr) 
{
	stringstream strs;
    strs << addr;
    string temp_str = strs.str();
    char* intStr = (char*) temp_str.c_str();
	string str = string(intStr);
	for (list<int>::iterator it= l.begin(); it!=l.end(); it++) {
		q.Array[*it].result = str;
	}
}


list<int> makelist (int i) 
{
	list<int> l(1,i);
	return l;
}

list<int> maketruelist (list<int> &a, list <int> &b) 
{
	list<int> l(1,4);
	a.merge(b);
	return a;
}

list<int> makefalselist (list<int> &a, list <int> &b) 
{
	list<int> l(1,3);
	b.merge(a);
	return b;
}

list<int> merge (list<int> &a, list <int> &b)
{
	a.merge(b);
	return a;
}

expr* convertInt2Bool (expr* e) 
{	// Convert any expression to bool
	if (e->type!="bool") {
		e->falselist = makelist (nextinstr());
		emit ("==", "", e->loc->name, "0");
		e->truelist = makelist (nextinstr());
		emit ("GOTO", "");
	}
}
expr* convertBool2Int (expr* e) 
{	// Convert any expression to bool
	if (e->type=="bool") {
		e->loc = gentemp(new symboltype("INTEGER"));
		backpatch (e->truelist, nextinstr());
		emit ("=", e->loc->name, "true");
		stringstream strs;
	    strs << nextinstr()+1;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		emit ("GOTO", str);
		backpatch (e->falselist, nextinstr());
		emit ("=", e->loc->name, "false");
	}
}

expr* convertStr2Int (expr* e) 
{	// Convert str expression to int
	if (e->type=="STR") {
		e->loc = gentemp(new symboltype("INTEGER"));
		backpatch (e->truelist, nextinstr());
		emit ("=", e->loc->name, "true");
		stringstream strs;
	    strs << nextinstr()+1;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		emit ("GOTO", str);
		backpatch (e->falselist, nextinstr());
		emit ("=", e->loc->name, "false");
	}
}

expr* convertInt2Strin (expr* e) 
{	
	if (e->type=="STR") {
		e->loc = gentemp(new symboltype("INTEGER"));
		backpatch (e->truelist, nextinstr());
		emit ("=", e->loc->name, "true");
		stringstream strs;
	    strs << nextinstr()+1;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		emit ("GOTO", str);
		backpatch (e->falselist, nextinstr());
		emit ("=", e->loc->name, "false");
	}
}

void changeTable (symtable* newtable) 
{	// Change current symbol ST
	ST = newtable;
} 


int nextinstr() {
	return q.Array.size();
}

int size_var (int argc, char* argv[]){
	globalST = new symtable("Global");
	ST = globalST;
	yyparse();
	globalST->update();
	globalST->print();
	q.print();
};

sym* gentemp (symboltype* t, string init) {
	char n[10];
	sprintf(n, "t%02d", ST->count++);
	sym* s = new sym (n);
	s->type = t;
	s->size=size_type(t);
	s-> initial_value = init;
	s->category = "temp";
	ST->ST.push_back ( *s);
	return &ST->ST.back();
}

int size_type (symboltype* t){
	if(t->type=="VOID")	return 0;
	else if(t->type=="CHAR") return CHAR_SIZE;
	else if(t->type=="INTEGER")return INT_SIZE;
	else if(t->type=="DOUBLE") return  DOUBLE_SIZE;
	else if(t->type=="PTR") return POINTER_SIZE;
	else if(t->type=="ARR") return t->width * size_type (t->ptr);
	else if(t->type=="FUNC") return 0;
}

string print_type (symboltype* t){
	if (t==NULL) return "null";
	if(t->type=="VOID")	return "void";
	else if(t->type=="CHAR") return "char";
	else if(t->type=="INTEGER") return "integer";
	else if(t->type=="DOUBLE") return "double";
	else if(t->type=="PTR") return "ptr("+ print_type(t->ptr)+")";
	else if(t->type=="ARR") {
		stringstream strs;
	    strs << t->width;
	    string temp_str = strs.str();
	    char* intStr = (char*) temp_str.c_str();
		string str = string(intStr);
		return "arr(" + str + ", "+ print_type (t->ptr) + ")";
		}
	else if(t->type=="FUNC") return "function";
	else return "_";
}
