;
; ex1.asm
;
; Created: 05/05/2019 12:55:32
; Author : bryan
;

start:
	;determine a soma de todos os n�meros naturais de 1 a n
	; determinando n um valor exemplar igual a 5
	ldi	r16,5
	;definindo um valor inicial para a soma 
	ldi r17,1
	;r18 vai ser onde acumular� a soma
	ldi r18,0
loop: 
	;vai adicionar o conteudo do r17 no r18
	add r18,r17
	;vai comparar se j� chegou no valor de n, e se chegou vai parar
	cp r17,r16
	breq fim_loop
	;se n�o chegou no valor de n, r17 ser� incrementado para recome�ar o loop
	inc r17
	rjmp loop
fim_loop:
	break
