; Item 2.asm
; Created: 18/05/2019 12:31:45
; Author : Bryan Wolff e João Pedro Bizzi Velho
; RAs: 214095 e 218711

/* 
R17: Grava o valor de N, o número de bytes a serem codificados 
R18: byte a ser analisado
R19: bit a ser analisado
R20: será 1 se o ultimo bit "1" analisado for -, e 0 se for +
R21: tornará o byte associado ao bit analisado
R22: r22 será usado para contar qual bit do byte esta sendo analisado
*/
.dseg 
code: .byte 24
.cseg
.org 0x00 ;início da memoria de programa onde conterá os dados
vetor: .db 3, 0x86, 0x73, 0xa4 ; Cria uma área para o vetor, o primeiro byte indica o número de bytes a serem analisados
.org 0x0200 ;início da memória do programa
	ldi r20,1 ;adotamos como convenção r20 como 1, para o primeiro "1" a ser codificado seja positivo
start:
	ldi r30,0
	LPM r17,Z ;r17 carrega o valor de N apartir do ponteiro Z
	ldi r27,0x03 ;local onde será armazenado o resultado codificado na memoria de dados
	ldi r26,0x00
retirada: ; loop para retirada dos valores a serem codificados
	dec r17 ; decrementa 1 do valor de n
	cpi r17,255 ;caso r17 ja percorreu os valores de N, o programa deve encerrar
	breq end
	inc r30 ; incrementa 1 no valor de z para pegar o próximo byte ao ser chamada a retirada
	LPM r18,Z ; coloca o byte a ser analizado no r18
	ldi r22,9 ;r22 será usado para contar qual bit do byte esta sendo analisado para posteriormente definir parada ao chegar em 0
	;r22 começará em 9 pois a primeira contagem em si começa decrementando r22 pra 8
checarbit:
	bst r18,7 ;armazena o bit 7 de r1 na flag T
	bld r19,0 ;carrega o bit da flag T na posição 0 de r19, logo r19 sempre assumira o valor do bit a ser analisado
	rol r18 ;desloca os bits de r18 uma casa para a esquerda
	dec r22	;contar quantos bits faltam a ser analisados
	cpi r22,0 ;se ja foi analisados todos os bits associado ao byte analisado, devemos ir para o proximo byte
	breq retirada	
	cpi r19,0
	breq detectou0 ;vai para essa subrotina se o bit analisado for 0
	jmp detectou1	;caso contrário o bit será 1, e vai pra sua respectiva subrotina
detectou0:
	;essa subrotina é chamada quando o bit analisado for zero, logo o byte associado deve ser 0 também
	ldi r21,0
	jmp armazenar
detectou1:
	cpi r20,1 ;r20 é 1 se o numero anterior for negativo, e se for negativo, o byte associado sera positivo
	breq obitserapositivo
	ldi r21,-1 ;caso contrário, o byte associado ao bit devera ser -1
	ldi r20,1	;aqui r20 é atualizado para a proxima verificação saber se a anterior é positiva ou negativa
	jmp armazenar
obitserapositivo:
	;essa subrotina sera chamada se o byte associado ao bit analisado devera ser o valor +1
	ldi r21,1 ;o byte sera associado ao +1
	ldi r20,0 ;aqui r20 é atualizado para a proxima verificação saber se a anterior é positiva ou negativa
armazenar:
	;essa subrotina será chamade sempre que ja achar o byte correspondente ao bit analisado
	st x+, r21	;escreve na memoria de dados o valor de r21
	jmp checarbit ; para analisar o próximo bit
end:
	break