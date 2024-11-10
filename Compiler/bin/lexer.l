%option noyywrap

%{ 
	#include <stdio.h>
	#include <string.h>
	#include "parser.tab.h"

%}
%%
[ /n/t] {}
[0-9]+ { yylval.text = strdup(yytext); return NUMB;}
var {return VAR;}
begin {return BEGINING;}
end {return ENDING;}
mod {return MOD;}
div {return DIV;}
:= {return PRISV;}
if {return IF;}
else {return ELSE;}
for {return FOR;}
to {return TO;}
do {return DO;}
while {return WHILE;}
then {return THEN;}
and {return AND;}
or {return OR;}
array { return ARRAY;}
of { return OF;}
cos|sin|sqrt|tan { yylval.text = strdup(yytext); return FUNC_1;}
integer|real|string|boolean {yylval.text = strdup(yytext); return TYPE;}
[a-zA-Z]([a-zA-Z]|_|[0-9])* {yylval.text = strdup(yytext);return IDEN;} 
[ = ; , ( ) { } ? : . \[ \]] {return *yytext;}
[- + * < >] { yylval.text = strdup(yytext); return OPER; }
. {printf("Unknown symbol %s\n", yytext); system("pause"); exit(0);}
%%