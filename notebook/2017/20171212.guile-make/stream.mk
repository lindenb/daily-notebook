all: test

test: a.out
	./a.out '(and (< (* 1000 rec-a) rec-b) (call2 myptr ))' 

a.out:  stream.c
	 gcc ` guile-config compile` $< ` guile-config link`
