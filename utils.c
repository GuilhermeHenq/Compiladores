/*+=============================================================
2 | UNIFAL = Universidade Federal de Alfenas .
3 | BACHARELADO EM CIENCIA DA COMPUTACAO.
4 | Trabalho . . : Funcao com retorno
5 | Disciplina : Teoria de Linguagens e Compiladores
6 | Professor . : Luiz Eduardo da Silva
7 | Aluno . . . . . : Guilherme Henrique Pereira Serafini
8 | Data . . . . . . : 17/02/2023
9 +=============================================================*/
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#define TAM_TAB 100
#define MAX_PAR 20

enum {INT, LOG};

//assinatura das funções
int desempilha(char);
void empilha(int, char);
void mostrapilha();
void limparTabela();
void arrumarPam(int, int);
void erroOne(int, int)



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct elemTabSimbolos {
    char id[100];
    int end;            //endereço (global) ou deslocamento (local)
    int tip;            // tipo
    char cat;           //categoria: "f" = Função, "p" = Parametro, ou "v" = Variavel
    char esc;           // escopo "g" = Global, "l" = Local
    int rot;            // rotulo (especifico para função)
    int npa;            // numero de parametros (para função)
    int par[MAX_PAR];   //Tipos dos parametros (para função)
} tabSimb[TAM_TAB], elemTab;

int posTab = 0; 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void maiscula (char *s) {
    for(int i = 0; s[i]; i++)
        s[i] = toupper(s[i]);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void limparTabela()
{
  for (int i = 0; i < posTab; i++){
      if (tabSimb[i].esc == 'L'){
          for(int j = i; j < posTab - 1; j++){
            tabSimb[j] = tabSimb[j + 1];
          }
          posTab--;
          i--;
      }
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
char * format_params(struct elemTabSimbolos elem)
{
  char *formatted_params = malloc(150);
    for (int i = 0; i < elem.npa; i++) {
      switch (elem.par[i]) {
        case 0:
          strcat(formatted_params, " |INT|");
          break;
        case 1:
          strcat(formatted_params, " |LOG|");
          break;
        default:
          break;
      }
      if (i < elem.npa - 1) {
        strcat(formatted_params, " -> ");
      }
    }
  return formatted_params;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void arrumarPam(int pos, int npa){
    tabSimb[pos].npa = npa;
    tabSimb[pos].end = (-3) - npa;
    for(int i = 1; i <= npa; i++){
      tabSimb[pos+i].end = ((-3) - npa) + i;
      tabSimb[pos].par[i-1] = tabSimb[pos+i].tip;
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// void ajustarPam(int pos, int npa){
//     for(int i = 1; i <= npa; i++){
//       tabSimb[pos].par[i-1] = tabSimb[pos+i].tip;
//     }
// }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// void printarParametro(){
//  for (int i = TAM_TAB - 1; i >= 0; i--) {
//     if (tabSimb[i].cat == 'f') {
//       if(tabSimb[i].cat == 'p'){
//         tabSimb
//       }
//     } 
//   }
// }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void updateParams(int count) {
  for (int i = TAM_TAB - 1; i >= 0; i--) {
    if (tabSimb[i].cat == 'f') {
      int params = count;
      tabSimb[i].npa = params;
      tabSimb[i].end = -3 - params;
      for (int j = 0; j < params; j++) {
        int idx = i + j + 1;
        tabSimb[idx].end = tabSimb[i].end + j + 1;
        tabSimb[idx].rot = 0;
        tabSimb[i].par[j] = tabSimb[idx].tip;
      } 
    } 
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int buscaSimbolo(char *id)
{
    int i;
    //maiscula(id);
    for (i = posTab - 1; strcmp(tabSimb[i].id, id) && i >= 0; i--)
        ;
    if (i == -1) {
        char msg[200];
        sprintf(msg, "Identificador [%s] não encontrado!", id);
        yyerror(msg);
    }
    return i;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void erroOne(int captura, int posFuncao) { 
        for(int i=0;i <= 100; i++){  
            if(tabSimb[posFuncao].par[i] != captura){
              yyerror("erro de blabla");
            }
        }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void insereSimbolo (struct elemTabSimbolos elem) {
    int i; 
    //maiscula(elem.id);
    if (posTab == TAM_TAB)
        yyerror("Tabela de Simbolos Cheia!");
    for (i = posTab - 1; strcmp(tabSimb[i].id, elem.id) && i >= 0; i--)
        ;
    if (i != -1) {
        char msg[200];
        sprintf(msg, "Identificador [%s] duplicado!", elem.id);
        yyerror(msg);
    }
    tabSimb[posTab++] = elem; 
}


// Desenvolver uma rotina para ajustar o endereço dos parametros
// na tabela de simbolos e o vetor de parametros na função
// depois que for cadastrado o ultimo parametro

// Modificar a rotina mostratabela para apresentar os outros campos
// (esc, rot, cat, ...) da tabela.

//void imprimirVetor (struct elemTabSimbolos elem)
//{
//    for(int i = 0; i < tabSimb[i].npa; i++) 
//    printf("[%d] -> [%d]")
//}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mostraTabela () {
    puts("---------------------------------------------------------------------------------------------------");
    puts("                                       Tabela de Simbolos");
    puts("---------------------------------------------------------------------------------------------------");
    printf("\n%s | %27s | %s | %s | %s | %s | %s | %s | %s \n", "#", "ID", "END", "TIP", "ESC", "ROT", "CAT", "NPAR", "PAR");
    for(int i = 0; i < 100; i++) 
        printf(".");
    printf("\n");
    for(int i = 0; i < posTab; i++) { 
        printf("\n%d", i); 
        printf("|%30s | %3d | %s | %2c | %3d | %3c | %3d | %2s\n", tabSimb[i].id, tabSimb[i].end, tabSimb[i].tip == INT ? "INT" : "LOG", tabSimb[i].esc
        , tabSimb[i].rot, tabSimb[i].cat, tabSimb[i].npa, format_params(tabSimb[i]));
        }
    printf("\n");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void testaTipo(int tipo1, int tipo2, int ret){
    int t1 = desempilha('t');
    int t2 = desempilha('t');
    if(t1 != tipo1 || t2 != tipo2) yyerror("Incompatibilidade de tipo!");
    empilha(ret, 't');
}

// estrutura da pilha semantica
// usada para enderecos, variaveis, rotulos
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define TAM_PIL 100
struct {
    int valor;
    char tipo; // "r" = rotulo, "n" = nvars, "t" = tipo, "p" = posicaoTabSimb
}pilha[TAM_PIL];

int topo = -1;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void empilha (int valor, char tipo) {
    if (topo == TAM_PIL)
        yyerror("Pilha semântica cheia");
    pilha[++topo].valor = valor;
    pilha[topo].tipo = tipo;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int desempilha(char tipo) {
    if (topo == -1)
        yyerror("Pilha semântica vazia");
    if(pilha[topo].tipo != tipo) {
        char msg[100];
        sprintf(msg, "Desempilha espera [%c] e encontrou[%c]", tipo, pilha[topo].tipo);
        yyerror(msg);
    }
  
    return pilha[topo--].valor;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mostrapilha()
{
    int i = topo;
    printf("Pilha = [");
    while (i >= 0)
    {
        printf("(%d, %c)", pilha[i].valor, pilha[i].tipo);
        i--;
    }
    printf("]\n");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////