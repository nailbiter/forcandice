.PHONY: all

MONGODIR=/u/cs/98/9822058
INCLUDEFLAGS=\
	-I$(MONGODIR)/include/libbson-1.0 \
	-I$(MONGODIR)/include/libmongoc-1.0 \
	-I$(MONGODIR)/include/ctemplate

all: test.cgi

test.cgi: test.c
	gcc -o test.cgi test.c $(INCLUDEFLAGS) -L$(MONGODIR)/lib -lmongoc-static-1.0 -lbson-static-1.0 -lctemplate -static
