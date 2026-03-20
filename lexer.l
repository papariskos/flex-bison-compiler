%{
#include <stdio.h>
#include <stdlib.h>
/* Αυτή η γραμμή εισάγει αυτόματα όλα τα Tokens από τον Parser! */
#include "parser.tab.h"  
%}

/* Επιλογές του Flex */
%option noyywrap
%option case-insensitive

/* Κανονικές Εκφράσεις (Regular Expressions) */
digit       [0-9]
letter      [a-zA-Z]
id          ({letter}|_)({letter}|{digit}|_)*
integer     [+-]?{digit}+
number      {integer}(\.{digit}+)?
string      '([^'\n]*)'

/* Ορισμός των Σχολίων */
single_comment "--".*
multi_comment  "/*"([^*]|\*+[^*/])*\*+"/"

%%
    /* 1. ΑΓΝΟΗΣΗ ΣΧΟΛΙΩΝ ΚΑΙ ΚΕΝΩΝ */
{single_comment}    { /* Αγνοείται */ }
{multi_comment}     { /* Αγνοείται */ }
[ \t\r\n]+          { /* Αγνοείται */ }

    /* 2. ΚΛΕΙΔΙΑ SQL (KEYWORDS) */
"SELECT"    { return SELECT; }
"FROM"      { return FROM; }
"WHERE"     { return WHERE; }
"LIMIT"     { return LIMIT; }
"GROUP"     { return GROUP; }
"ORDER"     { return ORDER; }
"BY"        { return BY; }
"CREATE"    { return CREATE; }
"TABLE"     { return TABLE; }
"INT"       { return INT_TYPE; }
"FLOAT"     { return FLOAT_TYPE; }
"VARCHAR"   { return VARCHAR_TYPE; }
"ASC"       { return ASC; }
"DESC"      { return DESC; }

    /* 3. ΛΟΓΙΚΟΙ ΤΕΛΕΣΤΕΣ */
"AND"       { return AND; }
"OR"        { return OR; }
"NOT"       { return NOT; }
"IN"        { return IN; }

    /* 4. ΤΕΛΕΣΤΕΣ ΣΥΓΚΡΙΣΗΣ */
"="         { return EQ; }
"!="        { return NEQ; }
">"         { return GT; }
"<"         { return LT; }
">="        { return GTE; }
"<="        { return LTE; }

    /* 5. ΕΙΔΙΚΑ ΣΥΜΒΟΛΑ */
"*"         { return STAR; }
"("         { return LPAREN; }
")"         { return RPAREN; }
","         { return COMMA; }
";"         { return SEMICOLON; }

    /* 6. ΜΕΤΑΒΛΗΤΕΣ / ΤΙΜΕΣ (Επιστρέφουν τον αντίστοιχο τύπο) */
{number}    { return NUMBER; }
{string}    { return STRING; }
{id}        { return ID; }

    /* ΣΦΑΛΜΑ */
.           { printf("Lexical Error: Αγνωστος χαρακτήρας '%s'\n", yytext); }

%%

