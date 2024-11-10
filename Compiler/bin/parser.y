
%{ 
	#include<stdio.h>
	#include<stdlib.h>
	#include <string.h>
	char buffer[300];
	extern FILE *yyin;
	extern FILE *yyout;
	int i = 0;
	extern int yylex(void);

	void yyerror(const char *s);

	char* add_back(const char* temp, const char* a) {
		int i, j;
		if (temp == NULL) {
			char* mass = (char*)malloc(strlen(a) + 1);
			for (i = 0; i < strlen(a); i++)
				mass[i] = a[i];
			mass[strlen(a)] = '\0';
			return mass;
		}
		char* mass = (char*)malloc(strlen(temp) + strlen(a) + 1);
		for (i = 0; i < strlen(temp); i++)
			mass[i] = temp[i];
		for (i, j = 0; j < strlen(a); i++, j++)
			mass[i] = a[j];
		mass[strlen(temp) + strlen(a)] = '\0';
		return mass;
 }

	char* add_front(const char* temp, const char* a) {
		int i, j;
		if (temp == NULL) {
			char* mass = (char*)malloc(strlen(a) + 1);
			for (i = 0; i < strlen(a); i++)
				mass[i] = a[i];
			mass[strlen(a)] = '\0';
			return mass;
		}

		char* mass = (char*)malloc(strlen(temp) + strlen(a) + 1);
		for (i = 0; i < strlen(a); i++)
			mass[i] = a[i];
		for (i, j = 0; j < strlen(temp); i++, j++)
			mass[i] = temp[j];
		mass[strlen(temp) + strlen(a)] = '\0';
		return mass;
}

	char*build_var_array(const char*ident, const char*numb1, const char*numb2, const char* type){
		char* temp = NULL;
		if (!strcmp(type, "integer")){
			temp = add_front(temp, "int ");
			temp = add_back(temp, ident);
		}
		if (!strcmp(type, "real")){
			temp = add_front(temp, "double ");
			temp = add_back(temp, ident);
		}
		if (!strcmp(type, "string")){
			temp = add_front(temp, "char ");
			temp = add_back(temp, ident);
		}
		temp = add_back(temp, "[");
		temp = add_back(temp, numb2);
		temp = add_back(temp, "-");
		temp = add_back(temp, numb1);
		temp = add_back(temp, "+");
		temp = add_back(temp, "1");
		temp = add_back(temp, "]");
		temp = add_back(temp, ";");
		return temp;
	}

	char* build_var(const char*ident, const char* type){
		char* temp = NULL;
		if (!strcmp(type, "integer")){
			temp = add_front(temp, "int ");
			temp = add_back(temp, ident);
			temp = add_back(temp, ";");
		}
		if (!strcmp(type, "real")){
			temp = add_front(temp, "double ");
			temp = add_back(temp, ident);
			temp = add_back(temp, ";");
		}
		if (!strcmp(type, "string")){
			temp = add_front(temp, "char* ");
			temp = add_back(temp, ident);
			temp = add_back(temp, ";");
		}
		return temp;
	}

	char* build_prisv(const char* iden, const char*exp){
		char *temp = NULL;
		temp = add_front(exp, "=");
		temp = add_front(temp, iden);
		temp = add_back(temp, ";");
		return temp;
	}
	
	char* build_real(const char* numb1, const char*numb2){
		char *temp = NULL;
		temp = add_back(temp, numb1);
		temp = add_back(temp, ".");
		temp = add_back(temp, numb2);
		return temp;
	}
	void write_file(const char* temp){
		fwrite(temp, strlen(temp) * sizeof(char), 1, yyout);
	}

	char* add_double_perem(const char* $1, const char* oper, const char* $3){
		int i, j, k;
		char* temp = NULL;
		temp = add_front(temp, $3);
		temp = add_front(temp, oper);
		temp = add_front(temp, $1);
		return temp;
	}

	char* add_func(const char* func, const char* exp){
		int i, j;
		char* temp = (char*)malloc(strlen(func) + strlen(exp) + 3);
		for(i=0; i < strlen(func); i++)
			temp[i] = func[i];
		temp[i++] = '(';
		for(i, j=0; j < strlen(exp); i++, j++)
			temp[i] = exp[j];
		temp[i] = ')';
		temp[++i] = '\0';
		return temp;
	}

	char* add_br(const char* exp){
		char* temp = NULL;
		temp = add_front(exp, "(");
		temp = add_back(temp, ")");
		return temp;
	}

	char* add_array(const char* iden, const char* exp){
		char* temp = NULL;
		temp = add_front(exp, "[");
		temp = add_front(temp, iden);
		temp = add_back(temp, "]");
		return temp;
	}

	char* build_for(const char* iden,const char* exp, const char* term){
		char *temp = NULL;
		temp = add_back(temp, "for(");
		temp = add_back(temp, iden);
		temp = add_back(temp, "=");
		temp = add_back(temp, exp);
		temp = add_back(temp, ";");
		temp = add_back(temp, iden);
		temp = add_back(temp, "<=");
		temp = add_back(temp, term);
		temp = add_back(temp, ";");
		temp = add_back(temp, "++");
		temp = add_back(temp, iden);
		temp = add_back(temp, "){");
		return temp;
	}

	char* build_while(const char* exp){
		char *temp = NULL;
		temp = add_front(exp, "while(");
		temp = add_back(temp,"){");
		return temp;
	}

	char* build_if(const char* exp){
		char *temp = NULL;
		temp = add_front(exp, "if(");
		temp = add_back(temp,"){");
		return temp;
	}
	
	char* build_else(){
			char *temp = NULL;
			temp = add_front(temp, "else{");
			return temp;
	}
	
%}
%union {
	const char *text;
}

%start main
%token <text> IDEN VAR NUMB TYPE BEGINING ENDING IF THEN FOR TO DO ELSE WHILE FUNC_1
%token <text> DIV MOD PRISV OR AND OPER ARRAY OF
%type <text>  ident exp term  math_assig var_perem pere4_perem  if_term while_term for_term
%type <text>  menu begin recur

%%


main : 
	| BEGINING menu ENDING '.' {write_file("}");}
	| var_perem BEGINING menu ENDING '.'  {write_file("}");}
	| menu


	menu: | menu begin{write_file($2);}


	var_perem : VAR pere4_perem

	pere4_perem: 
	| pere4_perem ident ':' TYPE ';' {$$ = build_var($2,$4);write_file($$);}
	| pere4_perem ident ':' ARRAY '[' NUMB '.''.' NUMB ']' OF TYPE ';' {$$ = build_var_array($2,$6,$9, $12);write_file($$);}


	ident: IDEN {$$=$1}
	| ident ',' IDEN {$$=add_back($$,","); $$=add_back($$,$3);}




begin: |math_assig 
	| for_term
	| if_term
	| while_term

	math_assig : IDEN PRISV exp ';' {$$ = build_prisv($1, $3);}
	|IDEN'['exp']' PRISV exp ';' {$$=add_array($1, $3); $$ = build_prisv($$, $6);}

	exp:  term{$$ = $1;}
	| FUNC_1'('exp')'{$$=add_func($1, $3);}
	| exp OPER exp{$$=add_double_perem($1, $2, $3);}
	| exp DIV exp{$$=add_double_perem($1, "/", $3);}
	| exp MOD exp{$$=add_double_perem($1, "%", $3);}
	| exp AND exp {$$=add_double_perem($1, "&", $3);}
	| exp OR exp {$$=add_double_perem($1, "|", $3);}
	| exp '=' exp {$$=add_double_perem($1, "==", $3);}
	| '('exp')' {$$=add_br($2);}
	| IDEN'['exp']' {$$=add_array($1, $3);}


	term: IDEN{$$ = $1}
	|  NUMB{$$ = $1}
	|  NUMB'.'NUMB {$$ = build_real($1, $3);}

	for_term: FOR IDEN PRISV exp TO term DO BEGINING recur ENDING ';'{$$=build_for($2, $4, $6);$$=add_back($$,"\n");$$=add_back($$,$9);$$=add_back($$,"}");}

	while_term: WHILE exp DO BEGINING recur ENDING ';'{$$=build_while($2);$$=add_back($$,"\n");$$=add_back($$,$5);$$=add_back($$,"}");}

	if_term: IF exp THEN BEGINING recur ENDING ';'{$$=build_if($2);$$=add_back($$,"\n");$$=add_back($$,$5);$$=add_back($$,"}");}
	| IF exp THEN BEGINING recur ENDING ELSE BEGINING recur ENDING ';' {$$=build_if($2);$$=add_back($$,"\n");$$=add_back($$,$5);$$=add_back($$,"}");$$=add_back($$,"\n");$$=add_back($$,build_else());$$=add_back($$,"\n");$$=add_back($$,$9);$$=add_back($$,"}");}

	recur: begin{$$=$1;$$ = add_back($$, "\n");}
	| recur begin{$$ = add_back($$, $2);$$ = add_back($$, "\n");}

		
%%

int main(void)
{
	FILE *file;
    char filename[255];
	printf("Enter the file: ");
	scanf("%s", filename);
	yyin = fopen(filename, "r");
	if(!yyin){
		printf("!Error!: Error open file!\n");
		system("pause");
		return 1;
	}
	yyout = fopen("result.txt", "w");
	write_file("#include<stdio.h>\n#include<stdlib.h>\n#include <math.h>\nint main(void){\n");
	yyparse();
	printf("|Completed successfully|\n");
	printf("The result of the program is in the file: result.txt\n");
	fclose(yyin);
	fclose(yyout);
	
	system("pause");
    return 0;
}

void yyerror(const char *str) {
	fprintf(stderr, "!Error!: %s\n", str);
	system("pause");
	exit(0);
}