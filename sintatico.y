%{
#include "lexico.c"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "utils.c"

int contaVar;
int numeroPar;
int rotulo = 0;
int tipo;
char escopo = 'G';

// quantidade de variaveis locais de cada funcao
int contaVarLoc;

// a posicao de endereco da funcao vai ser guardada aqui, inicializa -1 para nao ter erro de comecar com 0 e o endereco ser 0
int posFuncao = -1;

//quantidade de funcoes do programa
int funcoesQuantidade;

%}

%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_LEIA
%token T_ESCREVA
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_FACA
%token T_ENQTO
%token T_FIMENQTO
%token T_INTEIRO
%token T_LOGICO
%token T_RETORNE
%token T_FUNC
%token T_FIMFUNC
%token T_MAIS
%token T_MENOS
%token T_VEZES
%token T_DIV
%token T_ATRIBUI
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_E
%token T_OU
%token T_NAO
%token T_ABRE
%token T_FECHA
%token T_V 
%token T_F 
%token T_IDENTIF
%token T_NUMERO

%start programa 
%expect 1


%left T_E T_OU 
%left T_IGUAL 
%left T_MAIOR T_MENOR 
%left T_MAIS T_MENOS 
%left T_VEZES T_DIV

%%


programa 
    : cabecalho 
        { 
        contaVar = 0; 
        escopo = 'G';
        }
    variaveis 
        { 
            empilha(contaVar, 'n');
            if (contaVar) 
                fprintf(yyout,"\tAMEM\t%d\n", contaVar); 
            
        }

    // acrescentar as funções
    // rotinas é uma rotina feita pelo Luiz para chamar as funcoes
       rotinas
       T_INICIO lista_comandos T_FIM
        { 
            int conta = desempilha('n');
            if (conta)
                fprintf(yyout,"\tDMEM\t%d\n", conta); 
            fprintf(yyout,"\tFIMP\n");
            mostraTabela();
        } 
    ;

cabecalho
    : T_PROGRAMA T_IDENTIF
        { fprintf(yyout,"\tINPP\n"); }
    ;

variaveis
    :
    | declaracao_variaveis
    ;

declaracao_variaveis
    : tipo lista_variaveis declaracao_variaveis
    | tipo lista_variaveis
    ;

tipo 
    : T_LOGICO 
        { tipo = LOG; }
    | T_INTEIRO
        { tipo = INT; }
    ;

lista_variaveis
    : lista_variaveis T_IDENTIF 
        { 
          strcpy(elemTab.id, atoma);
          elemTab.end = contaVar;
          elemTab.tip = tipo;
          elemTab.esc = escopo;
          elemTab.cat = 'v';
          insereSimbolo(elemTab);
          contaVar++;
          if (elemTab.esc == 'f')
            contaVarLoc++;
        }
    | T_IDENTIF
        { 
          strcpy(elemTab.id, atoma);
          elemTab.end = contaVar;
          elemTab.tip = tipo;
          elemTab.esc = escopo;
          elemTab.cat = 'v';
          insereSimbolo(elemTab);
          contaVar++;
          if (elemTab.esc == 'f')
            contaVarLoc++;
        }
    ;

rotinas
    : //nao tem fucoes
    |
        { fprintf(yyout,"\tDSVS\tL0\n");}
    funcoes
        { fprintf(yyout,"L0\tNADA\n"); }
    ;

// regras para as funções
// acrescentar lista_parametros
funcoes
    : funcao
    | funcao funcoes
    {
    //contavar == ...
    // fprintf(yyout...)
    }
    ;

funcao 
    : T_FUNC tipo T_IDENTIF 
    {
    strcpy(elemTab.id, atoma);
    elemTab.tip = tipo;
    elemTab.cat = 'f';
    elemTab.esc = escopo;
    escopo = 'L';
    elemTab.rot = ++rotulo;
    insereSimbolo(elemTab);
    // buscaRot = buscaSimbolo.elemTab id;
    fprintf(yyout,"L%d\tENSP\n", rotulo);
    contaVar++;

    // guarda o endereco da funcao na variavel posFuncao
    posFuncao = buscaSimbolo(elemTab.id);  


    }
    T_ABRE parametros T_FECHA 
        // ROTINA PARA AJUSTAR PARAMETROS
       {
            arrumarPam(posFuncao, numeroPar);
            //updateParams(numeroPar);
       }
    variaveis {
        // ROTINA AJUSTAR VARIAVEIS LOCAIS RET
        //empilha(contaVarLoc, 'n');
        // verifica se há variaveis locais e as armazena gerando um AMEM
        if(contaVarLoc)
            fprintf(yyout,"\tAMEM\t%d\n", contaVarLoc);
    }
    T_INICIO{
        //mostrapilha();
    }
    
     lista_comandos T_FIMFUNC
    { 
        /* if(retorno == 0)
            yyerror("A função precisa de retorno"); */
        
        //limpa tabela tirando as variaveis locais
        limparTabela();

        // posFuncao volta ao seu valor original visto que acabou a funcao
        posFuncao = -1;
        // escopo volta a ser global
        escopo = 'G';
        // soma-se 1 na quantidade de funcoes do programa
        funcoesQuantidade++;  

    }
    ;

parametros
    :
    | parametro parametros
    ;

parametro 
    : tipo T_IDENTIF
    { 

        strcpy(elemTab.id, atoma);
        elemTab.tip = tipo;
        elemTab.esc = 'L';
        elemTab.cat = 'p';
        elemTab.rot = 0;
        insereSimbolo(elemTab);
        // armazena +1 na variavel de numero de parametros
        numeroPar++;
    }
    ;


lista_comandos
    :
    | comando lista_comandos
    ;

comando 
    : entrada_saida
    | repeticao 
    | selecao
    | atribuicao 
    | retorno
    ;

retorno
    : T_RETORNE //{mostrapilha();} 
    expressao
    {

    // se a posFuncao esta com valor padrao, nao existe endereco de funcao
    // logo nao existe funcao, e o retorno foi chamado na main    
    if(posFuncao == -1){
        yyerror("Retorno chamado na main!");
    }

    //mostrapilha();
    int tipo2 = desempilha('t');
    int tipo = tabSimb[posFuncao].tip;
    if (tipo2 != tipo){
        yyerror("incompatibilidade de tipo a variavel");
    }
    fprintf(yyout,"\tARZL\t%d\n", tabSimb[posFuncao].end);
    // verifica se há variaveis locais e desaloca memória
    if (contaVarLoc){
        fprintf(yyout,"\tDMEM\t%d\n", contaVarLoc);
    }
    // desaloca memoria com o numero de parametros da func
    fprintf(yyout,"\tRTSP\t%d\n", tabSimb[posFuncao].npa);
    
    }
    // deve gerar (depois da traducao)
    // ARZL (valor de retorno) DMEN (se tiver variavel local)
    // e um RTSP n
    ;

entrada_saida
    : leitura
    | escrita
    ;


leitura 
    : T_LEIA T_IDENTIF
        
        { 
            int pos = buscaSimbolo(atoma);
            fprintf(yyout,"\tLEIA\n\tARZG\t%d\n", tabSimb[pos].end); 
        }
    ;

escrita 
    : T_ESCREVA expressao 
        {
            desempilha('t'); 
            fprintf(yyout,"\tESCR\n");
        }
    ;

repeticao 
    : T_ENQTO
        { 
            fprintf(yyout,"L%d\tNADA\n", ++rotulo); 
            empilha(rotulo, 'r');
        } 
    expressao T_FACA  
        { 
            int tip = desempilha('t');
            if(tip != LOG) yyerror("Incompatibilidade de tipo!");
            fprintf(yyout,"\tDSVF\tL%d\n", ++rotulo); 
            empilha(rotulo, 'r');
        }
    lista_comandos
    T_FIMENQTO
        {
            int rot1 = desempilha('r');
            int rot2 = desempilha('r');
            fprintf(yyout,"\tDSVS\tL%d\nL%d\tNADA\n", rot2, rot1); 

        }
    ;

selecao 
    : T_SE expressao T_ENTAO 
        { 
            int tip = desempilha('t');
            if(tip != LOG) yyerror("Incompatibilidade de tipo!");
            fprintf(yyout,"\tDSVF\tL%d\n", ++rotulo);
            empilha(rotulo, 'r'); 
        }
    lista_comandos T_SENAO 
        {
            int rot = desempilha('r'); 
            fprintf(yyout,"\tDSVS\tL%d\nL%d\tNADA\n", ++rotulo, rot); 
            empilha(rotulo, 'r');
        }
    lista_comandos T_FIMSE
        {
            int rot = desempilha('r'); 
            fprintf(yyout,"L%d\tNADA\n", rot); 
        }
    ;

atribuicao 
    : T_IDENTIF
        {
            int pos = buscaSimbolo(atoma);
            empilha(pos, 'p');
        } 
      T_ATRIBUI expressao 
        { 
            int tip = desempilha('t');
            int pos = desempilha('p');
            if(tabSimb[pos].tip != tip) 
                yyerror("Incompatibilidade de tipo!");
            if(tabSimb[pos].esc == 'G') 
                fprintf(yyout,"\tARZG\t%d\n", tabSimb[pos].end); 
            else
                fprintf(yyout,"\tARZL\t%d\n", tabSimb[pos].end); 
        }

expressao 
    : expressao T_VEZES expressao 
        { 
            testaTipo(INT, INT, INT);
            fprintf(yyout,"\tMULT\n"); 
        }
    | expressao T_DIV expressao 
        { 
            testaTipo(INT, INT, INT);
            fprintf(yyout,"\tDIVI\n"); 
        }
    | expressao T_MAIS expressao
        {   
            testaTipo(INT, INT, INT);
            fprintf(yyout,"\tSOMA\n"); 
        } 
    | expressao T_MENOS expressao
        { 
            testaTipo(INT, INT, INT);
            fprintf(yyout,"\tSUBT\n"); 
        } 
    | expressao T_MAIOR expressao
        { 
            testaTipo(INT, INT, LOG);
            fprintf(yyout,"\tCMMA\n"); 
        } 
    | expressao T_MENOR expressao 
        {
            testaTipo(INT, INT, LOG);
            fprintf(yyout,"\tCMME\n"); 
        }
    | expressao T_IGUAL expressao
        { 
            testaTipo(INT, INT, LOG);
            fprintf(yyout,"\tCMIG\n");
        } 
    | expressao T_E expressao 
        { 
            testaTipo(LOG, LOG, LOG);
            fprintf(yyout,"\tCONJ\n"); 
        }
    | expressao T_OU expressao
        { 
            testaTipo(LOG, LOG, LOG);
            fprintf(yyout,"\tDISJ\n"); 
        } 
    | termo 
    ;

identificador
    : T_IDENTIF
     {  
       int pos = buscaSimbolo(atoma);
       empilha (pos, 'p');
     }
    ;


// A funcao eh chamada como um termo numa expressao
chamada
    : // sem parametros eh uma variavel
        {
            //mostrapilha();
            int pos = desempilha('p');
            if (tabSimb[pos].esc == 'G'){   
                fprintf(yyout, "\tCRVG\t%d\n", tabSimb[pos].end);
            }else {  
                fprintf(yyout,"\tCRVL\t%d\n", tabSimb[pos].end);
            }
            empilha(tabSimb[pos].tip, 't');
        }
    | T_ABRE 
            {fprintf(yyout, "\tAMEM\t%d\n", funcoesQuantidade);}
    lista_argumentos 
    T_FECHA
    {
        int pos = desempilha('p');
        fprintf(yyout, "\tSVCP\n");
        fprintf(yyout, "\tDSVS\tL%d\n", tabSimb[pos].rot);
        empilha (tabSimb[pos].tip, 't');
    }
    ;

lista_argumentos
    : 
    | expressao {
        desempilha('t');
    }
    lista_argumentos
    ;


termo 
    : identificador chamada
    /* : T_IDENTIF
       { 
            int pos = buscaSimbolo(atoma);
            fprintf(yyout,"\tCRVG\t%d\n", tabSimb[pos].end);
            empilha(tabSimb[pos].tip, 't');
        } */
    | T_NUMERO
        { 
            fprintf(yyout,"\tCRCT\t%s\n", atoma); 
            empilha(INT, 't');
        }
    | T_V 
        { 
            fprintf(yyout,"\tCRCT\t1\n"); 
            empilha(LOG, 't');    
        }
    | T_F 
        { 
            fprintf(yyout,"\tCRCT\t0\n");
            empilha(LOG, 't');    
        }
    | T_NAO termo
        {
            int t = desempilha('t');
            if(t != LOG) yyerror("Incompatibilidade de tipo!");
            fprintf(yyout,"\tNEGA\n"); 
            empilha(LOG,'t');
        }
    | T_ABRE expressao T_FECHA
    ;

%%


int main (int argc, char *argv[]) {
    char *p, nameIn[100], nameOut[100];
    argv++;
    if (argc < 2) {
        puts("\nCompilador Simples");
        puts("\n\tUso: ./simples <NOME>[.simples]\n\n");
        exit(10);
    }
    p = strstr(argv[0], ".simples");
    if (p) *p = 0;
    strcpy(nameIn, argv[0]);
    strcat(nameIn, ".simples");
    strcpy(nameOut, argv[0]);
    strcat(nameOut, ".mvs");
    yyin = fopen (nameIn, "rt");
    if (!yyin) {
        puts("Programa fonte não encontrado!");
        exit(20);
    }
    yyout = fopen(nameOut, "wt");
    yyparse();
    puts("Programa ok!");
}