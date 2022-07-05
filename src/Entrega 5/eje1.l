%{
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include "y.tab.h"
%}
%option case-insensitive
%%

(true|t)	return TRUE;
(false|f)	return FALSE; 
(" AND ")	return AND; /*Tanto AND, OR, XOR van entre espacios porque siempre van a estar entre valores logicos*/
(" OR ")	return OR;
(" XOR ")	return XOR;
("NOT ")	return NOT; /*NOT no empieza por espacio en blanco ya que: (1) la expresion logica empieza por NOT - (2) NOT sigue a otro operador. Luego de NOT sí que debe ir un espacio en blanco*/

("PRINT ")	return PRINT;	/*Cuando encontremos la palabra reverdada PRINT imprimimos el resultado*/
("EXIT")	return EXIT;	/*Palabra reservada con la que salimos del interprete*/

v[0-9]		{yylval.valor = atoi(yytext+1)-1; return VARIABLE; }
[a-zA-Z0-9]+	{strcpy(yylval.str,yytext); return CADENA; }

("IF ")	return IF;
(" THEN ")	return THEN;
(" ELSE ")	return ELSE;

[()=.\n]	return *yytext;

%%
int yywrap (void) {return 1;}
