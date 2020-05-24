all: minic

lex.yy.c: minic.l minic.tab.h
	flex minic.l

minic.tab.c minic.tab.h: minic.y
	bison -d minic.y

minic: lex.yy.c minic.tab.c
	gcc -Wall lex.yy.c minic.tab.c -o $@ -lfl

