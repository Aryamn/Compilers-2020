asmGenerate: asmGenerator
	@./asmGenerator 1 > asgn6_18CS30007_quads1.out
	@./asmGenerator 2 > asgn6_18CS30007_quads2.out
	@./asmGenerator 3 > asgn6_18CS30007_quads3.out
	@./asmGenerator 4 > asgn6_18CS30007_quads4.out
	@./asmGenerator 5 > asgn6_18CS30007_quads5.out
	@echo "Quads Files Generated"
	@echo "Input 'make run' to generate executables"
asmGenerator: lex.yy.o y.tab.o asgn6_18CS30007_translator.o asgn6_18CS30007_target_translator.o libass6_18CS30007.a
	@g++ lex.yy.o y.tab.o asgn6_18CS30007_translator.o asgn6_18CS30007_target_translator.o -lfl -o asmGenerator

asgn6_18CS30007_target_translator.o: asgn6_18CS30007_target_translator.cxx
	@g++ -c asgn6_18CS30007_target_translator.cxx

asgn6_18CS30007_translator.o: asgn6_18CS30007_translator.cxx asgn6_18CS30007_translator.h
	@g++ -c asgn6_18CS30007_translator.h
	@g++ -c asgn6_18CS30007_translator.cxx

lex.yy.o: lex.yy.c
	@g++ -c lex.yy.c

y.tab.o: y.tab.c
	@g++ -c y.tab.c

lex.yy.c: asgn6_18CS30007.l y.tab.h asgn6_18CS30007_translator.h
	@flex asgn6_18CS30007.l

y.tab.c: asgn6_18CS30007.y
	@yacc -dtv asgn6_18CS30007.y -Wno

y.tab.h: asgn6_18CS30007.y
	@yacc -dtv asgn6_18CS30007.y -Wno
	
clean:
	rm lex.yy.c y.tab.c y.tab.h  *.s *.out *.gch *.o *.a asmGenerator y.output test*

#Test files

run : test1 test2 test3 test4 test5
	@echo ""
	@echo "./test1 -> To run arithmetic Operators"
	@echo "./test2 -> To find min and find max"
	@echo "./test3 -> To find sum of n natural numbers"
	@echo "./test4 -> To find factorial of a number "
	@echo "./test5 -> To run rod cutting problem using Dynamic Programming"


test1: asgn6_18CS30007_1.o libass6_18CS30007.a
	@g++ -m64 -no-pie asgn6_18CS30007_1.o -o test1 -L. -lass6_18CS30007 
asgn6_18CS30007_1.o: myl.h asgn6_18CS30007_1.s
	@g++ -m64  -c asgn6_18CS30007_1.s 

test2: asgn6_18CS30007_2.o libass6_18CS30007.a
	@g++ -m64 -no-pie asgn6_18CS30007_2.o -o test2 -L. -lass6_18CS30007
asgn6_18CS30007_2.o: myl.h
	@g++ -m64 -c asgn6_18CS30007_2.s

test3: asgn6_18CS30007_3.o libass6_18CS30007.a
	@g++ -m64 -no-pie asgn6_18CS30007_3.o -o test3 -L. -lass6_18CS30007
asgn6_18CS30007_3.o: myl.h
	@g++ -m64 -c asgn6_18CS30007_3.s

test4: asgn6_18CS30007_4.o libass6_18CS30007.a
	@g++ -m64 -no-pie asgn6_18CS30007_4.o -o test4 -L. -lass6_18CS30007
asgn6_18CS30007_4.o: myl.h
	@g++ -m64 -c asgn6_18CS30007_4.s

test5: asgn6_18CS30007_5.o libass6_18CS30007.a
	@g++ -m64 -no-pie asgn6_18CS30007_5.o -o test5 -L. -lass6_18CS30007
asgn6_18CS30007_5.o: myl.h
	@g++ -m64 -c asgn6_18CS30007_5.s


libass6_18CS30007.a: ass6_18CS30007.o
	@ar -rcs libass6_18CS30007.a ass6_18CS30007.o

ass6_18CS30007.o: ass6_18CS30007.c myl.h
	@gcc -Wall -c ass6_18CS30007.c 

output: output.o libass6_18CS30007.a
	@gcc -g  output.o -o output -L. -lass6_18CS30007
output.o: output.s myl.h
	@gcc -g -Wall -c output.s
