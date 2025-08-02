.globl	input_file, input_buffer, Find_char, alfabeto
.data
# 98 caracteres imprimibles (95 letras, numeros y simbolos + 3 caracteres de control)
alfabeto: .asciiz "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\t\n\r !\"#$%&'()*+,-./0123456789:;<=>?@[\\]^_`{|}~"

input_file:	.asciiz "C:\\Users\\HP\\Desktop\\Assembler\\Mi desarrollo\\input.txt"
.align 2
input_buffer:	.space 1024
.align 2
mensaje: .asciiz "\nLa letra ingresada está en la posicion: "

.text


##########
# Funcion find_char
# Utilidad: Busca en un String terminadoe en NULL la primera
# Ocurrncioa de un caracter. Retornando su posicion dentro del String

# Entrada: $a0 puntero al string terminado en NULL
#	   $a1 caracter a buscar
# Salida: $v0 posicion del caracter en el string (primera posicion es 0)
#	  si no esta presente retorna -1
# Todo registro usado en la implementacion conservara su valor
# Con excepcion de $v0
Find_char:
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $t1, 4($sp)
	sw $t0, 8($sp)

	addi $v0,$zero, -1	# Inicializacion de $v0 = -1
	add $t0, $zero, $zero	# Inicializacion indice de barrido
Loop1:	lbu $t1, 0($a0)		# $t1 = String[i]
	beq $t1, $zero, End_FC	# String[i] = NULL?
	bne $t1, $a1, Next_item # El caracter a buscar NO es el mismo que el caracter del string donde estamos ubicados?
	move $v0, $t0		# Copia indice de barrido en resultado
	j End_FC
Next_item:
	addi $a0, $a0, 1	# puntero a String[i + 1]
	addi $t0, $t0, 1	# Actualizar indice de barrido
	j Loop1
End_FC:	
	
	
	lw $t0, 8($sp)
	lw $t1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 12 

Exit_FC: jr $ra
