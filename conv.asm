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
    ; Aquí se agregará el código para la conversión de decimal a hexadecimal
    jmp main                      ; Regresar al menú principal

; Función: decimal_a_octal
decimal_a_octal:
    ; Aquí se agregará el código para la conversión de decimal a octal
    jmp main                      ; Regresar al menú principal

; Función: binario_a_decimal
binario_a_decimal:
    ; Aquí se agregará el código para la conversión de binario a decimal
    jmp main                      ; Regresar al menú principal

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
