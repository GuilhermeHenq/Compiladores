# Compiladores
Universidade Federal de Alfenas - UNIFAL-MG
Bacharelado em Ciˆencia da Computa¸c˜ao
Prof. Luiz Eduardo da Silva
Trabalho de Compiladores
Fun¸c˜ao com retorno
Objetivo
O objetivo desse trabalho ´e modificar o projeto do compilador para linguagem simples a fim
de permitir a compila¸c˜ao de fun¸c˜oes no estilo da linguagem C, com m´ultiplos pontos de sa´ıda
da fun¸c˜ao, atrav´es do comando retorne.
Problema
A fun¸c˜ao, nas linguagens de programa¸c˜ao, ´e um peda¸co de c´odigo que pode ser invocado em
qualquer lugar do programa com o uso do nome da fun¸c˜ao. Valores podem ser passados atrav´es
dos parˆametros e o resultado da fun¸c˜ao ´e devolvido na express˜ao em que a fun¸c˜ao foi chamada.
Linguagens de programa¸c˜ao no estilo de Pascal (Pascal-like) usam um mecanismo de retorno
do resultado atrav´es da vari´avel-nome-da-fun¸c˜ao, conforme foi apresentado nos exemplos da
linguagem Simples. A atribui¸c˜ao, dentro da fun¸c˜ao, para a vari´avel-nome-da-fun¸c˜ao define o
valor que ser´a retornado da chamada da fun¸c˜ao, quando a fun¸c˜ao ´e finalizada.
As linguagens C-like implementam um mecanismo diferente. Existe o comando return expressao que pode ser colocado em qualquer ponto da fun¸c˜ao e determina sua sa´ıda com o valor
da express˜ao. Diferente do mecanismo Pascal-like, nas linguagens parecidas com C ´e poss´ıvel
m´ultiplos pontos de sa´ıda da fun¸c˜ao.
1 i n t f ( i n t a , i n t b ) {
2 i f ( a > b )
3 r e t u r n a ;
4 r e t u r n b ;
5 }
Roteiro
1. Defina regras para permitir a declara¸c˜ao de fun¸c˜oes, conforme o seguinte exemplo:
1 func i n t e i r o MAIOR ( i n t e i r o A i n t e i r o B)
2 i n i c i o
3 s e A > B
4 en t a o r e t o r n e A
5 sen a o r e t o r n e B
6 fim s e
7 fim f u n c
2. Defina a palavra-reservada retorne, no l´exico, e um comando retorne expressao, no sint´atico,
que s´o pode ser usado no contexto da fun¸c˜ao (em C isso n˜ao ´e necess´ario, pois o corpo
principal do c´odigo est´a numa fun¸c˜ao denominada main).
1
3. Considere que a fun¸c˜ao s´o admite parˆametros passados por valor.
4. O compilador deve verificar compatibilidade no tipo da fun¸c˜ao, no n´umero e tipo dos
parˆametros na chamada da fun¸c˜ao.
5. O compilador deve ser capaz de produzir as tradu¸c˜oes conforme os seguintes exemplos:
Exemplo 1:
1 programa t e s t e 1
2 func i n t e i r o maior ( i n t e i r o a i n t e i r o b )
3 i n i c i o
4 s e a > b
5 en t a o r e t o r n e a
6 sen a o r e t o r n e b
7 fim s e
8 fim f u n c
9 i n i c i o
10 e s c r e v a maior ( 1 0 2 0 )
11 fimprograma
1 INPP
2 DSVS L0
3 L1 ENSP
4 CRVL =4
5 CRVL =3
6 CMMA
7 DSVF L2
8 CRVL =4
9 ARZL =5
10 RTSP 2
11 DSVS L3
12 L2 NADA
13 CRVL =3
14 ARZL =5
15 RTSP 2
16 L3 NADA
17 L0 NADA
18 AMEM 1
19 CRCT 10
20 CRCT 20
21 SVCP
22 DSVS L1
23 ESCR
24 FIMP
Exemplo 2:
1 programa t e s t e 2
2 i n t e i r o x y
3 func i n t e i r o maior ( i n t e i r o a i n t e i r o b )
4 l o g i c o c
5 i n i c i o
6 c <= a > b
7 s e c
8 en t a o r e t o r n e a
9 sen a o r e t o r n e b
10 fim s e
11 fim f u n c
12 i n i c i o
13 l e i a x
2
14 l e i a y
15 e s c r e v a maior ( x y )
16 fimprograma
1 INPP
2 AMEM 2
3 DSVS L0
4 L1 ENSP
5 AMEM 1
6 CRVL =4
7 CRVL =3
8 CMMA
9 ARZL 0
10 CRVL 0
11 DSVF L2
12 CRVL =4
13 ARZL =5
14 DMEM 1
15 RTSP 2
16 DSVS L3
17 L2 NADA
18 CRVL =3
19 ARZL =5
20 DMEM 1
21 RTSP 2
22 L3 NADA
23 L0 NADA
24 LEIA
25 ARZG 0
26 LEIA
27 ARZG 1
28 AMEM 1
29 CRVG 0
30 CRVG 1
31 SVCP
32 DSVS L1
33 ESCR
34 DMEM 2
35 FIMP
Exemplo 3:
1 programa t e s t e 3
2 i n t e i r o x
3 func i n t e i r o quadrado ( i n t e i r o a )
4 i n i c i o
5 r e t o r n e a * a
6 fim f u n c
7 i n i c i o
8 l e i a x
9 e s c r e v a quadrado ( quadrado ( x ) )
10 fimprograma
1 INPP
2 AMEM 1
3 DSVS L0
4 L1 ENSP
5 CRVL =3
6 CRVL =3
7 MULT
3
8 ARZL =4
9 RTSP 1
10 L0 NADA
11 LEIA
12 ARZG 0
13 AMEM 1
14 AMEM 1
15 CRVG 0
16 SVCP
17 DSVS L1
18 SVCP
19 DSVS L1
20 ESCR
21 DMEM 1
22 FIMP
Exemplo 4:
1 programa t e s t e 4
2 i n t e i r o x
3 func i n t e i r o f a t o r i a l ( i n t e i r o a )
4 i n i c i o
5 s e a > 0
6 en t a o r e t o r n e a * f a t o r i a l ( a = 1 )
7 sen a o r e t o r n e 1
8 fim s e
9 fim f u n c
10 i n i c i o
11 l e i a x
12 e s c r e v a f a t o r i a l ( x )
13 fimprograma
1 INPP
2 AMEM 1
3 DSVS L0
4 L1 ENSP
5 CRVL =3
6 CRCT 0
7 CMMA
8 DSVF L2
9 CRVL =3
10 AMEM 1
11 CRVL =3
12 CRCT 1
13 SUBT
14 SVCP
15 DSVS L1
16 MULT
17 ARZL =4
18 RTSP 1
19 DSVS L3
20 L2 NADA
21 CRCT 1
22 ARZL =4
23 RTSP 1
24 L3 NADA
25 L0 NADA
26 LEIA
27 ARZG 0
28 AMEM 1
29 CRVG 0
4
30 SVCP
31 DSVS L1
32 ESCR
33 DMEM 1
34 FIMP
Entrega
1. Incluir um coment´ario no cabe¸calho de cada programa fonte com o seguinte formato:
1 /*+=============================================================
2 | UNIFAL = U ni v e r si d a d e F e d e r al de Al f e n a s .
3 | BACHARELADO EM CIENCIA DA COMPUTACAO.
4 | Trabalho . . : Funcao com r e t o r n o
5 | D i s c i p l i n a : Te o ri a de Lingua gen s e Compiladores
6 | P r o f e s s o r . : Luiz Eduardo da S i l v a
7 | Aluno . . . . . : Fulano da S i l v a
8 | Data . . . . . . : 99/99/9999
9 +=============================================================*/
2. A pasta com o projeto dever´a incluir o seguinte arquivo makefile:
1 sim pl e s : u t i l s . c l e x i c o . l s i n t a t i c o . y ; \
2 f l e x =o l e x i c o . c l e x i c o . l ; \
3 bi s o n =o s i n t a t i c o . c s i n t a t i c o . y =v =d ; \
4 gcc s i n t a t i c o . c =o sim pl e s
5
6 limpa : ; \
7 rm =f l e x i c o . c s i n t a t i c o . c s i n t a t i c o . output *˜ s i n t a t i c o . h sim pl e s \
3. O compilador dever´a ter o nome ”simples”e executado atrav´es da seguinte chamada
1 . / sim pl e s nomeprograma [ . sim pl e s ]
4. Enviar num arquivo ´unico (.ZIP), a pasta do projeto com somente os arquivos fontes
