.equ END_EEPROM = 0x000a ; endereço inicial a ser escrito na eeprom
.cseg
/*
Configuramos o vetor de interrupções colocando no primeiro um pulo para a posição nomeada como config 
e na posição relacionada com a interrupção da EEPROM colocamos um pulo para a RSI nomeada EE_RSI
*/
;vetor de interrupções
.org 0x0000
	rjmp config

.org 0x002c
	rjmp EE_RSI

/*Iniciamos o código apartir da posição 0x0034 que nao irá ocupar nenhum vetor*/ 

.org 0x0034
dados: .db 5 ,0x86,0x73,0xa4,0x5b,0x19

config:

/* Configuração do registrador EECR - Controle da EEPROM */
	sbi EECR , EEPM1 ; habilita para operaçao de escrita apenas
	cbi EECR , EEPM0 ; habilita para operação de escrita apenas tambem
	sbi EECR , EERIE ; liga a máscara de interrupções da eeprom
	
/* Configuração dos registradores para dados e endereços para memória de programa*/
	ldi ZH,high(dados*2) ; recebe a posição de memória de programa da qual serâo extraidos os bytes para a EEPROM
	ldi ZL,low(dados*2)	; recebe a posição de memória de programa da qual serâo extraidos os bytes para a EEPROM
	lpm r1 , Z + ; recebe o numero total de bytes a serem escritos 
	clr r2 ; Recebe o numero de bytes ja escritos
	ldi r27,high(END_EEPROM) ; Recebe o endereço da EEPROM em que gravaremos o primeiro byte
	ldi r26,low(END_EEPROM) ; Recebe o endereço da EEPROM em que gravaremos o primeiro byte
	sei

/* O loop Zillean será o responsável irá manter o processador "ocupado" enquanto a EEPROM está sendo gravada */
Zillean:
	nop 
	rjmp Zillean

EE_RSI:
	.org 0x0fff
	ldi r21,1
	in r19,SREG ; grava no registrador 19 o registrador I/O referente ao estado do processador
/* Segmento de endereços, gravamos nos registradores EEARH e EEARL o endereço da EEPROM no qual gravaremos o byte desejado */	
	out EEARH , r27 
	out EEARL , r26 
/*
Segmento de dados, gravamos no registrador r0 o valor do byte (retirado da memória de programa) e 
em seguida colocamos r0 no registrador de dados da EEPROM para ser gravado em seguida. 
*/
	lpm r0 , Z+ 
	out EEDR,r0 

/*Segmento de checagem e configurações finais da RSI, incrementamos o registrador (r26) que indica a posição da memória de programa 
de que devemos retirar os bytes, incrementamos o registrador que indica quantos bytes ja foram escritos (r2), restaura o valor do registrador de estado,
seta o valor dos bits da máscara de interrupção da EEPROM, EEMPE e EEPE. Comparamos o valor total de bytes que devem ser 
gravados e o valor de bytes já gravados, se forem iguais o programa chegou ao fim, o comando reti retorna ao loop Zillean para continuar a checagem da interrupção
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

/* Observação: podemos ter duas opções para finalizar o código, sendo elas:
 - Manter o loop de checagem de interrupção (apesar da interrupção referente à interrupção já ter sido desabilitada) indefinidamente
 - Parar a execução com um break dentro da RSI
*/  

