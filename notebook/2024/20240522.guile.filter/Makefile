# Tell the C compiler where to find <libguile.h>
CFLAGS=`pkg-config --cflags guile-3.0`

# Tell the linker what libraries to use and where to find them.
LIBS=`pkg-config --libs guile-3.0`


test: a.out
	seq 1 7 100 | ./a.out '(= (modulo (_get) 7) 0)'
a.out: filter.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)
