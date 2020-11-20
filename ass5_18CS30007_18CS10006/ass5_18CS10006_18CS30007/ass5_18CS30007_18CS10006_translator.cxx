#include<iostream>
#include<string>
#include<sstream>
#include "ass5_18CS30007_18CS10006_translator.h"

using namespace std;

//global variables declared in header file 
//description mentioned in header file
string curr_var;
symtable* globalST;															
symtable* ST;						
sym* curr_sym; 					
normType keytype;
quadArray Qarr;	                       
long long int instr_count;	

sym::sym(string name, string t, symboltype* arrtype, int width) 
{     //Symbol table entry
		
		(*this).name=name;
		type=new symboltype(t,arrtype,width);       //finds type of symbol
		size=size_calc(type);                   	//find the size from the type
		offset=0;                                   //initial offset = 0
		val="-";                                    //initial value taken to be "-"
		nested=NULL;                                //nested table initially NULL
}

sym* sym::update(symboltype* t) 
{
	type=t;										 //Update the new type
	(*this).size=size_calc(t);                   //new size
	return this;                                 //return t
}

symboltype::symboltype(string type,symboltype* arrtype,int width)        //Constructor 
{
	(*this).type=type;
	(*this).width=width;
	(*this).arrtype=arrtype;
}

symtable::symtable(string name)            //constructor for symbol table
{
	(*this).name=name;
	count=0;                              //Set count = 0
}

sym* symtable::lookup(string name)               //function to lookup in symbol table
{
	sym* symbol;
	list<sym>::iterator it;                      //Defined an iterator to type sym
	it=table.begin();
	while(it!=table.end()) 
	{
		if(it->name==name) 
			return &(*it);         				//Returning name of symbol if found
		it++;
	}										    //Symbol is added if not found
	symbol= new sym(name);
	table.push_back(*symbol);           
	return &table.back();               		//return the symbol
}

void symtable::update()                         //Function to update the symbol table 
{
	list<symtable*> tb;                 
	int off;
	list<sym>::iterator it;
	it=table.begin();
	while(it!=table.end()) 
	{
		if(it==table.begin()) 
		{
			it->offset=0;
			off=it->size;
		}
		else 
		{
			it->offset=off;
			off=it->offset+it->size;
		}
		if(it->nested!=NULL) 
			tb.push_back(it->nested);
		it++;
	}
	list<symtable*>::iterator it1;
	it1=tb.begin();
	while(it1 !=tb.end()) 
	{
	  (*it1)->update();
	  it1++;
	}
}

void symtable::print()                            //Function to print the symbol table
{
	int next_instr=0;
	list<symtable*> tb;                       
	cout<<"________________________________________________________________________________________________________________"<<endl;
	cout<<"ST("<<(*this).name<<")";					//Name of table
	output_indent(85-(*this).name.length());
	cout<<"Parent: ";          
	if(((*this).parent==NULL))
		cout<<"NULL"<<endl;
	else
		cout<<(*this).parent->name<<endl; 
	cout<<"________________________________________________________________________________________________________________\n"<<endl;
	cout<<"Name";             
	output_indent(11);
	cout<<"Type";              
	output_indent(16);
	cout<<"Initial Value";     
	output_indent(10);
	cout<<"Size";              
	output_indent(11);
	cout<<"Offset";            
	output_indent(9);
	cout<<"Nested Table"<<endl;         
	output_indent(100);
	cout<<endl;
	ostringstream str1;
	 
	for(list<sym>::iterator it=table.begin(); it!=table.end(); it++) 
	{          //Printing the symbol table

		if(it->name.compare("return")==0)
			continue;

		if(it->nested!=NULL) 
		{                             //print nested column
			
			it->type->type = "func";
				
		}
		
		cout<<it->name;                                    //Print name
		output_indent(15-it->name.length());
		string typeres=printType(it->type);               //Use PrintType to print type
		cout<<typeres;

		output_indent(25-typeres.length()); 
		cout<<it->val;
		
		output_indent(20-it->val.length());
		cout<<it->size;                                   //Print size
		str1<<it->size;
		
		output_indent(15-str1.str().length());
		str1.str("");
		str1.clear();
		
		cout<<it->offset;                                 //print offset
		str1<<it->offset;
		
		output_indent(13-str1.str().length());
		str1.str("");
		str1.clear();
		
		if(it->nested==NULL) 
		{                             //print nested
			output_indent(4);
			cout<<"null"<<endl;
		}
		else 
		{
			cout<<"ptr-to-ST("<<it->nested->name<<")"<<endl;		
			tb.push_back(it->nested);
		}
	}
	
	cout<<"\n****************************************************************************************************************"<<endl;
	cout<<"\n\n";
	for(list<symtable*>::iterator it=tb.begin(); it !=tb.end();++it) 
	{
    	(*it)->print();                               //print symbol table
	}
			
}
quad::quad(string res,string arg1,string op,string arg2)           //Quad Constructor for String
{
	(*this).res=res;	
	(*this).arg1=arg1;
	(*this).op=op;
	(*this).arg2=arg2;
}

quad::quad(string res,int arg1,string op,string arg2)             //Quad Constructor for int
{
	(*this).res=res;	
	(*this).arg2=arg2;
	(*this).op=op;
	(*this).arg1=convInt2String(arg1);
}

quad::quad(string res,float arg1,string op,string arg2)           //quad Constructor for float
{	
	(*this).res=res;	
	(*this).arg2=arg2;
	(*this).op=op;
	(*this).arg1=convFloat2String(arg1);
}

void quad::print() 
{                                    //Function to Print a quad
	// Binary Operations
	int next_instr=0;	
	if(op=="+")
	{			
		(*this).type1();
	}
	else if(op=="-")
	{				
		(*this).type1();
	}
	else if(op=="*")
	{
		(*this).type1();
	}
	else if(op=="/")
	{			
		(*this).type1();
	}
	else if(op=="%")
	{
		(*this).type1();
	}
	else if(op=="|")
	{
		(*this).type1();
	}
	else if(op=="^")
	{		
		(*this).type1();
	}
	else if(op=="&")
	{					
		(*this).type1();
	}
	// Relational Operations
	else if(op=="==")
	{	
		(*this).type2();
	}
	else if(op=="!=")
	{	
		(*this).type2();
	}
	else if(op=="<=")
	{	
		(*this).type2();
	}
	else if(op=="<")
	{					
		(*this).type2();
	}
	else if(op==">")
	{
		(*this).type2();
	}
	else if(op==">=")
	{					
		(*this).type2();
	}
	else if(op=="goto")
	{					
		cout<<"goto "<<res;
	}	
	// Shift Operations
	else if(op==">>")
	{	
		(*this).type1();
	}
	else if(op=="<<")
	{					
		(*this).type1();
	}
	else if(op=="=")
	{					
		cout<<res<<" = "<<arg1 ;
	}					
	//Unary Operators..
	else if(op=="=&")
	{					
		cout<<res<<" = &"<<arg1;
	}
	else if(op=="=*")
	{	
		cout<<res	<<" = *"<<arg1 ;
	}
	else if(op=="*=")
	{					
		cout<<"*"<<res	<<" = "<<arg1 ;
	}
	else if(op=="uminus")
	{
		cout<<res<<" = -"<<arg1;
	}
	else if(op=="~")
	{					
		cout<<res<<" = ~"<<arg1;
	}
	else if(op=="!")
	{	
		cout<<res<<" = !"<<arg1;
	}
	//Punctuatros
	else if(op=="=[]")
	{
		 cout<<res<<" = "<<arg1<<"["<<arg2<<"]";
	}
	else if(op=="[]=")
	{		 
		cout<<res<<"["<<arg1<<"]"<<" = "<< arg2;
	}
	else if(op=="return")
	{	 			
		cout<<"return "<<res;
	}
	else if(op=="param")
	{ 			
		cout<<"param "<<res;
	}
	else if(op=="call")
	{ 			
		cout<<res<<" = "<<"call "<<arg1<<", "<<arg2;
	}
	else if(op=="label")
	{
		cout<<res<<": ";
	}	
	else
	{	
		cout<<"Can't find "<<op;
	}			
	cout<<endl;
	
}

void quad::type1()
{
	cout<<res<<" = "<<arg1<<" "<<op<<" "<<arg2;	
}

void quad::type2()
{
	cout<<"if "<<arg1<< " "<<op<<" "<<arg2<<" goto "<<res;	
}

void normType::pushType(string t, int s)         
{
	type.push_back(t);	
	size.push_back(s);
}

void quadArray::print()                                   //Printing Three Adress Code
{
	cout<<"___________________________________________________________________________________________"<<endl;
	cout<<endl;
	cout<<"                                 Three Address Codes"<<endl;          
	cout<<"___________________________________________________________________________________________";
	cout<<endl;
	int j=0;
	vector<quad>::iterator it;
	it=Array.begin();
	while(it!=Array.end()) 
	{
		if(it->op=="label") 
		{          							 
			cout<<endl<<"L"<<j<<": ";
			it->print();
		}
		else 
		{                         
			cout<<"L"<<j<<": ";
			output_indent(4);
			it->print();
		}
		it++;j++;
	}
	cout<<"___________________________________________________________________________________________";    
	cout<<endl;
}

void output_indent(int n)
{
	for(int i=0;i<n;i++) 
		cout<<" ";	
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

//Emit quads
void emit(string op, string res, string arg1, string arg2) 
{            
	quad *q1= new quad(res,arg1,op,arg2);
	Qarr.Array.push_back(*q1);
}

void emit(string op, string res, int arg1, string arg2) 
{               
	quad *q2= new quad(res,arg1,op,arg2);
	Qarr.Array.push_back(*q2);
}

void emit(string op, string res, float arg1, string arg2) 
{                 
	quad *q3= new quad(res,arg1,op,arg2);
	Qarr.Array.push_back(*q3);
}

sym* convType1ToType2(sym* s, string rettype)		//Function to convert s into required type 
{                             
	sym* temp=gentemp(new symboltype(rettype));	
	if((*s).type->type=="float")                                      //Float
	{
		if(rettype=="int")                                      //Convert into INT
		{
			emit("=",temp->name,"float2int("+(*s).name+")");
			return temp;
		}
		else if(rettype=="char")                               //Convert into CHar
		{
			emit("=",temp->name,"float2char("+(*s).name+")");
			return temp;
		}
		return s;
	}
	else if((*s).type->type=="int")                                  //int
	{
		if(rettype=="float") 									//Convert into float
		{
			emit("=",temp->name,"int2float("+(*s).name+")");
			return temp;
		}
		else if(rettype=="char") 								//convert into char
		{
			emit("=",temp->name,"int2char("+(*s).name+")");
			return temp;
		}
		return s;
	}
	else if((*s).type->type=="char") 								  //char
	{
		if(rettype=="int") 									//convert into int
		{
			emit("=",temp->name,"char2int("+(*s).name+")");
			return temp;
		}
		if(rettype=="float") 								//converting into float
		{
			emit("=",temp->name,"char2float("+(*s).name+")");
			return temp;
		}
		return s;
	}
	return s;
}

void changeTable(symtable* newtable)			//Funciton to make new symbol table 
{	       
	ST = newtable;
} 

bool typecheck(sym*& s1,sym*& s2)
{ 	// Check compatibility of symbols
	symboltype* type1=s1->type;                        
	symboltype* type2=s2->type;
	int flag=0;
	if(typecheck(type1,type2)) 
		flag=1;       
	else if(s1=convType1ToType2(s1,type2->type)) 
		flag=1;	//Converting one symbol into another
	else if(s2=convType1ToType2(s2,type1->type)) 
		flag=1;
	if(flag)
		return true;
	else 
		return false;
}

bool typecheck(symboltype* t1,symboltype* t2)
{ 	// Check compatibility of symbols
	int flag=0;
	if(t1==NULL && t2==NULL) 
		flag=1;               
	else if(t1==NULL || t2==NULL || t1->type!=t2->type) 
		flag=2;                     
	
	if(flag==1)
		return true;
	else if(flag==2)
		return false;
	else 
		return typecheck(t1->arrtype,t2->arrtype);       
}

void backpatch(list<int> list1,int addr)                 //backpatching
{
	string str=convInt2String(addr);              //get string form of the address
	list<int>::iterator it;
	it=list1.begin();
	while( it!=list1.end()) 
	{
		Qarr.Array[*it].res=str;                     //Backpatching is done here
		it++;
	}
}

list<int> makelist(int init) 
{
	list<int> newlist(1,init);                      //Function to make new list
	return newlist;
}

list<int> merge(list<int> &a,list<int> &b)
{
	a.merge(b);                                //Function to merge two lists
	return a;
}

Expression* convInt2Bool(Expression* e)        
{	// Converting expression "e" to Bool type 
	if(e->type!="bool")                
	{
		e->falselist=makelist(nextinstr());    //Update false list
		emit("==","",e->loc->name,"0");			//emit expression
		e->truelist=makelist(nextinstr());		//Update true list
		emit("goto","");						//emit goto statement
	}
	return e;
}

void update_nextinstr()
{
	instr_count++;
}

Expression* convBool2Int(Expression* e) 
{	// Converting expression "e" to Int type
	if(e->type=="bool") 
	{
		e->loc=gentemp(new symboltype("int"));         //generate temporary and saving it into symbol
		backpatch(e->truelist,nextinstr());				//Backpatching truelists
		emit("=",e->loc->name,"true");					//emitting expressions
		int p=nextinstr()+1;
		string str=convInt2String(p);				//Converting int to strings
		emit("goto",str);								//emitting goto statements
		backpatch(e->falselist,nextinstr());			//backpatching false lists
		emit("=",e->loc->name,"false");					//emitting expressions
	}
	return e;
}

int nextinstr() 
{
	return Qarr.Array.size();                //Next will exceed previous instruction by quad array size
}

sym* gentemp(symboltype* t, string str_new) 
{           
	string tmp_name = "t"+convInt2String(ST->count++);             //generate name of temporary
	sym* s = new sym(tmp_name);
	(*s).type = t;
	(*s).size=size_calc(t);                        //calculate its size
	(*s).val = str_new;
	ST->table.push_back(*s);                        //push it in ST
	return &ST->table.back();
}

int size_calc(symboltype* t)                   //calculate size function
{
	if(t->type.compare("void")==0)	
		return keytype.size[1];
	else if(t->type.compare("char")==0) 
		return keytype.size[2];
	else if(t->type.compare("int")==0) 
		return keytype.size[3];
	else if(t->type.compare("float")==0) 
		return  keytype.size[4];
	else if(t->type.compare("arr")==0) 
		return t->width*size_calc(t->arrtype);     //Finding size of multidimensional arrays
	else if(t->type.compare("ptr")==0) 
		return keytype.size[5];
	else if(t->type.compare("func")==0) 
		return keytype.size[6];
	else 
		return -1;
}

string printType(symboltype* t)                    //Function to print the types of varibles
{
	if(t==NULL) return keytype.type[0];
	if(t->type.compare("void")==0)	return keytype.type[1];
	else if(t->type.compare("char")==0) return keytype.type[2];
	else if(t->type.compare("int")==0) return keytype.type[3];
	else if(t->type.compare("float")==0) return keytype.type[4];
	else if(t->type.compare("ptr")==0) return keytype.type[5]+"("+printType(t->arrtype)+")";       
	else if(t->type.compare("arr")==0) 
	{
		string str=convInt2String(t->width);                                
		return keytype.type[6]+"("+str+","+printType(t->arrtype)+")";
	}
	else if(t->type.compare("func")==0) return keytype.type[7];
	else return "NA";
}

int main()
{
	keytype.pushType("null",0);                 
	keytype.pushType("void",0);
	keytype.pushType("char",1);
	keytype.pushType("int",4);
	keytype.pushType("float",8);
	keytype.pushType("ptr",4);
	keytype.pushType("array",0);
	keytype.pushType("function",0);
	instr_count = 0;   										// initial count of instr
	globalST=new symtable("Global");                         //Global Symbol Table
	ST=globalST;
	yyparse();												 
	globalST->update();										 //update global Symbol table
	cout<<"\n";	
	cout<<"                                                 Symbol Tables\n";
	globalST->print();										//Print all Symbol Tables
	Qarr.print();											//Print Three Adress codes
};