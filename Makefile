all: bin/minic

lex.yy.c: minic.l minic.tab.h
	flex minic.l

minic.tab.c minic.tab.h: minic.y
	bison -d minic.y

bin/minic: lex.yy.c minic.tab.c
	gcc -Wall lex.yy.c minic.tab.c -o $@ -lfl

test: run_tests.c bin/minic
	$(CC) $(CFLAGS) $< -o bin/test
	bin/test

clean:
	rm -f lex.yy.c minic.tab.c minic.tab.h bin/minic bin/test

.PHONY: all clean test
