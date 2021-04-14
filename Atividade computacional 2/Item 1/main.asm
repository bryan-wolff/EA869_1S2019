; Item 1.asm
; Created: 18/05/2019 09:44:57
; Author : Bryan Wolff e João Pedro Bizzi Velho 
; RAs: 214095 e 218711


; R16 - deve guardar o valor de n
; R17 - guarda o resultado final da sequência
; R18 - indicador do número atual da sequência
; Usar stack 
; Usar recursão

.cseg
.org 0x0000

setup_inicial:
   
	ldi r16,8 ; Carrega o valor de n em 16
	push r20 ; coloca o valor 0 na pilha
	ldi r20,1 ; segundo valor da sequencia
	push r20 ; coloca o valor 1 na pilha
	ldi r18,2 ;grava o valor inicial 2 no registrador indicador (ja colocamos os dois valores iniciais da sequência na pilha, logo ni=2)

callit:

	call fibonacci ; chama a subrotina
	inc r18 ; incrementa o registrador que indica o número atual da sequência
	cp r18,r16 ; compara o valor atual da sequência com o valor n
	brne  callit ; reinicia o loop
	break

.org 0x0028

fibonacci: ;subrotina 
	
	pop r31 ; tira o ultimo valor da pilha
	pop r20 ; endereço de retorno
	pop r21 ; valor mais alto da sequencia
	pop r22 ; valor mais baixo da sequencia
	mov r17,r21 ; move o valor mais alto da sequencia para r17 (preservar o valor) 
	add r17,r22 ; soma os dois ultimos valores da sequencia
	push r22 ; insere o valor mais baixo na pilha
	push r21 ; insere o valor intermediario na pilha
	push r17 ; insere o valor mais alto na pilha
	push r20 ; insere o endereço de retorno na pilha
	push r31 ; insere de volta o valor retirado inicialmente da pilha
	ret ; retorna para a rotina padrão




	


	