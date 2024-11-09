.MODEL SMALL
.STACK 100h

.DATA
Intro db 10,13,7,"CONVERSOR BASICO",10,13,7,"------------------",10,13,7,"$"
Menu db 10,13,7,"1.DECIMAL->BINARIO",10,13,7,"2.BINARIO->DECIMAL",10,13,7,
        "3.DECIMAL->HEXADECIMAL",10,13,7,"4.HEXADECIMAL->DECIMAL",10,13,7,
        "5.BINARIO->HEXADECIMAL",10,13,7,"6.HEXADECIMAL->BINARIO",10,13,7,
        "7.SALIR",10,13,7,"$"
opcion db ?
Elija db 10,13,7,"ELIJA SU OPCION : ","$"
Ingrese db 10,13,7,"INGRESE EL NUMERO : ","$"
MResultado db 10,13,7,"RESULTADO : ","$"
Salto db 10,13,7,"$"
numero db 16 dup('$')  

;decimal binario variables-------------------------------------
numero_decimal dw 0   
binario db 16 dup(0) 
longitud_bin db 0    
temp dw 0           

;binario decimal variables------------------------------------
resultado_decimal dw 0    
error_msg db 10,13,7,'ERROR: Numero binario invalido$'  
potencia dw 1            

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MENU_PRINCIPAL:
    MOV AH, 09h
    LEA DX, Intro
    INT 21h

    MOV AH, 09h
    LEA DX, Menu
    INT 21h

    MOV AH, 09h
    LEA DX, Elija
    INT 21h

    MOV AH, 01h
    INT 21h
    MOV opcion, AL

    CMP AL, '1'
    JE DECIMAL_BINARIO
    CMP AL, '2'
    JE BINARIO_DECIMAL
    CMP AL, '3'
    JE DECIMAL_HEXADECIMAL
    CMP AL, '4'
    JE HEXADECIMAL_DECIMAL
    CMP AL, '5'
    JE BINARIO_HEXADECIMAL
    CMP AL, '6'
    JE HEXADECIMAL_BINARIO
    CMP AL, '7'
    JE EXIT

    JMP MENU_PRINCIPAL

DECIMAL_BINARIO:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV numero_decimal, 0
    MOV longitud_bin, 0
    
LEER_DEC:
    MOV AH, 01h
    INT 21h
    
    CMP AL, 13
    JE CONVERTIR_A_BIN
    
    CMP AL, '0'
    JB LEER_DEC
    CMP AL, '9'
    JA LEER_DEC
    
    SUB AL, 30h
    MOV BL, AL
    
    MOV AX, numero_decimal
    MOV CX, 10
    MUL CX
    MOV temp, DX
    
    CMP DX, 0
    JNE LEER_DEC
    
    MOV BH, 0
    ADD AX, BX
    JC LEER_DEC
    
    MOV numero_decimal, AX
    JMP LEER_DEC

CONVERTIR_A_BIN:
    CMP numero_decimal, 0
    JE MOSTRAR_CERO
    
    MOV CX, 0
    MOV AX, numero_decimal
    
PROCESO_BINARIO:
    CMP AX, 0
    JE FIN_CONVERSION
    
    MOV DX, 0
    MOV BX, 2
    DIV BX
    
    ADD DL, 30h
    PUSH DX
    INC CX
    
    JMP PROCESO_BINARIO

FIN_CONVERSION:
    MOV longitud_bin, CL

    MOV AH, 09h
    LEA DX, MResultado
    INT 21h

MOSTRAR_RESULTADO:
    CMP CX, 0
    JE FIN_MOSTRAR
    
    POP DX
    MOV AH, 02h
    INT 21h
    
    DEC CX
    JMP MOSTRAR_RESULTADO

MOSTRAR_CERO:
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    MOV AH, 02h
    MOV DL, '0'
    INT 21h

FIN_MOSTRAR:
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    
    JMP MENU_PRINCIPAL

BINARIO_DECIMAL:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV SI, 0
    MOV resultado_decimal, 0
    
LEER_BIN_DEC:
    MOV AH, 01h
    INT 21h
    
    CMP AL, 13
    JE CONVERTIR_BIN_DEC
    
    CMP AL, '0'
    JB NUMERO_INVALIDO_BIN
    CMP AL, '1'
    JA NUMERO_INVALIDO_BIN
    
    MOV numero[SI], AL
    INC SI
    JMP LEER_BIN_DEC

NUMERO_INVALIDO_BIN:
    MOV AH, 09h
    LEA DX, error_msg
    INT 21h
    JMP MENU_PRINCIPAL

CONVERTIR_BIN_DEC:
    MOV numero[SI], '$'
    DEC SI
    
    MOV potencia, 1
    MOV resultado_decimal, 0

PROCESO_CONVERSION_BIN:
    CMP SI, 0
    JL FIN_CONVERSION_BIN
    
    MOV AL, numero[SI]
    SUB AL, '0'
    
    CMP AL, 1
    JNE SIGUIENTE_DIGITO_BIN
    
    MOV AX, potencia
    ADD resultado_decimal, AX
    
SIGUIENTE_DIGITO_BIN:
    MOV AX, potencia
    MOV BX, 2
    MUL BX
    MOV potencia, AX
    
    DEC SI
    JMP PROCESO_CONVERSION_BIN

FIN_CONVERSION_BIN:
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    MOV AX, resultado_decimal
    MOV BX, 10
    MOV CX, 0
    
CONVERTIR_A_ASCII_BIN:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE CONVERTIR_A_ASCII_BIN
    
MOSTRAR_DIGITOS_BIN:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP MOSTRAR_DIGITOS_BIN
    
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    
    JMP MENU_PRINCIPAL

DECIMAL_HEXADECIMAL:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV SI, 0
LEER_DEC_HEX:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE FIN_DEC_HEX
    MOV numero[SI], AL
    INC SI
    JMP LEER_DEC_HEX
FIN_DEC_HEX:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

HEXADECIMAL_DECIMAL:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV SI, 0
LEER_HEX:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE FIN_HEX
    MOV numero[SI], AL
    INC SI
    JMP LEER_HEX
FIN_HEX:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

BINARIO_HEXADECIMAL:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV SI, 0
LEER_BIN_HEX:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE FIN_BIN_HEX
    MOV numero[SI], AL
    INC SI
    JMP LEER_BIN_HEX
FIN_BIN_HEX:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

HEXADECIMAL_BINARIO:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV SI, 0
LEER_HEX_BIN:
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE FIN_HEX_BIN
    MOV numero[SI], AL
    INC SI
    JMP LEER_HEX_BIN
FIN_HEX_BIN:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

EXIT:
    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN