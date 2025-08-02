.globl Inicio_aditiva
.data
clave_user: .asciiz "\nIngresa la clave aditiva (numero entre 0 y 97): "
fallo: .asciiz "\nNumero fuera de rango, intentelo de nuevo\n"

.text

Inicio_aditiva:
	# Reserva en la pila
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
Solicitar_aditiva:
	la $a0, clave_user # mensaje para ingresar la clave aditiva
	li $v0, 4
	syscall
	li $v0, 5 # leer numero
	syscall # El numero es almacenado en $v0
	li $a1, 97 # Inicializacion del rango maximo del numero a ingresar 
	bgt $v0, $a1, Mensaje_error # si num ingresado > 97, saltar a mensaje error
	bgt $zero, $v0, Mensaje_error # si 0 > num_ingreado, saltar a mensaje error
	j Exit
Mensaje_error:
	la $a0, fallo
	li $v0, 4 # mostrar el mensaje de error
	syscall
	j Solicitar_aditiva # volver a pedir el numero
Exit:
	# carga de datos de la pila
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
