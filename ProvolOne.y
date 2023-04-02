%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>



    int yylex();
    void yyerror(const char *s){
      fprintf(stderr, "%s\n", s);
   };
  //Declaração do arquivo de saída.
   FILE *fout;
%}

// Definição dos tipos de tokens
%union
 {
   char *id;
   int  number;
};

// Declara os tokens
%type <id> varlist cmds cmd id;
%token <id> ID;
%token <number> ENTRADA; 
%token <number> SAIDA;
%token <number> FIM; 
%token <number> ENQUANTO;
%token <number> FIMENQUANTO;
%token <number> FACA; 
%token <number> ENTAO; 
%token <number> SE;  
%token <number> SENAO;
%token <number> INC; 
%token <number> ZERA; 
%token <number> FIMSE; 
%token <number> IGUAL;
%token <number> AP;  
%token <number> FP;  

// Começo da gramática 
%start program
%%

program: 
    ENTRADA varlist SAIDA varlist cmds FIM {
      
      // Criação do código c
      char* codigo = malloc(strlen($2) + strlen($4) + strlen($5) + 52);
      strcpy(codigo, "#include<stdio.h>\n\n");
      strcat(codigo, "int main(void){\n");
      strcat(codigo, $2);
      strcat(codigo, $4);
      strcat(codigo, $5);
      strcat(codigo, "\nreturn 0;\n}"); 
      fprintf(fout, "%s", codigo);

  
      fclose(fout);
      printf("o programa foi executado com exito e arquivo codigo.c criado\n");
      exit(0);
    };

varlist : 
    varlist id {
        char *resultado = malloc(strlen($1) + strlen($2) + 1);
        strcpy(resultado, $1);
        strcat(resultado, $2);
        $$ = resultado;
}
| id {
    $$ = $1;
};

id : 
  ID{
    char* resultado = malloc(strlen($1) + 11);
    strcpy(resultado, "int ");
    strcat(resultado, $1);
    strcat(resultado, "; ");
    $$ = resultado;
  };


cmds: 
    cmds cmd {
          char *resultado = malloc(strlen($1) + strlen($2) + 1);
          strcpy(resultado, $1);
          strcat(resultado, $2);
          $$ = resultado; 
        }
        | cmd {
          $$ = $1;
    };


cmd: 
    ENQUANTO ID FACA cmds FIMENQUANTO{
        char* resultado = (char*)malloc(strlen($2) + strlen($4) + 12);
        strcpy(resultado, "\nwhile(");
        strcat(resultado, $2);
        strcat(resultado, "){\n  ");
        strcat(resultado, $4);
        strcat(resultado, "}\n");
        $$ = resultado; 
    }

  |

    SE ID ENTAO cmds SENAO cmds FIMSE{
      char* resultado = malloc(strlen($2) + strlen($4) + strlen($6) + 29);
      strcpy(resultado, "\nif(");
      strcat(resultado, $2);
      strcat(resultado, "){\n  ");
      strcat(resultado, $4);
      strcat(resultado, "\n}");
      strcat(resultado, "else{\n  ");
      strcat(resultado, $6);
      strcat(resultado, "}\n");
      $$ = resultado;
      
    };
  | 
    SE ID ENTAO cmds FIMSE {
      char* resultado = malloc(strlen($2) + strlen($4) + 17);
      strcpy(resultado, "\nif(");
      strcat(resultado, $2);
      strcat(resultado, "){\n  ");
      strcat(resultado, $4);
      strcat(resultado, "\n}");
      $$ = resultado;

    };
      | ID IGUAL ID{
        char* resultado = malloc(strlen($1) + strlen($3) + 4);
        strcpy(resultado, $1);
        strcat(resultado, " = ");
        strcat(resultado, $3);
        $$ = resultado;
      };
      | INC AP ID FP{
        char* resultado = malloc(strlen($3) + 6);
        strcpy(resultado, $3);
        strcat(resultado, "++;\n");
        $$ = resultado;
      };
      | ZERA AP ID FP{
        char* resultado = malloc(strlen($3) + 8);
        strcpy(resultado, $3);
        strcat(resultado, " = 0;\n");
        $$ = resultado;
      };
%%

int main(int argc, char *argv[]){
  fout = fopen("codigo.c", "w");
  if(fout == NULL){
     fprintf(stderr, "nao foi possivel abrir o arquivo.\n");
     exit(1);
  }

  yyparse();
  return 0;
}
