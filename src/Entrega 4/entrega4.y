%{
#include<stdio.h>
#include "lex.yy.c"

int yyerror(char * s){
        fprintf(stderr, "%s\n", s);
        return 0;
}
%}

%%

I : S '\n'      	{ printf("Correcto\n"); };
A: '/''*'
B: '*''/'
S : A S B S 		{ printf("S->a S b S\n"); } | { printf("S->epsilon\n"); };


%%

int main(){
        yyparse();
        return 1;
}

