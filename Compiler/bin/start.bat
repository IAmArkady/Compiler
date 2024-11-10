flex lexer.l
bison -d parser.y
gcc -c lex.yy.c parser.tab.c 
gcc -o program.exe lex.yy.o parser.tab.o
del parser.tab.c
pause