output.txt : a.out ass3_18CS30007_test.c
			./a.out  

a.out : lex.yy.c assgn3_18CS30007.o
		gcc -Wall assgn3_18CS30007.o -lfl

lex.yy.c : ass3_18CS30007.l
			flex ass3_18CS30007.l

ass3_18CS30007.o : assgn3_18CS30007.c
				gcc -c -Wall assgn3_18CS30007.c

clean:
		rm lex.yy.c a.out assgn3_18CS30007.o