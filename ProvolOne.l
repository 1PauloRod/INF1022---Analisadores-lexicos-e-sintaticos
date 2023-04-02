%option yywrap
      #include <stdio.h>
      #include <string.h>
      #include "ProvolOne.tab.h"
%%
FIM               {printf("FIM\n"); return(FIM);}
SAIDA             {printf("SAIDA "); return(SAIDA);}
ENTRADA           {printf("ENTRADA "); return(ENTRADA);}
ENQUANTO          {printf("ENQUANTO "); return (ENQUANTO);}
FIMENQUANTO       {printf("FIMENQUANTO "); return (FIMENQUANTO);}
FACA              {printf("FACA "); return (FACA);}
SE                {printf("SE "); return(SE);}
FIMSE             {printf("FIMSE "); return(FIMSE);}
ENTAO             {printf("ENTAO "); return(ENTAO);}
SENAO             {printf("SENAO "); return(SENAO);}
ZERA 		      {printf("ZERA "); return(ZERA);}
INC 		      {printf("INC "); return(INC);}
"=" 		      {printf("IGUAL "); return(IGUAL);}
"(" 		      {printf("AP "); return(AP);}
")"		      {printf("FP "); return(FP);}
[a-zA-Z]+         {printf("lido %s\n",yytext); yylval.id=strdup(yytext); return ID ; }
