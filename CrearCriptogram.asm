.globl Create_criptogram
.data
output_file: .asciiz "C:\\Users\\HP\\Desktop\\Assembler\\Mi desarrollo\\criptogram.txt"
buffer: .space 1 # Espacio para almacenar el carácter encontrado



.text
# $a0 es el puntero del archivo donde buscaremos la $a0, alfabeto
# $a1 es un parametro (C(x)) buscaremos la posicion $a1 en alfabeto y escribimos el valor que hay en esta posicion
# en criptogram.txt li $a1, x
Create_criptogram:
	la $a0, alfabeto
	# guardar valores en la pila
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $a0, 12($sp)
	sw $a1, 16($sp)
	sw $a2, 20($sp)
	li $t0, 0 # Inicializamos el contador o indice en 0
Loop:
	lb $t1, 0($a0) #cargar el byte actual en $t1
	beq $t1, $zero, End # Si alfabeto[i] == Null. saltamos a end
	
	beq $t0, $a1, Encontrado # si i = $a1, saltamos a encontrado
	addi $t0, $t0, 1 # aumentamos en 1 el indice o contador
	addi $a0, $a0, 1 # aumentamos en uno la posicion del vector de caracteres alfabeto
	j Loop
Encontrado:
	lb $t2, 0($a0)  # Cargar el carácter encontrado en $t2. movemos a $t2 el byte resultante al recorrer el vector de caracteres alfabeto
	sb $t2, buffer  # Guardar el carácter en el buffer. movemos a $t2 el C(x)
	li $v0, 13 # abrir archivo
	la $a0 output_file # direccion archivo
	li $a1, 9 # modo de apertura
	li $a2, 0 # Sin permisos especiales
	syscall
	move $a0, $v0  # Guardar descriptor del archivo en $a0
	
	li $v0, 15 # escritura
	la $a1, buffer # mensaje a escribir ($t2 = byte encontrado al recorrer el vector de caracteres alfabeto)
	li $a2, 1 # tamaño del mensaje
	syscall
	
	li $v0, 16 # cerramos el archivo
	syscall
End:
	# cargar valores de la pila
	lw   $a2, 20($sp)      
	lw   $a1, 16($sp)      
	lw   $a0, 12($sp)      
	lw   $t2, 8($sp)       
	lw   $t1, 4($sp)     
	lw   $t0, 0($sp)      
	addi $sp, $sp, 24     

	jr $ra
