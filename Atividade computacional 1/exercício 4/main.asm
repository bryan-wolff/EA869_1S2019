;
; ex4.asm
;
; Created: 06/05/2019 12:03:28
; Author : bryan
;

; divisão inteiros entre dois números naturais a e b, utilizando a=10 b=2 como exemplares
start:
	.cseg	;A diretiva CSEG define o início de um segmento de código.
	.org 0x0000	;A diretiva ORG pode ser usada para colocar código e constantes em locais específicos na memória do programa, no caso eu escolhi no local 0x0000
	;se a diretiva ORG é dada dentro de um Segmento de Código, então é o contador de memória do Programa que é definido
	k: .db 17,4	;A diretiva DB está reserva uma lista de expressões, que no caso contem os valores 17 e 4 para a e b respectivamente, na memória do programa
	.org 0x002C			;inicio da memoria de programa
	ldi ZH,high(k*2)	;zh recebe o endereço de a
	ldi ZL,low(k*2)		;zl recebe o endereço de b
	lpm r16,Z+			;r16 recebe o valor de a
	lpm r17,Z+			;r17 recebe o valor de b
	ldi r18,0			;r18 irá guardar o quociente
	mov r19,r16			;r19 guardará o resto
	mov r22,r16			;r22 também terá o valor de a
	mov r23,r17			;r23 também terá o valor de b
	cp r22,r23			;assim podemos comparar a com b sem afetar os r16 e r17
	breq a_igual_b		;irá executar se a for igual a b
	sub r22,r23			
	brmi a_menor_b		;irá executar se a for menor que b
loop_a_maior_b:			;se nenhuma condição acima for verdadeira, entao a é maior que b
	sub r16,r17 ;subtração sucessiva de a-b
	brmi end	;se a subtração der negativo deve encerrar o programa
	breq end	;se a subtração zerar, o programa deve encerrar
	inc r18		;incrementa o quociente
	mov r19,r16	;seta o resto do valor
	jmp loop_a_maior_b	;recomeça o loop até a divisão seja efetiva
a_igual_b:	;se a igual a b sabemos que o resto será 0 e o quociente será 1
	ldi r18,1
	ldi r19,0
	jmp end
a_menor_b: ;se a menor que b, sabemos que nao vamos conseguir dividir, logo o resto é o próprio dividendo e o quociente é 0
	ldi r18,0
	mov r19,r17
	jmp end
end:
	break

