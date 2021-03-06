%{
#include <stdio.h>
#include "minic.tab.h"
%}

%option noinput
%option nounput
%option noyywrap

%%

"//"[^\n]*    { /* Discard comments */ }
[ \t\n]+      { /* Ignore whitespace */ }

"{"           { return OPEN_BRACE; }
"}"           { return CLOSE_BRACE; }
"("           { return '('; }
")"           { return ')'; }
";"           { return ';'; }
[0-9]+        {
               /* TODO: check numbers are in the legal range, and don't start with 0. */
               printf("yytext: %s\n", yytext);
               printf("yylval: %d\n", atoi(yytext));
               yylval=atoi(yytext); return NUMBER;
              }
"return"      { return RETURN; }

"int"         { return TYPE; }
"main"        { return IDENTIFIER; }

%%

