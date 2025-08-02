.globl Inverso
.text
Inverso:
    addi $sp, $sp, -28
    sw $ra, 0($sp)
    sw $a2, 4($sp)
    sw $t0, 8($sp)
    sw $t1, 12($sp)
    sw $t2, 16($sp)
    sw $t3, 20($sp)
    sw $t4, 24($sp)

    li $t0, 98 # Modulo = 98
    move $t1, $a2 # Movemos la clave aditiva a $t1
    li $t2, 1 # Inicializar inverso multiplicativo

Calculo_inverso:
    mul $t4, $t1, $t2 # Multiplicamos la clave aditiva por el inverso
    div $t4, $t0 # calculamos el residuo modulo 98
    mfhi $t4 # almacenamos este residuo en $t4
    beq $t4, 1, Fin # Si el residuo es 1, hemos encontrado el inverso
    addi $t2, $t2, 1 # sino, incrementamos el inverso en 1
    j Calculo_inverso

Fin: 
    move $v0, $t2 # Movemos a $v0 el inverso
    
    lw $t4, 24($sp)
    lw $t3, 20($sp)
    lw $t2, 16($sp)
    lw $t1, 12($sp)
    lw $t0, 8($sp)
    lw $a2, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 28

    jr $ra
