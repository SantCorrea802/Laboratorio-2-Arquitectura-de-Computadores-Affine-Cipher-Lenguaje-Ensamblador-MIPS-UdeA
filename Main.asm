.data
codificado: .asciiz "C:\\Users\\HP\\Desktop\\Assembler\\Mi desarrollo\\criptogram.txt"
.align 2
codificado_buffer: .space 1024
.align 2
.text

Ejecutar_encode:
	addi $sp, $sp, -36
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $t0, 24($sp)
	sw $t1, 28($sp)
	sw $ra, 32($sp)
	
	# Abrir archivo en modo lectura
    	la   $a0, input_file # Nombre del archivo
    	li   $v0, 13 # Syscall para abrir archivo
    	li   $a1, 0 # Modo lectura (read-only)
    	syscall

    	move $s0, $v0 # Guardar descriptor del archivo en $s0

    	# Inicialización del puntero de lectura
    	la   $s1, input_buffer # Puntero al buffer donde se cargará el contenido
    	
    	jal Verify_coprimo
	move $t4, $v0 # Movemos a $t1, el valor que hay en $v0 (la clave multiplicativa)
	
	jal Inicio_aditiva
	move $t2, $v0 # Movemos a $t2, el valor que hay en $v0 (la clave aditiva)

Read_loop:
    	# Leer un carácter del archivo
    	li   $v0, 14 # encode Syscall para leer del archivo
    	move $a0, $s0 # Descriptor del archivo
    	addi $a1, $s1, 0 # Puntero al buffer (almacenamos en $s1)
    	li   $a2, 1 # Leer un byte (carácter)
    	syscall

   	# Verificar si alcanzamos el final del archivo
    	beq  $v0, $zero, Close_file
    	
    	# Guardar el carácter leido en $a1 para usarlo en find_char
    	lbu  $a1, 0($s1) # Cargar el byte leído
    
       	# alfabeto en $a0
    	la   $a0, alfabeto
    	
    	# Llamada a la función find_char
    	jal  Find_char

    	move $a1, $v0 # Movemos a $a1, el valor que hay en $v0 (la posicion del caracter)
	 
	move $a2, $t4 # Guardamos la clave multiplicativa en $a2 para pasarla como parametro
	move $a3, $t2 # guardamos la clave aditiva en $a3 para pasarla como parametro
	
	# C(x) = (a*x + b) mod 98
	addi $t1, $zero, 98 # inicializamos el modulo en 98
	mul $t0, $a1, $a2 # a*x
	add $t0, $t0, $a3 # a*x + b
	div $t0, $t1 # ($a1*$a0 + $a2) mod $t1
	mfhi $a1 # Guardamos el resultado de la operacion anterior en $a1
	
	jal Create_criptogram # Creamos el archivo criptograma.txt
	
	# Volver al siguiente carácter
    	j    Read_loop
 	
Close_file:
    	# Cerrar el archivo
    	li   $v0, 16 # Syscall para cerrar archivo
    	move $a0, $s0 # Descriptor del archivo
    	syscall

    	lw $ra, 32($sp)
	lw $t1, 28($sp)
	lw $t0, 24($sp)
	lw $s1, 20($sp)
	lw $s0, 16($sp)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 36

Ejecutar_decode:
	la $a0, codificado # Direccion del archivo a abrir
	li $v0, 13
	li $a1, 0 # modo lectura
	syscall
	move $s0, $v0 # Movemos el descriptor a $s0
	
	la $s1, codificado_buffer # Puntero al buffer donde se cargará el contenido
	
Loop_lectura:
	# Leer un caracter del archivo
	li $v0, 14
	move $a0, $s0 # Pasamos el descriptor a $a0
	addi $a1, $s1, 0 # Puntero al buffer
	li $a2, 1 # Tamaño (leer unicamente un byte)
	syscall
	
	beq $v0, $zero, Close # Verificar si llegamos al final del archivo
	
	# Guardar el carácter leido en $a1 para usarlo en find_cahr
    	lbu  $a1, 0($s1) # Cargar el byte leído
    	
    	# Alfabeto en $a0
    	la   $a0, alfabeto
    	
    	jal Find_char
    	
    	move $a1, $v0 # Movemos a $a1, el valor que hay en $v0 (la posicion del caracter)
    	# $a2 y $a3 deberian tener almacenado el valor de la clave multiplicativa y aditiva correspondientemente 
    	
    	move $a2, $t4
    	move $a3, $t2
    	
    	addi $t1, $zero, 98 # inicializamos el modulo en 98
    	
    	jal Inverso
    	# Retorna $v0 = a^(-1)
    	
    	# P(x) = (a^(-1)*(C(x)-b)) mod 98
    	sub $t0, $a1, $a3 # C(x) - b
    	bltz $t0, Negativo # Si (C(x) - b) < 0 debemos sumarle el modulo (98)
    	
Multiplicacion_decode:
    	mul $t0, $t0, $v0 # a^(-1)*(C(x)-b)
    	div $t0, $t1 # (a^(-1)*(C(x)-b)) mod 98
    	mfhi $a1 # Guardamos la anterior operacion en $a1, para pasarla como parametro a Create_decoded:
    	
    	jal Create_decoded # Creamos el archivo decoded.txt pasando como parametro $a1 que será el caracter a imprimir
    	
    	j Loop_lectura # repetimos el bucle

Negativo:
	add $t0, $t0, $t1
	j Multiplicacion_decode
	
Close:
	# Cerrar el archivo
    	li   $v0, 16 # Syscall para cerrar archivo
    	move $a0, $s0 # Descriptor del archivo
    	syscall
    
    	li $v0, 10
    	syscall
