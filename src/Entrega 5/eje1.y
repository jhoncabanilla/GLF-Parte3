%{
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

int yylex(void);
void yyerror(char *);
int vector[10];

%}
/*PRIMERA PARTE*/
%token AND OR XOR NOT	//Tokens que representan los diferentes operadores
%token TRUE FALSE	//Tokens que representan los valores logicos constantes: true y false
%token PRINT		//Token mediante el cual se muestra pantalla el valor de la variable o E.L.
%token EXIT		//Token finalizador

//Definimos la asociacion por la izquierda
%left AND OR XOR
%left NOT		//Mayor precedencia

%right '='		//Menor precedencia

/*SEGUNDA PARTE*/
%token IF ELSE THEN	//Tokens que utilizo para representar las sentencias condicionales

%union {
	int valor;
	char str[100];
}

%token <str> CADENA	//Token en el que guardo la cadena de caracteres introducida
%token <valor> VARIABLE //Token que utilizo para obtener el indice de la variable

//Indicamos el valor semantico asociado a cada simbolo auxiliar
%type <valor> S
%type <valor> asig
%type <valor> exp
%type <valor> term
%type <valor> bool

%type <str> cond

%%

start	: S '\n'
	| start S '\n'
	;

S	: asig		{$$ = $1; }
	| PRINT exp	{printf("%s\n", $2 ? "TRUE" : "FALSE");}  
	| PRINT cond	{printf("%s\n", $2); }
	| EXIT		{YYACCEPT;}
	;

asig	: VARIABLE '=' exp	{vector[$1] = $3; $$=$3;}	
	| VARIABLE '=' asig	{vector[$1] = $3; } //Asignacion en cascada
	;

exp	: VARIABLE			{$$ = vector[$1]; } /*Leemos del vector*/
	| exp AND exp			{$$ = $1 * $3;}
	| exp OR exp			{$$ = ($1==1||$3==1) ? 1 : 0;}
	| exp XOR exp			{$$ = ($1==$3) ? 0 : 1;}
	| NOT exp 			{if($2==0){$$=1;} else{$$=0;} }	
	| term				{$$ = $1;}	
	//CONDICIONAL SIMPLE
	| IF exp THEN exp		{if ($2==0){$$=0;} else{$$=$4;} }
	//CONDICIONAL DOBLE
	| IF exp THEN exp ELSE exp	{if ($2==1){$$=$4;} else{$$=$6;} } 
	;

cond	: IF exp THEN cond		{if ($2==0){strcpy($$,"\"\"");} else{strcpy($$,$4);} }
	| IF exp THEN cond ELSE cond	{if ($2==1){strcpy($$,$4);} else{strcpy($$,$6);} } 
	| CADENA			{strcpy($$,$1); } 
	;
 
term	: '(' exp ')' 	{$$ = $2;}
	| bool		{$$ = $1;}
	;

bool	: TRUE		{$$ = 1;}
	| FALSE	{$$ = 0;}
	;

%%

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {	
	//Inicializacion del vector
	int i;
	for (i=0; i<10; i++){
		vector[i] = 0;
	}

	yyparse();
	return 0;
}
