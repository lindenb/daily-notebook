.SUFFIXES:
a.out: lex.yy.o exprsam.tab.o exprsam.o  

lex.yy.o : lex.yy.c exprsam.h exprsam.tab.h lex.yy.h
	gcc -o $@ -c $<

exprsam.tab.o : exprsam.tab.c exprsam.h exprsam.tab.h lex.yy.h
	gcc -o $@ -c $<


exprsam.o : exprsam.c  exprsam.h exprsam.tab.h lex.yy.h
	gcc -o $@ -c $<

lex.yy.h: lex.yy.c
	touch -c $@


lex.yy.c: exprsam.l
	flex -o $@ --header-file=lex.yy.h $<
	touch -c $@


exprsam.tab.h : exprsam.tab.c
	touch -c $@


exprsam.tab.c : exprsam.y
	bison -o $@  --defines=exprsam.tab.h -d $<
	touch -c $@


clean:
	rm -f exprsam.tab.c exprsam.tab.h
