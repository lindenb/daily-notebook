CFLAGS=$(shell R CMD config --cppflags)
LDFLAGS=$(shell R CMD config --ldflags)
CC=g++

RSession : RSession.o
	$(CC) -o $@ $(LDFLAGS) $<
RSession.o : RSession.cpp
	$(CC) $(CFLAGS) -o $@ -c -g $<
