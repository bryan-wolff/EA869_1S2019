.equ END_EEPROM = 0x000a ; endere�o inicial a ser escrito na eeprom
.cseg
/*
Configuramos o vetor de interrup��es colocando no primeiro um pulo para a posi��o nomeada como config 
e na posi��o relacionada com a interrup��o da EEPROM colocamos um pulo para a RSI nomeada EE_RSI
*/
;vetor de interrup��es
.org 0x0000
	rjmp config

.org 0x002c
	rjmp EE_RSI

/*Iniciamos o c�digo apartir da posi��o 0x0034 que nao ir� ocupar nenhum vetor*/ 

.org 0x0034
dados: .db 5 ,0x86,0x73,0xa4,0x5b,0x19

config:

/* Configura��o do registrador EECR - Controle da EEPROM */
	sbi EECR , EEPM1 ; habilita para opera�ao de escrita apenas
	cbi EECR , EEPM0 ; habilita para opera��o de escrita apenas tambem
	sbi EECR , EERIE ; liga a m�scara de interrup��es da eeprom
	
/* Configura��o dos registradores para dados e endere�os para mem�ria de programa*/
	ldi ZH,high(dados*2) ; recebe a posi��o de mem�ria de programa da qual ser�o extraidos os bytes para a EEPROM
	ldi ZL,low(dados*2)	; recebe a posi��o de mem�ria de programa da qual ser�o extraidos os bytes para a EEPROM
	lpm r1 , Z + ; recebe o numero total de bytes a serem escritos 
	clr r2 ; Recebe o numero de bytes ja escritos
	ldi r27,high(END_EEPROM) ; Recebe o endere�o da EEPROM em que gravaremos o primeiro byte
	ldi r26,low(END_EEPROM) ; Recebe o endere�o da EEPROM em que gravaremos o primeiro byte
	sei

/* O loop Zillean ser� o respons�vel ir� manter o processador "ocupado" enquanto a EEPROM est� sendo gravada */
Zillean:
	nop 
	rjmp Zillean

EE_RSI:
	.org 0x0fff
	ldi r21,1
	in r19,SREG ; grava no registrador 19 o registrador I/O referente ao estado do processador
/* Segmento de endere�os, gravamos nos registradores EEARH e EEARL o endere�o da EEPROM no qual gravaremos o byte desejado */	
	out EEARH , r27 
	out EEARL , r26 
/*
Segmento de dados, gravamos no registrador r0 o valor do byte (retirado da mem�ria de programa) e 
em seguida colocamos r0 no registrador de dados da EEPROM para ser gravado em seguida. 
*/
	lpm r0 , Z+ 
	out EEDR,r0 

/*Segmento de checagem e configura��es finais da RSI, incrementamos o registrador (r26) que indica a posi��o da mem�ria de programa 
de que devemos retirar os bytes, incrementamos o registrador que indica quantos bytes ja foram escritos (r2), restaura o valor do registrador de estado,
seta o valor dos bits da m�scara de interrup��o da EEPROM, EEMPE e EEPE. Comparamos o valor total de bytes que devem ser 
gravados e o valor de bytes j� gravados, se forem iguais o programa chegou ao fim, o comando reti retorna ao loop Zillean para continuar a checagem da interrup��o
*/
	inc r26 
	inc r2 

	out SREG,r19
	 
	sbi EECR , EEMPE 
	sbi EECR , EEPE 
	
	cp r1,r2
	breq end

retorno:	
	reti

end:
	cbi EECR,EERIE
	break
	;rjmp retorno 

/* Observa��o: podemos ter duas op��es para finalizar o c�digo, sendo elas:
 - Manter o loop de checagem de interrup��o (apesar da interrup��o referente � interrup��o j� ter sido desabilitada) indefinidamente
 - Parar a execu��o com um break dentro da RSI
*/  

