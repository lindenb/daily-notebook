GUILE_VERSION=2.2
# Tell the C compiler where to find <libguile.h>
CFLAGS=`pkg-config --cflags guile-$(GUILE_VERSION)`

# Tell the linker what libraries to use and where to find them.
LIBS=`pkg-config --libs guile-$(GUILE_VERSION)`


test: a.out
	seq 1 100 | ./a.out '(= (modulo (_get) 7) 0)'
a.out: filter.c
	$(CC) $(CFLAGS) -o $@ $< $(LIBS)
