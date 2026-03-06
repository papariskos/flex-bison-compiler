%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
    int num;
}

%token <num> NUMBER
%type <num> expr

%left '+' '-'
%left '*' '/'

%%

input:
      input line
    | /* empty */
    ;

line:
      expr '\n'   { printf("Αποτέλεσμα = %d\n", $1); }
    | '\n'
    ;

expr:
      NUMBER            { $$ = $1; }
    | expr '+' expr     { $$ = $1 + $3; }
    | expr '-' expr     { $$ = $1 - $3; }
    | expr '*' expr     { $$ = $1 * $3; }
    | expr '/' expr     {
                            if ($3 == 0) {
                                yyerror("διαίρεση με το μηδέν");
                                $$ = 0;
                            } else {
                                $$ = $1 / $3;
                            }
                         }
    | '(' expr ')'      { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Σφάλμα: %s\n", s);
}

int main(void) {
    printf("Δώσε εκφράσεις, μία ανά γραμμή:\n");
    yyparse();
    return 0;
}
