;
; ex3.asm
;
; Created: 05/05/2019 17:22:50
; Author : bryan
;


; Replace with your application code
start:
	;insiro uma cadeia bin�ria abcdefgh com o valor de um �mero palindromo como exemplar, no caso o numero 189
    ldi r16,185
	;partirei atribuindo 0 ao r20, e colocarei 1 se, e somente se, o n�mero de r16 for palindromo
	ldi r20,0
	ldi r17,0
	mov r18,r16
	;isolando 4 bits da direita para ficar 0000efgh usaremos o n�mero 00001111=15
	andi r18,15 ;assimm, posteriormente irei usar o conteudo de r18 para compara��o
	;para conseguirmos a cadeia 0000dcba, vamos trasferir os bits apartir da flag T
	bst r16,7; Armazene o bit 7 de r16 na flag T
	bld r17,0; Carregue T no bit 0 de r17
	bst r16,6; Armazene o bit 6 de r16 na flag T
	bld r17,1; Carregue T no bit 1 de r17
	bst r16,5; Armazene o bit 5 de r16 na flag T
	bld r17,2; Carregue T no bit 2 de r17
	bst r16,4; Armazene o bit 4 de r16 na flag T
	bld r17,3; Carregue T no bit 3 de r17
	cp r17,r18 ;se o n�mero for palindromo, o valor de r18 ser� igual ao de r17
	breq palindromo ;caso seja, chamar� a fun�ao palindromo para atribuir valor 1 ao r20
	jmp end ;caso n�o seja, o programa encerrar� com 0 no r20
palindromo:
	ldi r20,1
	jmp end
end:
	break
