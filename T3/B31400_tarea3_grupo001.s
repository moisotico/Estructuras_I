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
# $f2: a, el primer cateto; $f3: b, el segundo cateto; $f4: d, el cateto mayor; 
# $f8: hip, la hipotenusa ; $f11: theta, el angulo; $f17: e, el cateto menor;
# $f19: coseno(theta) ; $f18: seno(theta).  
#***************************************************************************************#
#***************************************************************************************#



.data
#frases, pendiente una para angulo
	intro:		.asciiz "\nTarea 3: Programa para sacar elementos de un triangulo rectangulo. \n"
	intro2:		.asciiz "#***************************************************************************************#"
	intro3:		.asciiz "Elaborado por Moises Campos Zepeda - B31400\n->>>(Para salir ingrese 0 en alguno de los catetos) <<<-\n"
	catAdj:		.asciiz "\nEscriba un valor para el primer cateto: "
	catOp:		.asciiz "Escriba un valor para el segundo cateto: " 
	Enter: 		.asciiz "\n"
	ZeroIng:	.asciiz "\nUno de los catetos es cero\n"
	Finn: 		.asciiz "\nSe procede a terminar el programa..."
	hip_mssg:	.asciiz "\nEl valor de la hipotenusa es: "
	sin_mssg:	.asciiz "\nEl seno del triangulo vale: "
	cos_mssg:	.asciiz "\nEl coseno del triangulo vale: "
	ang_mssg: 	.asciiz "\nEl angulo del cateto mayor con la hipotenusa es: "
	ang_mssg2:	.asciiz " radianes"
	reset:		.asciiz "\nReiniciando el programa...\n \n"
.text
.globl main						#para el ensamblador
	
#***************************************************************************************#
#main: Pide al usuario los catetos, llama las demas subrutinas, e imprime resultados
#***************************************************************************************#	
main:
	li.s $f1, 0.0        		# $f1 =0
	la $a0, intro2				#texto introductorio
	li $v0, 4 
	syscall
	la $a0, intro				#texto introductorio
	li $v0, 4 
	syscall
	la $a0, intro3				#texto introductorio
	li $v0, 4 
	syscall
	la $a0, intro2				#texto introductorio
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

# calcular e imprimir hipotenusa	
	jal hip
	la $a0, hip_mssg			# imprime texto
	li $v0,4 
	syscall
	
	mov.s $f12, $f8
	li $v0, 2 
 	syscall
	
#calcular e imprimir angulo
	c.lt.s $f2, $f3 
	bc1t tru_ab
	mov.s $f4, $f2
	mov.s $f17, $f3
	j next1
tru_ab:
	mov.s $f4, $f3
	mov.s $f17, $f2
	
next1:
 #llamada para seno y coseno
	jal divtrig					#en $f18, y $f19 se obtienen el seno y el coseno

	la $a0, sin_mssg			# imprime texto
	li $v0,4 
	syscall	
	mov.s $f12, $f18
	li $v0, 2 
 	syscall		

	la $a0, cos_mssg			# imprime texto
	li $v0,4 
	syscall	
	mov.s $f12, $f19
	li $v0, 2 
 	syscall

#llamada para angulo	
	jal angl
	la $a0, ang_mssg			# imprime texto
	li $v0,4 
	syscall	
	
	mov.s $f12, $f11
	li $v0, 2 
 	syscall	

	la $a0, ang_mssg2			# imprime texto
	li $v0,4 
	syscall	
	
	la $a0, reset			# imprime texto
	li $v0,4 
	syscall	
	
	j main

#***************************************************************************************#
#hip: obtiene la hipotenusa a traves del metodo raiz
#***************************************************************************************#	
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
#raiz: obtiene la raiz aproximada por el metodo newton	
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
	div.s $f9, $f7, $f8 		# $f9 =  n / x
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

#***************************************************************************************#
#angl: determina el arcoseno de un valor por aproximacion de taylor	
#***************************************************************************************#	
angl:
	addiu $sp, $sp, -36
	s.s $f2, 0($sp)
	s.s $f3, 8($sp)
	s.s $f4, 16($sp)
	s.s $f12, 24($sp)
	sw $ra, 32($sp)			#se guarda direccion de retorno
	
	div.s $f5, $f4, $f8		# x = d/c
	mtc1 $zero, $f11		# f11 = 0
	add.s $f11, $f11,$f5 	# $f11 = x
	#constantes:	
	li $t0, 1				# $t0 = n = 1
	li.s $f20, 1.0e-4 		# $f3: precision del angulo
	li.s $f4, 4.0			# $f4 = 4.0
	
for_angl:
	mul $t1, $t0, 2			# $t1 = 2n	
	addi $t4, $t1, 1		# $t4 = 2n+1 
	mtc1 $t4, $f14 			# 2n+1 a registro de punto flotante
	cvt.s.w $f14, $f14 		# $f14: 2n+1 a float
	
	move $a0, $t1			#paramentro de entrada
	jal factorial			#factorial de 2n($v0 = 2n!)
	mtc1 $v0, $f2 			# 2n! a registro de punto flotante
	cvt.s.w $f2, $f2 		# 2n! a float
	
	move $a0, $t0			# parametro de entrada
	jal factorial			#factorial de n ($v0 = n!)
	mtc1 $v0, $f3 			# n! a registro de punto flotante
	cvt.s.w $f3, $f3 		# n! a float
	
	mul.s $f9, $f3, $f3		# $f9 = (n!)^2
	
	move $a0, $t0			# primer parametro de entrada
	mov.s $f12, $f4			# segundo parametro de entrada
	jal exp_xy
	mov.s $f7, $f0 			#salida 4^n

	move $a0, $t4			# primer parametro de entrada
	mov.s $f12, $f5			# segundo parametro de entrada
	jal exp_xy
	mov.s $f15, $f0 		# $f15 = x ^ (2n+1)
	
	mul.s $f13, $f7, $f9 	#$f13= 4^n*(n!)^2 
	mul.s $f13, $f13, $f14 	#$f13= 4^n*((n!)^2)*(2n+1)
	div.s $f13, $f2, $f13	#$f13= 2n! / [4^n*((n!)^2)*(2n+1)]
	mul.s $f13, $f13, $f15 	#$f13= [2n! *  x^(2n+1)] / [4^n*((n!)^2)*(2n+1)]
	
	add.s $f11, $f11, $f13	#$f11: la sumatoria
	c.lt.s $f13,$f20 		# El ultimo termino es menor a 1.0e-5?
	bc1t return_angl
	
	addi $t0, $t0, 1		# n++
	j for_angl

return_angl:	
	lw $ra, 32($sp)
	l.s $f12, 24($sp)
	l.s $f4, 16($sp)
	l.s $f3, 8($sp)
	l.s $f2, 0($sp)

	addiu $sp, $sp, 36
	jr $ra

#***************************************************************************************#
# Factorial: determina el factorial de $a0 y lo devuelve en $v0 	
#***************************************************************************************#	
factorial:
	addi $sp, -8
	sw $ra, 4($sp) #Se guarda el valor de n
	sw $a0, 0($sp)

	slti $t7, $a0, 1 #Se comprueba su n < 1.
	beq $t7, $0, L1

	addi $v0, $0, 1
	addi $sp, 8
	jr $ra

	L1:
	addi $a0, $a0, -1
	jal factorial

	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, 8

	mul $v0, $a0, $v0
	jr $ra

#***************************************************************************************#
# exp_xy: determina el valor de elevar $f12 = x al exponente entero $a0 = y.  	
#***************************************************************************************
exp_xy:
	and $t3, $0, $t3				#i = 0
	li.s $f0, 1.0					# f0 = 0
for_exp:
	bge $t3, $a0, result_exp		#condicion de salida
	mul.s $f0, $f0, $f12  			# f0 = x * $f0
	addi $t3, $t3, 1 				# i++
	j for_exp
result_exp:
	jr $ra			

#***************************************************************************************#
#sen:$f18 determina el seno de un valor a traves de una division (cateto mayor e hip)
#cos:$f19 determina el coseno de un valor a traves de una division (cateto menor e hip)	
#***************************************************************************************#	
divtrig:
	div.s $f18, $f4, $f8
	div.s $f19, $f17, $f8
	jr $ra
	
#***************************************************************************************#
#fin: finaliza el programa.	
#***************************************************************************************#	
fin:
	la $a0, Finn				# imprime texto
	li $v0,4 
	syscall	
	li $v0, 10        			# Syscall para salir.
	syscall	

#***************************************************************************************#
#zero: mensaje de advertencia si algun cateto es cero. Termina el programa.	
#***************************************************************************************#		
zero:
	la $a0, ZeroIng				# imprime texto
	li $v0,4 
	syscall	
	j fin	