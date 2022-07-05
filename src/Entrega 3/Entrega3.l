
int [+-]?[0-9]+
float [-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?
char [a-zA-Z]
string [a-zA-Z0-9]*
%x BORRAR

%%

"//".*		;
"/*" 		BEGIN(BORRAR);
<BORRAR>(.|\n)	;
<BORRAR>"*/"	BEGIN 0;
{int}		printf("INT");
{float} 	printf("FLOAT");
if 		printf("IF");
else		printf("ELSE");
{char}{string}	printf("ID (%s, %d)" , yytext, yyleng);

%%

main(int argc, char** argv){

	if (argc > 1){
		
		FILE *file;
		file = fopen(argv[1], "r");
		if (!file){
			fprintf(stderr, "No se pudo abrir el fichero %s\n", argv[1]);
			exit(1);
		}
		yyin = file;
	}

	yylex();
}
