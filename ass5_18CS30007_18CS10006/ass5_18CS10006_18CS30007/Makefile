all: a.out
	@echo "\n+++++++++++++++++++ Test 1 +++++++++++++++++++"
	./a.out < ass5_18CS30007_18CS10006_test1.c > ass5_18CS30007_18CS10006_quads1.out

	@echo "\n+++++++++++++++++++ Test 2 +++++++++++++++++++"
	./a.out < ass5_18CS30007_18CS10006_test2.c > ass5_18CS30007_18CS10006_quads2.out

	@echo "\n+++++++++++++++++++ Test 3 +++++++++++++++++++"
	./a.out < ass5_18CS30007_18CS10006_test3.c > ass5_18CS30007_18CS10006_quads3.out

	@echo "\n+++++++++++++++++++ Test 4 +++++++++++++++++++"
	./a.out < ass5_18CS30007_18CS10006_test4.c > ass5_18CS30007_18CS10006_quads4.out

	@echo "\n+++++++++++++++++++ Test 5 +++++++++++++++++++"
	./a.out < ass5_18CS30007_18CS10006_test5.c > ass5_18CS30007_18CS10006_quads5.out
	
	@echo "\n+++++++++++++++++++ Test 6 +++++++++++++++++++"
	./a.out < ass5_18CS30007_18CS10006_test6.c > ass5_18CS30007_18CS10006_quads6.out
	
	@echo "\nAll Test Cases Successfully Translated !!\n"

a.out: lex.yy.o y.tab.o ass5_18CS30007_18CS10006_translator.o 
	g++ lex.yy.o y.tab.o ass5_18CS30007_18CS10006_translator.o -lfl


y.tab.o:	y.tab.c
	g++ -c y.tab.c

lex.yy.o:	lex.yy.c
	g++ -c lex.yy.c

lex.yy.c:	ass5_18CS30007_18CS10006.l y.tab.c
	flex ass5_18CS30007_18CS10006.l 

y.tab.c:	ass5_18CS30007_18CS10006.y
	yacc -Wno -dtv ass5_18CS30007_18CS10006.y 

ass5_18CS30007_18CS10006_translator.o: ass5_18CS30007_18CS10006_translator.h ass5_18CS30007_18CS10006_translator.cxx
	g++ -c ass5_18CS30007_18CS10006_translator.cxx

clean:
	rm a.out y.tab.o lex.yy.o lex.yy.c y.tab.c y.tab.h y.output ass5_18CS30007_18CS10006_translator.o ass5_18CS30007_18CS10006_quads*.out
