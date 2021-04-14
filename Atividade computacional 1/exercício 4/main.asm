;
; ex4.asm
;
; Created: 06/05/2019 12:03:28
; Author : bryan
;

; divis�o inteiros entre dois n�meros naturais a e b, utilizando a=10 b=2 como exemplares
start:
	.cseg	;A diretiva CSEG define o in�cio de um segmento de c�digo.
	.org 0x0000	;A diretiva ORG pode ser usada para colocar c�digo e constantes em locais espec�ficos na mem�ria do programa, no caso eu escolhi no local 0x0000
	;se a diretiva ORG � dada dentro de um Segmento de C�digo, ent�o � o contador de mem�ria do Programa que � definido
	k: .db 17,4	;A diretiva DB est� reserva uma lista de express�es, que no caso contem os valores 17 e 4 para a e b respectivamente, na mem�ria do programa
	.org 0x002C			;inicio da memoria de programa
	ldi ZH,high(k*2)	;zh recebe o endere�o de a
	ldi ZL,low(k*2)		;zl recebe o endere�o de b
	lpm r16,Z+			;r16 recebe o valor de a
	lpm r17,Z+			;r17 recebe o valor de b
	ldi r18,0			;r18 ir� guardar o quociente
	mov r19,r16			;r19 guardar� o resto
	mov r22,r16			;r22 tamb�m ter� o valor de a
	mov r23,r17			;r23 tamb�m ter� o valor de b
	cp r22,r23			;assim podemos comparar a com b sem afetar os r16 e r17
	breq a_igual_b		;ir� executar se a for igual a b
	sub r22,r23			
	brmi a_menor_b		;ir� executar se a for menor que b
loop_a_maior_b:			;se nenhuma condi��o acima for verdadeira, entao a � maior que b
	sub r16,r17 ;subtra��o sucessiva de a-b
	brmi end	;se a subtra��o der negativo deve encerrar o programa
	breq end	;se a subtra��o zerar, o programa deve encerrar
	inc r18		;incrementa o quociente
	mov r19,r16	;seta o resto do valor
	jmp loop_a_maior_b	;recome�a o loop at� a divis�o seja efetiva
a_igual_b:	;se a igual a b sabemos que o resto ser� 0 e o quociente ser� 1
	ldi r18,1
	ldi r19,0
	jmp end
a_menor_b: ;se a menor que b, sabemos que nao vamos conseguir dividir, logo o resto � o pr�prio dividendo e o quociente � 0
	ldi r18,0
	mov r19,r17
	jmp end
end:
	break

