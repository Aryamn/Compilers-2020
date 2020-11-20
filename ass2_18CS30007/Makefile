a.out: main.o libass2_18CS30007.a
		g++ main.o -L. -lass2_18CS30007

main.o: main.cpp toylib.h
		g++ -Wall -c main.cpp

libass2_18CS30007.a: ass2_18CS30007.o
			ar -rcs libass2_18CS30007.a ass2_18CS30007.o

ass2_18CS30007.o: ass2_18CS30007.cpp toylib.h
		g++ -Wall -c ass2_18CS30007.cpp

clean: 
	rm a.out main.o libass2_18CS30007.a ass2_18CS30007.o