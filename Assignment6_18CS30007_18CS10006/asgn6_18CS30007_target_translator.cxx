#include "asgn6_18CS30007_translator.h"
#include <iostream>
#include <cstring>
#include <string>
extern FILE *yyin;
extern vector<string> defined_strings;
using namespace std;

string outfilename="asgn6_18CS30007_";		// asm file name
string inputfile="asgn6_18CS30007_test";	// input file name

void Activation_Record(symtable* st) 
{
	int param = -16;
	int local = -12;
	for (list <sym>::iterator it = st->ST.begin(); it!=st->ST.end(); it++)
	{
		if (it->category =="param") 
		{
			st->ar [it->name] = param;
			param +=it->size;			
		}
		else if (it->name=="return") continue;
		else 
		{
			st->ar [it->name] = local;
			local -=it->size;
		}
	}
}

void genasm()
{
	int labelCount=0;							// To calulate line number
	std::map<int, int> labelMap;				// To find the line number
	vector <quad> Array;						// quad Array

	Array = q.Array;

	 
	//To update the goto labels
	for (vector<quad>::iterator it = Array.begin(); it!=Array.end(); it++) 
	{
	int i;
	if (it->op=="GOTO" || it->op=="<" || it->op==">" || it->op=="<=" || it->op==">=" || it->op=="==" || it->op=="!=") 
		{
			i = atoi(it->result.c_str());
			labelMap [i] = 1;
		}
	}
	int count = 0;
	for (std::map<int,int>::iterator it=labelMap.begin(); it!=labelMap.end(); ++it)
		it->second = count++;
	list<symtable*> tablelist;
	for (list <sym>::iterator it = globalST->ST.begin(); it!=globalST->ST.end(); it++) 
	{
		if (it->nested!=NULL) tablelist.push_back (it->nested);
	}
	for (list<symtable*>::iterator iterator = tablelist.begin();iterator != tablelist.end(); ++iterator) 
	{
		Activation_Record(*iterator);
	}

	 
	ofstream outfile;
	outfile.open(outfilename.c_str());
	
	outfile << "\t.file	\"output.s\"\n";
	for (list <sym>::iterator it = ST->ST.begin(); it!=ST->ST.end(); it++) 
	{
		if (it->category!="function") 
		{
			if (it->type->type=="CHAR") 
			{ // Global char
				if (it->initial_value!="") 
				{
					outfile << "\t.globl\t" << it->name << "\n";
					outfile << "\t.type\t" << it->name << ", @object\n";
					outfile << "\t.size\t" << it->name << ", 1\n";
					outfile << it->name <<":\n";
					outfile << "\t.byte\t" << atoi( it->initial_value.c_str()) << "\n";
				}
				else 
				{
					outfile << "\t.comm\t" << it->name << ",1,1\n";
				}
			}
			if (it->type->type=="INTEGER") 
			{ // Global int
				if (it->initial_value!="") 
				{
					outfile << "\t.globl\t" << it->name << "\n";
					outfile << "\t.data\n";
					outfile << "\t.align 4\n";
					outfile << "\t.type\t" << it->name << ", @object\n";
					outfile << "\t.size\t" << it->name << ", 4\n";
					outfile << it->name <<":\n";
					outfile << "\t.long\t" << it->initial_value << "\n";

				}
				else 
				{
					outfile << "\t.comm\t" << it->name << ",4,4\n";
				}
			}
		}
	}
	if (defined_strings.size()) 
	{
		outfile << "\t.section\t.rodata\n";
		for (vector<string>::iterator it = defined_strings.begin(); it!=defined_strings.end(); it++) 
		{
			outfile << ".LC" << it - defined_strings.begin() << ":\n";
			outfile << "\t.string\t" << *it << "\n";	
		}	
	}
	outfile << "\t.text	\n";

	vector<string> params;
	std::map<string, int> theMap;
	for (vector<quad>::iterator it = Array.begin(); it!=Array.end(); it++) 
	{
		if (labelMap.count(it - Array.begin())) 
		{
			outfile << ".L" << (2*labelCount+labelMap.at(it - Array.begin()) + 2 )<< ": " << endl;
		}

		string op = it->op;
		string result = it->result;
		string arg1 = it->arg1;
		string arg2 = it->arg2;
		string s=arg2;

		if(op=="PARAM")
		{
			params.push_back(result);
		}
		else 
		{
			outfile << "\t";
			if (op=="+") 
			{
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else
				{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) 
				{
					outfile << "addl \t$" << atoi(arg2.c_str()) << ", " << ST->ar[arg1] << "(%rbp)";
				}
				else 
				{
					outfile << "movl \t" << ST->ar[arg1] << "(%rbp), " << "%eax" << endl;
					outfile << "\tmovl \t" << ST->ar[arg2] << "(%rbp), " << "%edx" << endl;
					outfile << "\taddl \t%edx, %eax\n";
					outfile << "\tmovl \t%eax, " << ST->ar[result] << "(%rbp)";
				}
			}
			else if (op=="-") 
			{
				outfile << "movl \t" << ST->ar[arg1] << "(%rbp), " << "%eax" << endl;
				outfile << "\tmovl \t" << ST->ar[arg2] << "(%rbp), " << "%edx" << endl;
				outfile << "\tsubl \t%edx, %eax\n";
				outfile << "\tmovl \t%eax, " << ST->ar[result] << "(%rbp)";
			}
			else if (op=="*") 
			{
				outfile << "movl \t" << ST->ar[arg1] << "(%rbp), " << "%eax" << endl;
				bool flag=true;
	 
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else
				{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) 
				{
					outfile << "\timull \t$" << atoi(arg2.c_str()) << ", " << "%eax" << endl;
					symtable* t = ST;
					string val;
					for (list <sym>::iterator it = t->ST.begin(); it!=t->ST.end(); it++) {
						if(it->name==arg1) val=it->initial_value; 
					}

	 
					theMap[result]=atoi(arg2.c_str())*atoi(val.c_str());
				}
				else outfile << "\timull \t" << ST->ar[arg2] << "(%rbp), " << "%eax" << endl;
				outfile << "\tmovl \t%eax, " << ST->ar[result] << "(%rbp)";			
			}
			else if(op=="/") 
			{
				outfile << "movl \t" << ST->ar[arg1] << "(%rbp), " << "%eax" << endl;
				outfile << "\tcltd" << endl;
				outfile << "\tidivl \t" << ST->ar[arg2] << "(%rbp)" << endl;
				outfile << "\tmovl \t%eax, " << ST->ar[result] << "(%rbp)";		
			}

			else if (op=="%")		outfile << result << " = " << arg1 << " % " << arg2;
			else if (op=="^")			outfile << result << " = " << arg1 << " ^ " << arg2;
			else if (op=="|")		outfile << result << " = " << arg1 << " | " << arg2;
			else if (op=="&")		outfile << result << " = " << arg1 << " & " << arg2;
			else if (op=="<<")		outfile << result << " = " << arg1 << " << " << arg2;
			else if (op==">>")		outfile << result << " = " << arg1 << " >> " << arg2;
			else if (op=="=")	
			{
				s=arg1;
				bool flag=true;
				if(s.empty() || ((!isdigit(s[0])) && (s[0] != '-') && (s[0] != '+'))) flag=false ;
				else
				{
					char * p ;
					strtol(s.c_str(), &p, 10) ;
					if(*p == 0) flag=true ;
					else flag=false;
				}
				if (flag) 
					outfile << "movl\t$" << atoi(arg1.c_str()) << ", " << "%eax" << endl;
				else
					outfile << "movl\t" << ST->ar[arg1] << "(%rbp), " << "%eax" << endl;
				outfile << "\tmovl \t%eax, " << ST->ar[result] << "(%rbp)";
			}			
			else if (op=="EQUALSTR")	
			{
				outfile << "movq \t$.LC" << arg1 << ", " << ST->ar[result] << "(%rbp)";
			}				
			else if (op=="==")
			{
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tcmpl\t" << ST->ar[arg2] << "(%rbp), %eax\n";

	 
				outfile << "\tje .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="!=")
			 {
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tcmpl\t" << ST->ar[arg2] << "(%rbp), %eax\n";
				outfile << "\tjne .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="<") 
			{
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tcmpl\t" << ST->ar[arg2] << "(%rbp), %eax\n";
				outfile << "\tjl .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==">")
			{
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tcmpl\t" << ST->ar[arg2] << "(%rbp), %eax\n";
				outfile << "\tjg .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op==">=") 
			{
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tcmpl\t" << ST->ar[arg2] << "(%rbp), %eax\n";
				outfile << "\tjge .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="<=") 
			{
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tcmpl\t" << ST->ar[arg2] << "(%rbp), %eax\n";
				outfile << "\tjle .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="GOTO") 
			{
				outfile << "jmp .L" << (2*labelCount+labelMap.at(atoi( result.c_str() )) +2 );
			}
			else if (op=="=&") 
			{
				outfile << "leaq\t" << ST->ar[arg1] << "(%rbp), %rax\n";
				outfile << "\tmovq \t%rax, " <<  ST->ar[result] << "(%rbp)";
			}
			else if (op=="=*") 
			{
				outfile << "movl\t" << ST->ar[arg1] << "(%rbp), %eax\n";
				outfile << "\tmovl\t(%eax),%eax\n";
				outfile << "\tmovl \t%eax, " <<  ST->ar[result] << "(%rbp)";	
			}
			
			else if (op=="*=")
			{
				outfile << "movl\t" << ST->ar[result] << "(%rbp), %eax\n";
				outfile << "\tmovl\t" << ST->ar[arg1] << "(%rbp), %edx\n";

	 
				outfile << "\tmovl\t%edx, (%eax)";
			}
					
			else if (op=="-") 
			{
				outfile << "negl\t" << ST->ar[arg1] << "(%rbp)";
			}
			else if (op=="~")		outfile << result 	<< " = ~" << arg1;
			else if (op=="!")			outfile << result 	<< " = !" << arg1;
			else if (op=="=[]") 
			{
				int off=0;
				off=theMap[arg2]*(-1)+ST->ar[arg1];
				outfile << "movq\t" << off << "(%rbp), "<<"%rax" << endl;
				outfile << "\tmovq \t%rax, " <<  ST->ar[result] << "(%rbp)";
			}	 			
			else if (op=="[]=") 
			{
				int off=0;
				off=theMap[arg1]*(-1)+ST->ar[result];
				outfile << "movq\t" << ST->ar[arg2] << "(%rbp), "<<"%rdx" << endl;
				outfile << "\tmovq\t" << "%rdx, " << off << "(%rbp)";

	 
			}	 
			else if (op=="RETURN") 
			{
				if(result!="") outfile << "movl\t" << ST->ar[result] << "(%rbp), "<<"%eax";
				else outfile << "nop";
			}
			else if (op=="PARAM") 
			{
				params.push_back(result);
			}
			else if (op=="CALL") 
			{
				// Function Table
				symtable* t = globalST->lookup(arg1)->nested;
				int i,j=0;	// index
				for (list <sym>::iterator it = t->ST.begin(); it!=t->ST.end(); it++) 
				{
					i = distance ( t->ST.begin(), it);
					if (it->category== "param") 
					{
						if(j==0) 
						{
							outfile << "movl \t" << ST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							outfile << "\tmovq \t" << ST->ar[params[i]] << "(%rbp), " << "%rdi" << endl;

	 
						}
						else if(j==1) 
						{
							outfile << "movl \t" << ST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							outfile << "\tmovq \t" << ST->ar[params[i]] << "(%rbp), " << "%rsi" << endl;
						}
						else if(j==2) 
						{
							outfile << "movl \t" << ST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							outfile << "\tmovq \t" << ST->ar[params[i]] << "(%rbp), " << "%rdx" << endl;
						}
						else if(j==3) 
						{
							outfile << "movl \t" << ST->ar[params[i]] << "(%rbp), " << "%eax" << endl;
							outfile << "\tmovq \t" << ST->ar[params[i]] << "(%rbp), " << "%rcx" << endl;
						}
						else 
						{
							outfile << "\tmovq \t" << ST->ar[params[i]] << "(%rbp), " << "%rdi" << endl;
						}

						j++;
						
					}
					else break;
				}
				params.clear();
				outfile << "\tcall\t"<< arg1 << endl;
				outfile << "\tmovl\t%eax, " << ST->ar[result] << "(%rbp)";
			}
			else if (op=="FUNC") 
			{
				outfile <<".globl\t" << result << "\n";
				outfile << "\t.type\t"	<< result << ", @function\n";
				outfile << result << ": \n";
				outfile << ".LFB" << labelCount <<":" << endl;
				outfile << "\t.cfi_startproc" << endl;
				outfile << "\tpushq \t%rbp" << endl;
				outfile << "\t.cfi_def_cfa_offset 8" << endl;
				outfile << "\t.cfi_offset 5, -8" << endl;
				outfile << "\tmovq \t%rsp, %rbp" << endl;
				outfile << "\t.cfi_def_cfa_register 5" << endl;

				ST = globalST->lookup(result)->nested;
				outfile << "\tsubq\t$" << ST->ST.back().offset+24 << ", %rsp"<<endl;
				
				symtable* t = ST;
				int i=0;
				for (list <sym>::iterator it = t->ST.begin(); it!=t->ST.end(); it++) 
				{
					if (it->category== "param") 
					{
						if (i==0) 
						{
							outfile << "\tmovq\t%rdi, " << ST->ar[it->name] << "(%rbp)";
						}
						else if(i==1) 
						{
							outfile << "\n\tmovq\t%rsi, " << ST->ar[it->name] << "(%rbp)";
						}
						else if (i==2) 
						{
							outfile << "\n\tmovq\t%rdx, " << ST->ar[it->name] << "(%rbp)";
						}
						else if(i==3) 
						{
							outfile << "\n\tmovq\t%rcx, " << ST->ar[it->name] << "(%rbp)";
						}

						i++;
					}
					else break;
				}
			}		
			else if (op=="FUNCEND") 
			{
				outfile << "leave\n";
				outfile << "\t.cfi_restore 5\n";
				outfile << "\t.cfi_def_cfa 4, 4\n";
				outfile << "\tret\n";
				outfile << "\t.cfi_endproc" << endl;

	 
				outfile << ".LFE" << labelCount++ <<":" << endl;
				outfile << "\t.size\t"<< result << ", .-" << result;
			}
			else outfile << "op";
			outfile << endl;
		}
	}
	outfile<<"\t.ident\t\"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0\"\n";
	outfile << 	"\t.section\t.note.GNU-stack,\"\",@progbits\n";
	outfile.close();
}
int main(int ac, char* av[]) 
{
	inputfile=inputfile+string(av[ac-1])+string(".c");
	outfilename=outfilename+string(av[ac-1])+string(".s");
	globalST = new symtable("Global");
	ST = globalST;
	yyin = fopen(inputfile.c_str(),"r"); 
	yyparse();
	globalST->update();
	globalST->print();
	q.print();
	genasm();
}
