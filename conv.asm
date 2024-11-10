.MODEL SMALL
.STACK 100h

.DATA
Intro DB 10,13,7,"CONVERSOR BASICO",10,13,7,"------------------",10,13,7,"$"
Menu DB 10,13,7,"1.DECIMAL->BINARIO",10,13,7,"2.BINARIO->DECIMAL",10,13,7
     DB "3.DECIMAL->HEXADECIMAL",10,13,7,"4.HEXADECIMAL->DECIMAL",10,13,7
     DB "5.BINARIO->HEXADECIMAL",10,13,7,"6.HEXADECIMAL->BINARIO",10,13,7
     DB "7.SALIR",10,13,7,"$"
opcion DB ?
Elija DB 10,13,7,"ELIJA SU OPCION : ","$"
Ingrese DB 10,13,7,"INGRESE EL NUMERO : ","$"
MResultado DB 10,13,7,"RESULTADO : ","$"
Salto DB 10,13,7,"$"
numero DB 16 DUP('$')  

;decimal binario variables
numero_decimal DW 0   
binario DB 16 DUP(0) 
longitud_bin DB 0    
temp DW 0           

;binario decimal variables
resultado_decimal DW 0    
error_msg DB 10,13,7,'ERROR: Numero binario invalido$'  
potencia DW 1            

;decimal hexadecimal variables
numero_hex DB 16 DUP('$')    
temp_decimal DW 0            

;hexadecimal decimal variables
hex_error_msg DB 10,13,7,'ERROR: Numero hexadecimal invalido$'
hex_resultado DW 0     
hex_temp DW 0         
hex_multiplicador DW 1 

;binario hexadecimal variables
bin_hex_temp DW 0      
bin_hex_msg DB 10,13,7,'ERROR: Numero binario invalido$'

;hexadecimal binario variables
hex_bin_error DB 10,13,7,'ERROR: Numero hexadecimal invalido$'
hex_bin_tabla DB '0000','0001','0010','0011','0100','0101','0110','0111'
              DB '1000','1001','1010','1011','1100','1101','1110','1111'
temp_hex DB 0

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
    JNE NOT_DECIMAL_BINARIO
    JMP DECIMAL_BINARIO

    NOT_DECIMAL_BINARIO:
    CMP AL, '2'
    JNE NOT_BINARIO_DECIMAL
    JMP BINARIO_DECIMAL

    NOT_BINARIO_DECIMAL:
    CMP AL, '3'
    JNE NOT_DECIMAL_HEXADECIMAL
    JMP DECIMAL_HEXADECIMAL

    NOT_DECIMAL_HEXADECIMAL:
    CMP AL, '4'
    JNE NOT_HEXADECIMAL_DECIMAL
    JMP HEXADECIMAL_DECIMAL

    NOT_HEXADECIMAL_DECIMAL:
    CMP AL, '5'
    JNE NOT_BINARIO_HEXADECIMAL
    JMP BINARIO_HEXADECIMAL

    NOT_BINARIO_HEXADECIMAL:
    CMP AL, '6'
    JNE NOT_HEXADECIMAL_BINARIO
    JMP HEXADECIMAL_BINARIO

    NOT_HEXADECIMAL_BINARIO:
    CMP AL, '7'
    JNE NOT_EXIT
    JMP EXIT

    NOT_EXIT:
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
    
    ; Inicializar variables
    MOV temp_decimal, 0
    
    ; Leer y convertir número decimal
LEER_DEC_HEX:
    MOV AH, 01h
    INT 21h
    
    CMP AL, 13              ; Comparar con Enter
    JE CONVERTIR_DEC_HEX    ; Cambiado
    
    ; Validar dígito (0-9)
    CMP AL, '0'
    JB LEER_DEC_HEX        ; Si es menor que '0', ignorar
    CMP AL, '9'
    JA LEER_DEC_HEX        ; Si es mayor que '9', ignorar
    
    ; Convertir ASCII a número
    SUB AL, 30h
    MOV BL, AL             ; Guardar dígito en BL
    
    ; Multiplicar número actual por 10 y sumar nuevo dígito
    MOV AX, temp_decimal
    MOV CX, 10
    MUL CX                  ; DX:AX = AX * 10
    
    ; Verificar overflow
    CMP DX, 0
    JNE LEER_DEC_HEX      ; Si hay overflow, ignorar dígito
    
    ; Sumar nuevo dígito
    MOV BH, 0
    ADD AX, BX
    JC LEER_DEC_HEX       ; Si hay carry, ignorar dígito
    
    MOV temp_decimal, AX
    JMP LEER_DEC_HEX

CONVERTIR_DEC_HEX:          ; Cambiado de CONVERTIR_A_HEX
    ; Mostrar mensaje de resultado
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    ; Preparar para conversión
    MOV AX, temp_decimal
    MOV CX, 0              ; Contador de dígitos

PROCESO_DEC_HEX:            ; Cambiado de PROCESO_HEX
    CMP AX, 0
    JE MOSTRAR_DEC_HEX      ; Cambiado
    
    MOV DX, 0
    MOV BX, 16
    DIV BX                 ; AX = cociente, DX = residuo
    
    ; Convertir residuo a carácter hexadecimal
    CMP DX, 9
    JA LETRA_DEC_HEX       ; Cambiado
    ADD DX, '0'           ; Si es 0-9, convertir a ASCII
    JMP GUARDAR_DIGITO_HEX  ; Cambiado

LETRA_DEC_HEX:              ; Cambiado
    SUB DX, 10            ; Convertir 10-15 a 0-5
    ADD DX, 'A'           ; Convertir a A-F

GUARDAR_DIGITO_HEX:         ; Cambiado
    PUSH DX               ; Guardar dígito en stack
    INC CX               ; Incrementar contador
    
    CMP AX, 0
    JNE PROCESO_DEC_HEX     ; Cambiado

MOSTRAR_DEC_HEX:            ; Cambiado
    ; Si el número era 0, mostrar 0
    CMP CX, 0
    JNE MOSTRAR_DIGITOS_DEC_HEX  ; Cambiado
    MOV AH, 02h
    MOV DL, '0'
    INT 21h
    JMP FIN_DEC_HEX         ; Cambiado

MOSTRAR_DIGITOS_DEC_HEX:    ; Cambiado
    POP DX               ; Obtener dígito del stack
    MOV AH, 02h
    MOV DL, DL          ; Mover el carácter a DL
    INT 21h
    LOOP MOSTRAR_DIGITOS_DEC_HEX  ; Cambiado

FIN_DEC_HEX:                ; Cambiado de FIN_HEX
    ; Mostrar salto de línea
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    
    JMP MENU_PRINCIPAL

HEXADECIMAL_DECIMAL:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Inicializar variables
    MOV SI, 0
    MOV hex_resultado, 0
    
LEER_HEX:
    MOV AH, 01h
    INT 21h
    
    CMP AL, 13          ; Comparar con Enter
    JE PROCESAR_HEX
    
    ; Validar el carácter hexadecimal
    CMP AL, '0'
    JB HEX_INVALIDO     ; Si es menor que '0'
    CMP AL, '9'
    JBE ES_NUMERO       ; Si está entre '0' y '9'
    
    ; Convertir a mayúsculas si es letra minúscula
    CMP AL, 'a'
    JB VERIFICAR_MAYUSCULA
    CMP AL, 'f'
    JA HEX_INVALIDO
    SUB AL, 32          ; Convertir a mayúscula
    JMP ES_LETRA
    
VERIFICAR_MAYUSCULA:
    CMP AL, 'A'
    JB HEX_INVALIDO
    CMP AL, 'F'
    JA HEX_INVALIDO
    
ES_LETRA:
    SUB AL, 'A'         ; Convertir letra a valor (A=10, B=11, etc.)
    ADD AL, 10
    JMP GUARDAR_DIGITO
    
ES_NUMERO:
    SUB AL, '0'         ; Convertir ASCII a valor numérico
    
GUARDAR_DIGITO:
    MOV numero[SI], AL  ; Guardar el valor convertido
    INC SI
    JMP LEER_HEX

HEX_INVALIDO:
    MOV AH, 09h
    LEA DX, hex_error_msg
    INT 21h
    JMP MENU_PRINCIPAL

PROCESAR_HEX:
    MOV numero[SI], '$'  ; Marcar fin de cadena
    DEC SI              ; Ajustar SI al último dígito
    
    ; Inicializar variables para la conversión
    MOV hex_multiplicador, 1
    MOV hex_resultado, 0
    
CONVERTIR_HEX:
    CMP SI, 0
    JL MOSTRAR_RESULTADO_HEX  ; Si terminamos de procesar todos los dígitos
    
    ; Obtener el valor del dígito actual
    MOV AL, numero[SI]
    MOV AH, 0           ; Limpiar AH para la multiplicación
    
    ; Multiplicar por el multiplicador actual
    MUL hex_multiplicador
    
    ; Sumar al resultado
    ADD hex_resultado, AX
    
    ; Multiplicar el multiplicador por 16
    MOV AX, hex_multiplicador
    MOV BX, 16
    MUL BX
    MOV hex_multiplicador, AX
    
    DEC SI
    JMP CONVERTIR_HEX

MOSTRAR_RESULTADO_HEX:
    ; Mostrar mensaje "RESULTADO: "
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    ; Convertir el resultado a ASCII y mostrarlo
    MOV AX, hex_resultado
    MOV BX, 10
    MOV CX, 0          ; Contador de dígitos
    
CONVERTIR_A_ASCII:
    MOV DX, 0
    DIV BX            ; Dividir por 10
    PUSH DX           ; Guardar el residuo
    INC CX            ; Incrementar contador
    CMP AX, 0
    JNE CONVERTIR_A_ASCII
    
MOSTRAR_DIGITOS:
    POP DX            ; Obtener dígito
    ADD DL, '0'       ; Convertir a ASCII
    MOV AH, 02h       ; Función para mostrar carácter
    INT 21h
    LOOP MOSTRAR_DIGITOS
    
    ; Mostrar salto de línea
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    
    JMP MENU_PRINCIPAL

BINARIO_HEXADECIMAL:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    ; Inicializar variables
    MOV SI, 0
    MOV bin_hex_temp, 0
    
LEER_BIN_HEX:
    MOV AH, 01h
    INT 21h
    
    CMP AL, 13          ; Comparar con Enter
    JE PROCESAR_BIN_HEX
    
    ; Validar que sea 0 o 1
    CMP AL, '0'
    JB BIN_HEX_ERROR
    CMP AL, '1'
    JA BIN_HEX_ERROR
    
    ; Guardar el dígito
    MOV numero[SI], AL
    INC SI
    JMP LEER_BIN_HEX

BIN_HEX_ERROR:
    MOV AH, 09h
    LEA DX, bin_hex_msg    ; Cambiado para usar el nuevo nombre
    INT 21h
    JMP MENU_PRINCIPAL

PROCESAR_BIN_HEX:
    MOV numero[SI], '$'  ; Marcar fin de cadena
    DEC SI              ; Ajustar SI al último dígito
    
    ; Inicializar variables para la conversión a decimal
    MOV bin_hex_temp, 0
    MOV CX, 1           ; Potencia de 2 inicial

CONVERTIR_A_DECIMAL:
    CMP SI, -1          ; Cambiado para procesar correctamente todos los dígitos
    JE CONVERTIR_A_HEX  ; Si ya procesamos todos los dígitos
    
    ; Obtener el dígito actual
    MOV AL, numero[SI]
    SUB AL, '0'         ; Convertir de ASCII a valor
    
    ; Si el dígito es 1, sumar la potencia actual
    CMP AL, 1
    JNE SIGUIENTE_BINARIO
    
    MOV AX, CX
    ADD bin_hex_temp, AX
    
SIGUIENTE_BINARIO:
    ; Multiplicar la potencia por 2
    MOV AX, CX
    SHL AX, 1           ; Multiplicar por 2 usando shift left
    MOV CX, AX
    
    DEC SI
    JMP CONVERTIR_A_DECIMAL

CONVERTIR_A_HEX:
    ; Mostrar mensaje "RESULTADO: "
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    ; Convertir el decimal a hexadecimal
    MOV AX, bin_hex_temp
    MOV CX, 0          ; Contador de dígitos hexadecimales
    
PROCESO_HEX:
    CMP AX, 0
    JE MOSTRAR_HEX
    
    MOV DX, 0
    MOV BX, 16
    DIV BX             ; Dividir por 16
    
    ; Convertir el residuo a carácter hexadecimal
    CMP DL, 9
    JA CONVERTIR_LETRA
    ADD DL, '0'        ; Si es 0-9
    JMP GUARDAR_HEX
    
CONVERTIR_LETRA:
    SUB DL, 10
    ADD DL, 'A'        ; Si es A-F
    
GUARDAR_HEX:
    PUSH DX            ; Guardar en la pila
    INC CX
    JMP PROCESO_HEX

MOSTRAR_HEX:
    ; Si el resultado es 0, mostrar 0
    CMP CX, 0
    JNE MOSTRAR_DIGITOS_HEX
    MOV AH, 02h
    MOV DL, '0'
    INT 21h
    JMP FIN_BIN_HEX_CONV

MOSTRAR_DIGITOS_HEX:
    POP DX
    MOV AH, 02h
    INT 21h
    LOOP MOSTRAR_DIGITOS_HEX

FIN_BIN_HEX_CONV:
    ; Mostrar salto de línea
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    
    JMP MENU_PRINCIPAL



; Modificar la función HEXADECIMAL_BINARIO
HEXADECIMAL_BINARIO:
    MOV AH, 09h
    LEA DX, Ingrese
    INT 21h
    
    MOV SI, 0
LEER_HEX_BIN:
    MOV AH, 01h
    INT 21h
    
    CMP AL, 13          ; Comparar con Enter
    JE PROCESAR_HEX_BIN
    
    ; Validar y convertir dígito hexadecimal
    CMP AL, '0'
    JB HEX_BIN_INVALIDO
    CMP AL, '9'
    JBE ES_NUM_HEX_BIN
    
    ; Convertir a mayúsculas si es letra minúscula
    CMP AL, 'a'
    JB VERIFICAR_MAY_HEX_BIN
    CMP AL, 'f'
    JA HEX_BIN_INVALIDO
    SUB AL, 32          ; Convertir a mayúscula
    JMP ES_LETRA_HEX_BIN
    
VERIFICAR_MAY_HEX_BIN:
    CMP AL, 'A'
    JB HEX_BIN_INVALIDO
    CMP AL, 'F'
    JA HEX_BIN_INVALIDO
    
ES_LETRA_HEX_BIN:
    SUB AL, 'A'         ; Convertir letra a valor (A=10, B=11, etc.)
    ADD AL, 10
    JMP GUARDAR_HEX_BIN
    
ES_NUM_HEX_BIN:
    SUB AL, '0'         ; Convertir ASCII a valor numérico
    
GUARDAR_HEX_BIN:
    MOV numero[SI], AL  ; Guardar el valor convertido
    INC SI
    JMP LEER_HEX_BIN

HEX_BIN_INVALIDO:
    MOV AH, 09h
    LEA DX, hex_bin_error
    INT 21h
    JMP MENU_PRINCIPAL

PROCESAR_HEX_BIN:
    MOV numero[SI], '$'  ; Marcar fin de cadena
    
    ; Mostrar mensaje "RESULTADO: "
    MOV AH, 09h
    LEA DX, MResultado
    INT 21h
    
    MOV CX, SI          ; Guardar cantidad de dígitos
    MOV SI, 0           ; Reiniciar SI para procesar desde el inicio

CONVERTIR_HEX_BIN:
    CMP SI, CX
    JE FIN_HEX_BIN
    
    ; Obtener valor del dígito actual
    MOV AL, numero[SI]
    MOV temp_hex, AL
    
    ; Calcular desplazamiento en la tabla
    MOV BX, 4           ; Cada patrón binario ocupa 4 bytes
    MUL BL             ; AX = AL * 4
    MOV BX, AX         ; BX = desplazamiento en la tabla
    
    ; Mostrar los 4 bits correspondientes
    MOV DI, 0          ; Contador para los 4 bits
MOSTRAR_BITS:
    MOV AL, hex_bin_tabla[BX + DI]
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    
    INC DI
    CMP DI, 4
    JNE MOSTRAR_BITS
    
    ; Agregar espacio entre grupos de 4 bits
    MOV DL, ' '
    MOV AH, 02h
    INT 21h
    
    INC SI
    JMP CONVERTIR_HEX_BIN

FIN_HEX_BIN:
    MOV AH, 09h
    LEA DX, Salto
    INT 21h
    JMP MENU_PRINCIPAL

EXIT:
    MOV AH, 4Ch
    INT 21h

MAIN ENDP
END MAIN