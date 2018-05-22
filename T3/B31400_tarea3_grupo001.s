# Universidad de Costa Rica 															#
# Facultad de Ingenieria. Escuela de Ingenieria Electrica								#
# Estructuras de Computadoras I, IE0321. Prof. Roberto Rodriguez R.						#
# Tarea 2																				#
# Moises Campos Zepeda. B31400															#
# moiso.camposcr@gmail.com																#
#***************************************************************************************#
#***************************************************************************************#
#	Programa que determina la hipotenusa, angulo, y el seno tanto como el coseno de 
# dicho angulo
#***************************************************************************************#
#***************************************************************************************# 
# $f2: a, el cateto adyacente
#***************************************************************************************#
#***************************************************************************************#



.data
#frrases, pendiente input| eld
	intro:		.asciiz "Programa para sacar elementos de un triangulo rectangulo: \n"
	catAdj:		.asciiz "Escriba un valor para el primer cateto: "
	catOp:		.asciiz "Escriba un valor para el segundo cateto: " 
	Enter: 		.asciiz "\n"
	ZeroIng:	.asciiz "\nUno de los catetos es cero\n"
	Finn: 		.asciiz "\nSe procede a terminar el programa..."
	hip_mssg:	.asciiz "\nEl valor de la hipotenusa es: "
.text
.globl main						#para el ensamblador
	main:
	
	li.s $f1, 0.0        			# $f1 =0
	
	la $a0, intro				#texto introductorio
	li $v0, 4 
	syscall

	la $a0, catAdj				#texto  para primer cateto a
	li $v0, 4 
	syscall
	
	li $v0, 6					#codigo para float
	syscall
	mov.s $f2, $f0				#guardamos el float a
	c.eq.s $f2, $f1				#comparamos el cateto con cero
	bc1t zero
	
	la $a0, catOp				#texto par el segundo cateto b
	li $v0, 4 
	syscall
	li $v0, 6					#codigo para float
	syscall
	mov.s $f3, $f0				#guardamos el float b
	c.eq.s $f3, $f1				#comparamos el cateto con cero
	bc1t zero
	
	la $a0, Enter				# imprime texto
	li $v0,4 
	syscall
	
	jal hip
	
#imprimir prueba
	la $a0, hip_mssg				# imprime texto
	li $v0,4 
	syscall
	
	mov.s $f12, $f8
	li $v0, 2 
 	syscall
	
	j fin
	
hip:
	
	addiu $sp, $sp, -12
    sw $ra, 0($sp)
	mul.s $f4, $f2, $f2			# a**2 
	mul.s $f7, $f3, $f3			# b**2
	add.s $f7, $f4, $f7			# $f5  = a**2 + b***2  
	jal raiz
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 12
	jr $ra

#***************************************************************************************#
#obtiene la raiz aproximada por el metodo newton	
#***************************************************************************************#
raiz:							#$f7 = n
	addiu $sp, $sp, -8			# guardar en $sp 
    sw $s0, 0($sp)				
    sw $s1, 4($sp)
	mov.s $f8, $f7				# x = n
	and $s0, $0, $s0			#$s0 = i = 0	
	addi $s1, $0, 20			#$s1: el limite = 20
	li.s $f6, 2.0				#cargamos un 2 float
for_raiz:	
	bge $s0, $s1, raiz_return 	# sigue mientras i < 20
	div.s $f9, $f7, $f8 			# $f9 =  n / x
	add.s $f9, $f8, $f9			# $f9 =  x + n / x
	div.s $f8, $f9, $f6			# x = (x + n / x) / 2
	addi $s0, $s0, 1
	j for_raiz
raiz_return:
	#se devuelve el resultado en f8
	lw $s0, 0($sp)
    lw $s1, 4($sp)
    addiu $sp, $sp, 8
jr $ra
	
	
fin:
	la $a0, Finn				# imprime texto
	li $v0,4 
	syscall	
	li $v0, 10        			# Syscall para salir.
	syscall	
	
zero:
	la $a0, ZeroIng				# imprime texto
	li $v0,4 
	syscall	
	j fin	