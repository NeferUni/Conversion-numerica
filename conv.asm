TITLE CONVERSOR

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
numero db 16 dup('$')  ; Aumenté el tamaño del buffer para números más largos

;decimal binario variables-------------------------------------

numero_decimal dw 0   ; Para almacenar el número decimal convertido
binario db 16 dup(0) ; Para almacenar el resultado binario
longitud_bin db 0    ; Para almacenar la longitud del número binario


.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

MENU_PRINCIPAL:
    ; Mostrar mensaje de introducción
    MOV AH, 09h
    LEA DX, Intro
    INT 21h

    ; Mostrar menú de opciones
    MOV AH, 09h
    LEA DX, Menu
    INT 21h

    ; Solicitar opción
    MOV AH, 09h
    LEA DX, Elija
    INT 21h

    ; Leer opción ingresada
    MOV AH, 01h
    INT 21h
    MOV opcion, AL

    ; Seleccionar la función
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
    ; Mostrar mensaje para ingresar número
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Leer número decimal y convertirlo
    MOV SI, 0
    MOV numero_decimal, 0    ; Inicializar el número decimal
    
LEER_DEC:
    MOV AH, 01h
    INT 21h
    CMP AL, 13              ; Comparar con Enter
    JE CONVERTIR_A_BIN
    
    ; Convertir ASCII a número
    SUB AL, 30h             ; Restar 30h para convertir de ASCII a número
    MOV BL, AL              ; Guardar el dígito en BL
    
    ; Multiplicar número_decimal actual por 10
    MOV AX, numero_decimal
    MOV CX, 10
    MUL CX                  ; DX:AX = AX * CX
    
    ; Agregar el nuevo dígito
    ADD AL, BL
    MOV numero_decimal, AX
    
    JMP LEER_DEC

CONVERTIR_A_BIN:
    ; Preparar registros para la conversión
    MOV AX, numero_decimal  ; Número a convertir
    MOV SI, 0              ; Índice para binario
    MOV longitud_bin, 0    ; Inicializar longitud

PROCESO_BINARIO:
    CMP AX, 0              ; Verificar si el número es 0
    JE MOSTRAR_BINARIO
    
    MOV DX, 0              ; Limpiar DX para división
    MOV CX, 2              ; Divisor (2 para binario)
    DIV CX                 ; Dividir AX por 2, cociente en AX, residuo en DX
    
    ; Guardar el residuo (0 o 1) en el arreglo
    ADD DL, 30h            ; Convertir a ASCII
    MOV binario[SI], DL    ; Guardar dígito
    INC SI
    INC longitud_bin
    
    JMP PROCESO_BINARIO

MOSTRAR_BINARIO:
    ; Mostrar mensaje de resultado
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    ; Preparar para mostrar el binario
    MOV CL, longitud_bin
    MOV CH, 0              ; Limpiar CH para usar CX
    MOV SI, CX             ; SI apunta al último dígito
    DEC SI                 ; Ajustar para índice base 0

MOSTRAR_DIGITOS:
    CMP SI, 0              ; Verificar si quedan dígitos
    JL FIN_MOSTRAR
    
    ; Mostrar un dígito
    MOV DL, binario[SI]
    MOV AH, 02h
    INT 21h
    
    DEC SI                 ; Mover al siguiente dígito
    JMP MOSTRAR_DIGITOS

FIN_MOSTRAR:
    ; Mostrar salto de línea
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    
    JMP MENU_PRINCIPAL

BINARIO_DECIMAL:
    ; Mostrar mensaje para ingresar número
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Leer número binario
    MOV SI, 0
LEER_BIN:
    MOV AH, 01h
    INT 21h
    CMP AL, 13  ; Comparar con Enter
    JE FIN_BIN
    MOV numero[SI], AL
    INC SI
    JMP LEER_BIN
FIN_BIN:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

DECIMAL_HEXADECIMAL:
    ; Mostrar mensaje para ingresar número
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Leer número decimal
    MOV SI, 0
LEER_DEC_HEX:
    MOV AH, 01h
    INT 21h
    CMP AL, 13  ; Comparar con Enter
    JE FIN_DEC_HEX
    MOV numero[SI], AL
    INC SI
    JMP LEER_DEC_HEX
FIN_DEC_HEX:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

HEXADECIMAL_DECIMAL:
    ; Mostrar mensaje para ingresar número
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Leer número hexadecimal
    MOV SI, 0
LEER_HEX:
    MOV AH, 01h
    INT 21h
    CMP AL, 13  ; Comparar con Enter
    JE FIN_HEX
    MOV numero[SI], AL
    INC SI
    JMP LEER_HEX
FIN_HEX:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

BINARIO_HEXADECIMAL:
    ; Mostrar mensaje para ingresar número
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Leer número binario
    MOV SI, 0
LEER_BIN_HEX:
    MOV AH, 01h
    INT 21h
    CMP AL, 13  ; Comparar con Enter
    JE FIN_BIN_HEX
    MOV numero[SI], AL
    INC SI
    JMP LEER_BIN_HEX
FIN_BIN_HEX:
    MOV numero[SI], '$'
    JMP MENU_PRINCIPAL

HEXADECIMAL_BINARIO:
    ; Mostrar mensaje para ingresar número
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Leer número hexadecimal
    MOV SI, 0
LEER_HEX_BIN:
    MOV AH, 01h
    INT 21h
    CMP AL, 13  ; Comparar con Enter
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