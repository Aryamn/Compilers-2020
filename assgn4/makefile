output.txt: a.out ass4_18CS30007_test.c
			./a.out

a.out: lex.yy.c y.tab.c ass4_18CS30007_main.o
		gcc lex.yy.c y.tab.c ass4_18CS30007_main.o -lfl


lex.yy.c: assgn4_18CS30007.l
			flex assgn4_18CS30007.l

y.tab.c: assgn4_18CS30007.y
			yacc -dtv assgn4_18CS30007.y

ass4_18CS30007_main.o: ass4_18CS30007_main.c
						gcc -c ass4_18CS30007_main.c



clean:
	rm y.tab.c y.tab.h a.out lex.yy.c  ass4_18CS30007_main.o y.output