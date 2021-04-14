;
; Projeto Final.asm
;
; Author : Bryan Wolff - João Pedro Bizzi Velho - Julia Alves Farias
;

.def state = r21

;definimos r21 como state, usaremos como referência para saber seu estado atual

;VETORES DE INTERRUPÇÃO.........................................................................

;início do segmento de código
.cseg
	;a partir de 0x00, temos o vetor de interrupção
	.org 0x0000
	rjmp reset
	;em 0x0002, deve vir o desvio para a rotina de serviço associada a INT0 (externa)
	.org 0x0002
	rjmp pressed_button
	;o vetor de interrupção termina em 0x0034, a partir de onde podemos começar o programa 
	.org 0x0034						 

;INTERRUPÇÃO RESET.............................................................................

reset:
	; configurar interrupção externa INT0

	;seta os dois bits menos significativos - a INT0 será ativada na borda de subida do pino 2 da porta D
	/* A variável pré-definida EICRA está relacionada a um endereço de I/O mapeada em memória
	   Por isso, devemos usar as instruções lds/sts (load/store) para lidar com este endereço */
	lds r16,EICRA
	ori r16,0x03
	sts EICRA,r16

	;habilita a interrupção INT0
	/* 	   A variável pré-definida EIMSK está relacionada a um endereço de I/O (isolada)
	   Por isso, devemos usar as instruções in/out para lidar com este endereço	*/
	in r16,EIMSK
	ori r16,0x01
	out EIMSK,r16

	;habilita a porta 5 de DDRB para trabalhar como saída (onde será mandado energia para o led)
	sbi DDRB,5 ;Seta o bit 5 de DDRB(0x04)

	;habilita a porta 2 de DDRd para trabalhar como entrada (onde tá conectado o botão e receberá nível alto ao pressiona-lo)
	cbi DDRD,2
	
	;faz com que o programa não inicie o led a piscar até o botão ser pressionado uma primeira vez
	clr state

	;habilita todas as interrupções
	sei								


;PROGRAMA PRINCIPAL...............................................................................

/*
o programa principal irá verificar o registrador referente ao estado atual, se houve mudança de estado, o main irá fazer o programa
permanecer num loop nesse estado, até que o estado mude pela interrupção.
		*/
main:	
	cpi state,1 ;verifica se o estado atual é o primeiro
	breq state0	;se for, a subrotina do estado 0 será chamada
	cpi state,2 ;verifica se o estado atual é o segundo
	breq state1 ;se for, a subrotina do estado 1 será chamada
	cpi state,3 ;verifica se o estado atual é o terceiro
	breq state2 ;se for, a subrotina do estado 2 será chamada
	
	;como o state iniciará em zero, o programa ficará em um loop no main até que o botão seja apertado para que o led entre no primeiro estado
	rjmp main


;INTERRUPÇÃO DO BOTÃO..........................................................................

pressed_button:
	;rotina de serviço da interrupção externa (botão)
	;salva o regist. de estado
	/* 	   A variável pré-definida SREG está relacionada a um endereço de I/O (isolada)
	   Por isso, devemos usar as instruções in/out para lidar com este endereço	*/
	;incrementa o contador
	inc state ;irá servir para referencia para localizar em que estado se encontra
	cpi state,4 ;r21 não pode ir para um quarto estado, só podendo voltar para o seu primeiro
	breq reset_state
	;restaura o regist. de estado
desvio:
	reti ;encerra a interrupção

reset_state: ;chamada para voltar ao seu estado inicial
	ldi state,1
	jmp desvio


;ESTADOS............................................................................................

state0: ;led pisca 1s
	ldi r20,20 ;temos que definir o parametro de r20 para que o delay desejado
	call led_on	;liga o led
	ldi r20,20 ;temos que definir o parametro de r20 para que o delay desejado
	call led_off ;desliga o led
	rjmp main

state1: ;led pisca 0,5s
	ldi r20,10 ;temos que definir o parametro de r20 para que o delay desejado
	call led_on	;liga o led
	ldi r20,10 ;temos que definir o parametro de r20 para que o delay desejado
	call led_off ;desliga o led
	rjmp main

state2:	;led pisca 0,25s
	ldi r20,5  ;temos que definir o parametro de r20 para que o delay desejado
	call led_on	;liga o led
	ldi r20,5  ;temos que definir o parametro de r20 para que o delay desejado
	call led_off ;desliga o led
	rjmp main

;SUBROTINA DOS LEDS................................................................

led_on: 
	;seta a porta onde o led esta conectado
	sbi PORTB,5 ;seta o bit 5 de PORTB(0x05)
	call delay_routine
	ret

led_off:
	;zera a porta onde o led está conectado
	cbi PORTB,5 ;zera o bit 5 de PORTB (0x05)
	call delay_routine
	ret

;ROTINA DE ATRASO................................................................

delay_routine:
	;rotina de atraso, antes de chamar ela deve-se definir r20, que é seu parametro
	;para cada valor n inserido em r20, teremos aproximadamente como tempo n*(0,05) segundos
	;então para este programa n = 5, 10 ou 20, teremos um atraso de 0,25s , 0,5s ou 1s respectivamente
	mov r17,r20
start_atraso:
	dec r20
	cpi r20,255 
	breq end_atraso 
	ldi r17,255
	ldi r18,5
	ldi r19,23
loop_atraso:
	dec r18
	cpi r18,0
	breq loop4_atraso
loop2_atraso:
	dec r17
	ldi r16,125
	cpi r17,0
	breq loop_atraso
loop3_atraso:
	dec r16 
	cpi r16,0
	breq loop2_atraso
	jmp loop3_atraso
loop4_atraso:
	dec r19
	cpi r19,0
	breq start_atraso
	ldi r16,191
loop5_atraso:
	dec r16
	inc r16
	dec r16
	cpi r16,0
	breq loop4_atraso
	jmp loop5_atraso
end_atraso:
	ret
