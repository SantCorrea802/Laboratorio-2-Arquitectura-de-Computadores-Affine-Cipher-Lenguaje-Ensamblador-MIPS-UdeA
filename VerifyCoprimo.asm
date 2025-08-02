.globl num_user, error, Verify_coprimo
.data
num_user: .asciiz "\nIngresa la clave multiplicativa: " # Mensaje para pedir numero al usuario
error: .asciiz "\nEl numero ingresado no es coprimo con 98, intentelo nuevamente.\n"

.text

Verify_coprimo: 
	# Guardar los valores en la pila
	addi $sp, $sp, -28
	sw $a0, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	
	la $a0, num_user # Guardamos en $a0 el mensaje
	li $v0, 4 # 4 en $v0 para imprimir una cadena (el mensaje)
	syscall # llamado de sistema
	li $v0,5 # 5 en $v0 para leer un entero
	syscall # llamado de sistema
	move $t0, $v0 # copiamos el valor de $v0 (numero ingresado por el usuario) y lo pegamos en $t0 para hacer las operaciones
	move $t3, $v0 # Guardamos el valor del numero en $t3 para retornarlo en caso de ser coprimo con 98
Coprimo:
	addi $s0, $zero, 98 # Guardamos en $s0 el valor 98, ya que el numero ingresado debe ser coprimo a este
	addi $s1, $zero, -1 # Inicializamos en 1 el residuo entre el num ingresado y 98
Find_mcd:
	beq $s0, $zero, End_While # Si $s0 (al inicio 98) es igual a cero, salimos del ciclo while
	div $t0, $s0 # num ingresado % $s0 (al inicio 98)
	mfhi $t1 # guardamos en $t1 el residuo de la anterior operacion
	add $t0, $zero, $s0 # Guardamos en $t0 (num ingresado) el valor que hay en $s0 (al inicio será 98). Este guardara el MCD
	add $s0, $zero, $t1 # Guardamos en $s0 (al inicio es 98) el valor que hay en $t1 (el residuo entre num ingresado y 98)
	j Find_mcd	
End_While:
	li $t2, 1 # Guardamos en $t1 el valor de 1, para hacer la comparacion de MCD
	beq $t0, $t2, Es_coprimo #(MCD == 1) si es true, saltamos a es_coprimo, sino continuamos
	la $a0, error # Mensaje advirtiendo no es coprimo
	li $v0, 4
	syscall
	j Verify_coprimo # Volver a solicitar el numero
Es_coprimo:
	move $v0, $t3 # Llevamos el valor de $t3 (numero coprimo con 98) a $v0 para poder retornarlo
	
	# Cargar los valores de la pila
	lw   $s1, 24($sp)     
	lw   $s0, 20($sp)    
	lw   $t3, 16($sp)     
	lw   $t2, 12($sp)     
	lw   $t1, 8($sp)        
	lw   $t0, 4($sp)        
	lw   $a0, 0($sp)        
	addi $sp, $sp, 28    

	
	jr $ra
