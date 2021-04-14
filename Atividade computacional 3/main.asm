;
; ex1.asm
;
; Created: 05/05/2019 12:55:32
; Author : Bryan Wolff e João Pedro Bizzi Velho
; RAs: 214095 e 218711
;

;parametro será inserido no r20
	ldi r20,1 ;para cada valor n inserido aqui, teremos aproximadamente como tempo n*(0,1) segundos
start:
	dec r20  ; diminui o valor de r20, que contém o número de vezes que o programa será executado
	cpi r20,255  ; compara com 255
	breq end ; se for igual o programa para 
	ldi r17,255 ; carrega o valor inicial de r17
	ldi r18,5 ; carrega o valor inicial de r18
	ldi r19,54 ; carrega o valor incial de r19
loop:
	dec r18  ; inicia o loop decrementando o valor de r18
	cpi r18,0 ; caso r18 for igual a zero o loop 4 será executado, se não o loop 2 será
	breq loop4
loop2:
	dec r17  ; decrementa r17
	ldi r16,244 ; carrega 244 em r16
	cpi r17,0 ; compara r17 com 0
	breq loop ; se for diferente de zero prossegue como o decremento de r16 se não ele volta ao loop
loop3:
	dec r16 ; decrementa r16 
	cpi r16,0 ; compara com zero
	breq loop2 ; vai voltar decrementar r16 de novo
	jmp loop3 ; executa o pulo
loop4:
	dec r19 ; decrementa o valor de r19
	cpi r19,0; compara com zero
	breq start  ; se for igual a zero retorna para o começo do programa
	ldi r16,250 ; se for diferente atribui 250 a r16
loop5:
	dec r16	; decrementa o valor de r16
	inc r16	;foi incrementado e decrementado para adicionar dois clocks ao loop5
	dec r16
	cpi r16,0 ; compara com zero
	breq loop4 ; se for igual volta a loop 4 para decrementar r19
	jmp loop5 ; se for diferente executa loop 5
end:
	break ;o programa será encerrado
