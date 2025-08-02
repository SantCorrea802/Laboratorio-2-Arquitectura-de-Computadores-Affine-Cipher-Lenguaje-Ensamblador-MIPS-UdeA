.globl Create_decoded
.data
decrypted_file: .asciiz "C:\\Users\\HP\\Desktop\\Assembler\\Mi desarrollo\\decoded.txt"
alfabeto: .asciiz "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\t\n\r !\"#$%&'()*+,-./0123456789:;<=>?@[\\]^_`{|}~"

decrypted_buffer: .space 1 # Espacio para almacenar el carácter encontrado

.text
# $a1 es un parámetro (C(x)), que es la posición en el alfabeto
# Se busca el carácter en la posición $a1 del alfabeto y se escribe en decoded.txt
Create_decoded:
    addi $sp, $sp, -28 # Guardar registros en el stack
    sw $ra, 24($sp) # Guardar $ra
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $a0, 12($sp)
    sw $a1, 16($sp)
    sw $a2, 20($sp)

    la $t0, alfabeto # Puntero a la cadena alfabeto
    li $t1, 0 # Inicializamos el contador de índice en 0

Loop_decrypted:
    lb $t2, 0($t0) # Cargar el byte actual de alfabeto en $t2
    beq $t2, $zero, End_decrypted # Si es el fin de la cadena (byte 0), salir
    beq $t1, $a1, Encontrado_decrypted # Si el índice coincide con $a1, encontramos el carácter
    addi $t1, $t1, 1 # Aumentamos el índice
    addi $t0, $t0, 1 # Avanzamos en la cadena alfabeto
    j Loop_decrypted

Encontrado_decrypted:
    lb $t2, 0($t0) # Cargar el carácter encontrado en $t2
    sb $t2, decrypted_buffer # Guardar el carácter en el buffer
    
    li $v0, 13 # Syscall para abrir el archivo
    la $a0, decrypted_file # Dirección del archivo
    li $a1, 9 # Modo de apertura (9 = agregar)
    li $a2, 0 # Sin permisos especiales
    syscall
    move $a0, $v0 # Guardar descriptor del archivo en $a0
    
    li $v0, 15 # Syscall para escribir en el archivo
    la $a1, decrypted_buffer # Cargar el mensaje a escribir (carácter en buffer)
    li $a2, 1 # Escribir solo un byte (el carácter)
    syscall

    li $v0, 16 # Syscall para cerrar el archivo
    syscall

End_decrypted:
    lw $a2, 20($sp)
    lw $a1, 16($sp)
    lw $a0, 12($sp)
    lw $t2, 8($sp)
    lw $t1, 4($sp)
    lw $t0, 0($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28 

    jr $ra
