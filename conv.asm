.model small              ; Definir modelo de memoria pequeño para el programa
.stack 100h               ; Reservar espacio de 256 bytes para la pila

.data                     ; Sección de datos donde se almacenan las cadenas y variables
    msg_menu db 'MENU DE CONVERSION', 13, 10, '$'         ; Título del menú
    option1 db '1. Decimal a Binario', 13, 10, '$'        ; Opción 1 del menú
    option2 db '2. Decimal a Hexadecimal', 13, 10, '$'    ; Opción 2 del menú
    option3 db '3. Decimal a Octal', 13, 10, '$'          ; Opción 3 del menú
    option4 db '4. Binario a Decimal', 13, 10, '$'        ; Opción 4 del menú
    option5 db '5. Hexadecimal a Decimal', 13, 10, '$'    ; Opción 5 del menú
    option6 db '6. Octal a Decimal', 13, 10, '$'          ; Opción 6 del menú
    option7 db '7. Salir', 13, 10, '$'                    ; Opción para salir del programa
    prompt db 'Seleccione una opcion (1-7): $'            ; Mensaje para pedir entrada del usuario
    invalid db 'Opcion no valida, intente nuevamente', 13, 10, '$' ; Mensaje de error para opción inválida
    prompt_numero_decimal db 'Ingrese un numero decimal (0-9): $' ; Mensaje para pedir número
    binario_buffer db 8 dup(?)    ; Espacio para almacenar el resultado en binario

.code                    ; Sección de código donde empieza el programa
main proc                ; Etiqueta de inicio del procedimiento principal

    ; Inicialización del segmento de datos
    mov ax, @data        ; Cargar el inicio del segmento de datos en AX
    mov ds, ax           ; Mover AX a DS para usarlo como segmento de datos

    ; Mostrar el título del menú
    mov ah, 09h          ; Función 09h de la interrupción 21h para mostrar cadenas
    lea dx, msg_menu     ; Cargar la dirección de msg_menu en DX
    int 21h              ; Interrupción 21h para mostrar msg_menu en pantalla

    ; Mostrar cada opción del menú en pantalla usando la misma función
    lea dx, option1      ; Cargar la dirección de option1 en DX
    int 21h              ; Mostrar option1 en pantalla

    lea dx, option2      ; Cargar la dirección de option2 en DX
    int 21h              ; Mostrar option2 en pantalla

    lea dx, option3      ; Cargar la dirección de option3 en DX
    int 21h              ; Mostrar option3 en pantalla

    lea dx, option4      ; Cargar la dirección de option4 en DX
    int 21h              ; Mostrar option4 en pantalla

    lea dx, option5      ; Cargar la dirección de option5 en DX
    int 21h              ; Mostrar option5 en pantalla

    lea dx, option6      ; Cargar la dirección de option6 en DX
    int 21h              ; Mostrar option6 en pantalla

    lea dx, option7      ; Cargar la dirección de option7 en DX
    int 21h              ; Mostrar option7 en pantalla

    ; Solicitar opción del usuario
    lea dx, prompt       ; Cargar la dirección de prompt en DX
    int 21h              ; Mostrar prompt en pantalla

    ; Leer la opción del usuario
    mov ah, 01h          ; Función 01h de la interrupción 21h para leer un carácter
    int 21h              ; Interrupción 21h para obtener la entrada del usuario
    sub al, '0'          ; Convertir de ASCII a valor numérico restando '0'
    mov bl, al           ; Almacenar la opción en BL para comparaciones posteriores

    ; Validar la opción elegida y saltar a la función correspondiente
    cmp bl, 1            ; Comparar BL con 1
    je decimal_a_binario ; Saltar a decimal_a_binario si BL = 1

    cmp bl, 2            ; Comparar BL con 2
    je decimal_a_hexadecimal ; Saltar a decimal_a_hexadecimal si BL = 2

    cmp bl, 3            ; Comparar BL con 3
    je decimal_a_octal   ; Saltar a decimal_a_octal si BL = 3

    cmp bl, 4            ; Comparar BL con 4
    je binario_a_decimal ; Saltar a binario_a_decimal si BL = 4

    cmp bl, 5            ; Comparar BL con 5
    je hexadecimal_a_decimal ; Saltar a hexadecimal_a_decimal si BL = 5

    cmp bl, 6            ; Comparar BL con 6
    je octal_a_decimal   ; Saltar a octal_a_decimal si BL = 6

    cmp bl, 7            ; Comparar BL con 7
    je salir             ; Saltar a salir si BL = 7

    ; Si no se ingresó una opción válida, mostrar mensaje de error
    jmp opcion_invalida  ; Saltar a la etiqueta de opción inválida

; Función: decimal_a_binario
decimal_a_binario:
    ; Solicitar número decimal al usuario
    lea dx, prompt_numero_decimal ; Mensaje para pedir número
    mov ah, 09h                   ; Función para mostrar cadena
    int 21h                       ; Interrupción 21h para mostrar mensaje

    ; Leer el número decimal ingresado por el usuario
    mov ah, 01h                   ; Función para leer un carácter del teclado
    int 21h                       ; Leer número ingresado por el usuario
    sub al, '0'                   ; Convertir de ASCII a valor numérico
    mov bl, al                    ; Guardar el número en BL para la conversión

    ; Inicializar variables para la conversión
    mov cx, 0                     ; Contador de bits (índice)
    lea si, binario_buffer        ; Apuntar al buffer de binario donde se guardarán los restos

convertir_a_binario:
    mov al, bl                    ; Cargar el número en AL para dividir
    mov ah, 0                     ; Limpiar AH antes de la división
    mov dl, 2                     ; Divisor (base binaria)
    div dl                        ; Dividir AL entre 2, cociente en AL y residuo en AH

    add ah, '0'                   ; Convertir el residuo en ASCII ('0' o '1')
    mov [si], ah                  ; Guardar el bit en binario_buffer
    inc si                        ; Avanzar al siguiente espacio en el buffer
    inc cx                        ; Incrementar el contador de bits
    mov bl, al                    ; Actualizar BL con el cociente para el siguiente ciclo

    cmp bl, 0                     ; Revisar si el cociente es 0
    jne convertir_a_binario       ; Si no es 0, seguir dividiendo

    ; Mostrar el resultado en orden inverso (último bit a primero)
    dec si                        ; Retroceder una posición para imprimir el último bit guardado
imprimir_binario:
    mov dl, [si]                  ; Cargar el bit almacenado en binario_buffer
    mov ah, 02h                   ; Función para mostrar un carácter
    int 21h                       ; Mostrar el bit
    dec si                        ; Mover al bit anterior en el buffer
    loop imprimir_binario         ; Repetir hasta que todos los bits se impriman

    jmp main                      ; Regresar al menú principal

; Función: decimal_a_hexadecimal
decimal_a_hexadecimal:
    lea dx, prompt_numero_decimal ; Mensaje para pedir número
    mov ah, 09h                   ; Función para mostrar cadena
    int 21h                       ; Interrupción 21h para mostrar mensaje

    mov ah, 01h                   ; Función para leer un carácter del teclado
    int 21h                       ; Leer número ingresado por el usuario
    sub al, '0'                   ; Convertir de ASCII a valor numérico
    mov bl, al                    ; Guardar el número en BL para la conversión

    ; Inicializar variables para la conversión
    mov cx, 0                     ; Contador de dígitos (índice)
    lea si, binario_buffer        ; Apuntar al buffer de hexadecimal

convertir_a_hexadecimal:
    mov al, bl                    ; Cargar el número en AL
    mov ah, 0                     ; Limpiar AH antes de la división
    mov dl, 16                    ; Divisor (base hexadecimal)
    div dl                        ; Dividir AL entre 16, cociente en AL y residuo en AH

    ; Convertir el residuo a ASCII
    cmp ah, 10                    ; Verificar si el residuo es mayor o igual a 10
    jl  almacenar_hex             ; Si es menor, almacenar directamente
    add ah, 'A' - 10              ; Convertir 10-15 a 'A'-'F'
    jmp almacenar

almacenar_hex:
    add ah, '0'                   ; Convertir el residuo en ASCII ('0'-'9')

almacenar:
    mov [si], ah                  ; Guardar el dígito en el buffer
    inc si                        ; Avanzar al siguiente espacio en el buffer
    inc cx                        ; Incrementar el contador de dígitos
    mov bl, al                    ; Actualizar BL con el cociente para el siguiente ciclo

    cmp bl, 0                     ; Revisar si el cociente es 0
    jne convertir_a_hexadecimal    ; Si no es 0, seguir dividiendo

    ; Mostrar el resultado en orden inverso
    dec si                        ; Retroceder una posición para imprimir el último dígito guardado
imprimir_hexadecimal:
    mov dl, [si]                  ; Cargar el dígito almacenado en el buffer
    mov ah, 02h                   ; Función para mostrar un carácter
    int 21h                       ; Mostrar el dígito
    dec si                        ; Mover al dígito anterior en el buffer
    loop imprimir_hexadecimal      ; Repetir hasta que todos los dígitos se impriman

    jmp main                      ; Regresar al menú principal                  ; Regresar al menú principal

; Función: decimal_a_octal
; Función: decimal_a_octal
decimal_a_octal:
    lea dx, prompt_numero_decimal ; Mensaje para pedir número
    mov ah, 09h                   ; Función para mostrar cadena
    int 21h                       ; Interrupción 21h para mostrar mensaje

    mov ah, 01h                   ; Función para leer un carácter del teclado
    int 21h                       ; Leer número ingresado por el usuario
    sub al, '0'                   ; Convertir de ASCII a valor numérico
    mov bl, al                    ; Guardar el número en BL para la conversión

    ; Inicializar variables para la conversión
    mov cx, 0                     ; Contador de dígitos (índice)
    lea si, binario_buffer        ; Apuntar al buffer de octal

convertir_a_octal:
    mov al, bl                    ; Cargar el número en AL
    mov ah, 0                     ; Limpiar AH antes de la división
    mov dl, 8                     ; Divisor (base octal)
    div dl                        ; Dividir AL entre 8, cociente en AL y residuo en AH

    add ah, '0'                   ; Convertir el residuo en ASCII ('0'-'7')
    mov [si], ah                  ; Guardar el dígito en el buffer
    inc si                        ; Avanzar al siguiente espacio en el buffer
    inc cx                        ; Incrementar el contador de dígitos
    mov bl, al                    ; Actualizar BL con el cociente para el siguiente ciclo

    cmp bl, 0                     ; Revisar si el cociente es 0
    jne convertir_a_octal         ; Si no es 0, seguir dividiendo

    ; Mostrar el resultado en orden inverso
    dec si                        ; Retroceder una posición para imprimir el último dígito guardado
imprimir_octal:
    mov dl, [si]                  ; Cargar el dígito almacenado en el buffer
    mov ah, 02h                   ; Función para mostrar un carácter
    int 21h                       ; Mostrar el dígito
    dec si                        ; Mover al dígito anterior en el buffer
    loop imprimir_octal           ; Repetir hasta que todos los dígitos se impriman

    jmp main                      ; Regresar al menú principal
; Función: binario_a_decimal
binario_a_decimal:
    lea dx, prompt_numero_decimal ; Mensaje para pedir el número binario
    mov ah, 09h                   ; Función para mostrar cadena
    int 21h                       ; Interrupción 21h para mostrar mensaje

    ; Inicializar variables
    xor di, di                    ; Limpiar DI (acumulador decimal)
    mov cx, 0                     ; Inicializar contador de dígitos
    lea si, binario_buffer        ; Apuntar al buffer donde se almacenará el binario

leer_binario:
    mov ah, 01h                   ; Función para leer un carácter del teclado
    int 21h                       ; Leer número ingresado por el usuario
    cmp al, 13                    ; Comparar si se presionó Enter (código ASCII 13)
    je fin_leer_binario           ; Si es Enter, ir a fin

    cmp al, '0'                   ; Comparar si el carácter es '0'
    je agregar_cero               ; Si es '0', ir a agregar_cero
    cmp al, '1'                   ; Comparar si el carácter es '1'
    je agregar_uno                ; Si es '1', ir a agregar_uno

    ; Si se ingresa un carácter diferente, salir del bucle
    jmp fin_leer_binario

agregar_cero:
    ; Si es '0', solo incrementar el contador
    inc cx
    jmp leer_binario

agregar_uno:
    ; Si es '1', calcular el valor decimal
    shl di, 1                     ; Multiplicar el acumulador por 2
    inc di                        ; Sumar 1 al acumulador
    inc cx                        ; Incrementar el contador
    jmp leer_binario

fin_leer_binario:
    ; Mostrar el resultado en decimal
    ; Convertir el valor en DI a ASCII y mostrarlo
    mov ax, di                    ; Mover el valor decimal a AX
    call imprimir_decimal          ; Llamar a la función para imprimir el número decimal

    jmp main                      ; Regresar al menú principal            ; Regresar al menú principal

; Función para imprimir el número decimal en AX
imprimir_decimal:
    ; Convertir el número en AX a una cadena y mostrarla
    xor cx, cx                    ; Limpiar CX (contador de dígitos)
    mov bx, 10                    ; Divisor para conversión a decimal

convertir_decimal:
    xor dx, dx                    ; Limpiar DX antes de la división
    div bx                        ; Dividir AX entre 10
    push dx                       ; Almacenar el residuo en la pila
    inc cx                        ; Incrementar el contador de dígitos
    test ax, ax                   ; Comprobar si AX es 0
    jnz convertir_decimal          ; Si no es 0, seguir dividiendo

imprimir_resultado_decimal:
    pop dx                        ; Recuperar el dígito de la pila
    add dl, '0'                   ; Convertir el dígito a ASCII
    mov ah, 02h                   ; Función para mostrar un carácter
    int 21h                       ; Mostrar el dígito
    loop imprimir_resultado_decimal ; Repetir hasta que se muestren todos los dígitos

    ret                           ; Regresar de la función
; Función: hexadecimal_a_decimal
hexadecimal_a_decimal:
    ; Aquí se agregará el código para la conversión de hexadecimal a decimal
    jmp main                      ; Regresar al menú principal

; Función: octal_a_decimal
octal_a_decimal:
    ; Aquí se agregará el código para la conversión de octal a decimal
    jmp main                      ; Regresar al menú principal

; Función: opcion_invalida
opcion_invalida:
    ; Mostrar mensaje de error cuando la opción ingresada es inválida
    lea dx, invalid      ; Cargar la dirección de invalid en DX
    mov ah, 09h          ; Función 09h para mostrar la cadena de error
    int 21h              ; Interrupción 21h para mostrar invalid en pantalla
    jmp main             ; Volver al inicio para pedir otra opción

; Función: salir
salir:
    ; Terminar el programa
    mov ah, 4Ch          ; Función 4Ch de la interrupción 21h para salir del programa
    int 21h              ; Interrupción 21h para salir con el código de retorno 0

main endp                ; Fin del procedimiento principal
end main                 ; Fin del programa
