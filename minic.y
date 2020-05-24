%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *str);
int yywrap(void);
int yylex(void);

// Hack - should be building an AST and traversing it.
static int return_code;

/* Input file */
extern FILE *yyin;

%}

%token TYPE IDENTIFIER RETURN NUMBER
%token OPEN_BRACE CLOSE_BRACE

%%

program:
        function
        ;

function:
        TYPE IDENTIFIER '(' ')' OPEN_BRACE expression CLOSE_BRACE
        ;

expression:
        RETURN NUMBER ';'
        { return_code = $2; }
        ;

%%

/* Print syntax / memory exhausted error - customise further to get more verbose error messages.  */
void yyerror(const char *str)
{
    fprintf(stderr,"error: %s\n",str);
}

/* Stop at end of file. */
int yywrap(void)
{
    return 1;
}

void write_skeleton(void)
{
    FILE *out = fopen("out.s", "wb");

    fprintf(out, ".text\n");
    fprintf(out, "    .global _start\n\n");
    fprintf(out, "_start:\n");

    fprintf(out, "    movl    $%d, %%ebx\n", return_code);

    fprintf(out, "    movl    $1, %%eax\n");
    fprintf(out, "    int     $0x80\n");

    fclose(out);
}

int main(int argc, char *argv[])
{
    ++argv, --argc; /* Skip program name */
    if (argc > 0) yyin = fopen(argv[0], "r");
    else yyin = stdin;
    
    yyparse();

    write_skeleton();
    printf("Written out.s.\n");
    printf("Build it with:\n");
    printf("    $ as out.s -o out.o --64\n");
    printf("    $ ld -s -o out out.o\n");

    return 0;
}

