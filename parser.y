%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
void yyerror(const char *s);
%}

/* Ορισμός των Tokens (Τα στέλνει το lexer.l) */
%token SELECT FROM WHERE LIMIT GROUP ORDER BY CREATE TABLE INT_TYPE FLOAT_TYPE VARCHAR_TYPE ASC DESC AND OR NOT IN
%token EQ NEQ GT LT GTE LTE STAR LPAREN RPAREN COMMA SEMICOLON
%token NUMBER STRING ID

/* Αρχικός (Root) κανόνας */
%start statements

%%

/* === ΒΑΣΙΚΟΙ ΚΑΝΟΝΕΣ === */

statements:
      create_table_stmt
    | select_stmt
    ;

/* Η Εντολή CREATE TABLE */
create_table_stmt:
      CREATE TABLE ID LPAREN lista_stilwn_pinaka RPAREN SEMICOLON
    ;

/* Λίστα στηλών για το CREATE TABLE (Αναδρομικά) */
lista_stilwn_pinaka:
      ID Type
    | ID Type COMMA lista_stilwn_pinaka
    ;

Type:
      INT_TYPE
    | FLOAT_TYPE
    | VARCHAR_TYPE LPAREN NUMBER RPAREN
    ;

/* Η Εντολή SELECT */
select_stmt:
      SELECT lista_stilwn_select FROM_clause WHERE_clause GROUP_BY_clause ORDER_BY_clause LIMIT_clause SEMICOLON
    ;

lista_stilwn_select:
      STAR
    | lista_stilwn
    ;

lista_stilwn:
      ID
    | ID COMMA lista_stilwn
    ;

FROM_clause:
      FROM ID
    ;

WHERE_clause:
      WHERE condition
    | /* Εψιλον: Κενό */
    ;

GROUP_BY_clause:
      GROUP BY lista_stilwn
    | /* Εψιλον */
    ;

ORDER_BY_clause:
      ORDER BY lista_stilwn order_opt
    | /* Εψιλον */
    ;

order_opt:
      ASC
    | DESC
    | /* Εψιλον */
    ;

LIMIT_clause:
      LIMIT NUMBER
    | /* Εψιλον */
    ;

/* === ΣΥΝΘΗΚΕΣ === */

condition:
      expr_with_not
    | expr_with_not log_op condition
    ;

expr_with_not:
      expression
    | NOT expression
    ;

log_op:
      AND
    | OR
    ;

expression:
      ID operator value
    | ID IN LPAREN value_list RPAREN
    | ID NOT IN LPAREN value_list RPAREN
    ;

operator:
      EQ | NEQ | GT | LT | GTE | LTE
    ;

value:
      NUMBER
    | STRING
    | ID
    ;

value_list:
      value
    | value COMMA value_list
    ;

%%

/* === C ΚΩΔΙΚΑΣ (MAIN & ERRORS) === */

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error (Συντακτικό Σφάλμα)!\n");
}

int main() {
    printf("Έναρξη αναλυτή SQL (Ctrl+D / Ctrl+Z για τερματισμό)\n");
    printf("Γράψε δοκιμαστικά μια εντολή CREATE TABLE ή SELECT:\n> ");
    
    int result = yyparse();
    
    if (result == 0) {
        printf("Επιτυχία: Η εντολή είναι 100%% Σωστή Συντακτικά!\n");
    }
    return result;
}

