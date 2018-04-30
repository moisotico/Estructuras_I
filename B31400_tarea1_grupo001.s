# Universidad de Costa Rica 																								#
# Facultad de Ingenieria. Escuela de Ingenieria Electrica																	#
# Estructuras de Computadoras I, IE0321. Prof. Roberto Rodriguez R.															#
# Tarea 1																													#
# Moises Campos Zepeda. B31400																								#
# moiso.camposcr@gmail.com																									#
# Las tareas  se pueden ver en: https://github.com/moisotico																#
#***************************************************************************************************************************#
#***************************************************************************************************************************#
#	El siguiente programa inmpementa en la parte1 un BubbleSort para ordenar un vector, calcular sus elementos y pasarlos a	#
# $v0,e imprimir el numero de estos. Ademas de imprimir el vector Des[] antes y despues de dicho cambio, con print0 y print1#
# respectivamente. La segunda parte agarra dicho vector y a traves de dos direcciones ordena, de forma ascendente los		#
# numeros pares y de forma descendente lo impares, en el vector Ord[]. Se toma como referencia un solo recorrido ascendente	#
# a traves de Des[] y se imprime el vector Ord con print2.																	#
#***************************************************************************************************************************#
#***************************************************************************************************************************#
# Nota: el programa por default soporta solo 499 entradas en Ord, sin embargo se puede cambiar el 500 en la linea 23 por un #
# valor mayor.																												#
#***************************************************************************************************************************#
# $s0: swap,  $s1: contar, $s2: j, $s3: i, $s4:k , $s5: numElementos   														#
# $a2: direccion de Des, $a1: direccion de Ord 																				#
#***************************************************************************************************************************#

.data
	Des: .word 1, 4, 56, 32, 20, 43, 17, 7, 67, 0	# valores del vector (modificables, salvo el 0 al final)
	Ord: .word  0:500								#posicion_de_inicio:Maximo_de_elementos

#strings	
	coma: .asciiz ", "
	numArg: .asciiz "Elementos del vector: \n"
	Enter: .asciiz "\n"
	Vec0: .asciiz "Vector Des[] original: \n"
	Vec1: .asciiz "Vector Des[] post Bubblesort: \n"
	Vec2: .asciiz "Vector Ord[]: \n"
	
.text
main:
#*****************#
#*primer problema*#
#*****************#
	parte1:						# inicio del programa BubbleSort
		addi $s0, $0, 1			# swap = 1
		addi $s1, $0, 1	 		# contar = 1
		la  $a2, Des 			# dir de Des
		la 	$a1, Ord			# dir de Ord

	print0:
		la $a0, Vec0			# imprime texto
		li $v0,4 
		syscall
		
		and $s2, $0, $s2		#j = 0
	L1:
		sll $t1, $s2, 2			#jx4
		add $t2, $a2, $t1		#*(Des[j])
		lw $t3, 0($t2)			# Des[j]
		
		move $a0, $t3			#imprime Des[j]
		li 	$v0, 1
		syscall
		
		beq $t3, $0, while	#cond salida
			
		la $a0, coma			# imprime texto
		li $v0,4 
		syscall	
		
		addi $s2, $s2, 1		# j++
		j L1
	
	
	while:
		beq $s0, $0, numElement #salida del while(swap)
		and $s0, $0, $0			#swap = 0
		add $s2, $0, $0			#j = 0
	
	while_vect:
		sll $t0, $s2, 2			# $t0 = jx4
		addu $t1, $a2, $t0		# $t1 = *(Des[j])
		lw $t2, 0($t1)			# cargamos Des[j]
		lw $t3, 4($t1)			# Des[j+1]
		
		seq $t4, $t2, $0		# t4 es 0 si Des[j] !=0
		seq $t5, $t3, $0		# t5 es 0 Des[j+1] !=0	
		or  $t4, $t4, $t5		# t4 es 0 si Des[j] !=0 && Des[j+1] !=0
		beq $t4, $0, no_zero	# salta si no hay ceros en Des 	
		
		and  $s1, $0, $s1		# contar = 0
		j while
		
	no_zero:
		slt $t4, $t3, $t2 		# $t4=1 si: Des[j] > Des[j+1]
		beq $t4, $0, incr
								# sino
		addi $s0, $0, 1			# swap = 1
		
		lw $t2, 0($t1)			# cargamos Des[j]
		move $t4, $t2			# temp = Des[j]
		sw $t3, 0($t1)			# Ord[j] = Des[j+1]
		sw $t4, 4($t1)			# Ord[j+1] = temp
		
	incr:
		addi $s2, $s2, 1		# j++
		addi $t4, $0, 1			# $t4 = 1
		seq  $t4, $t4, $s1		# $t4 = 1 si cont =1
		beq	 $t4, $0, next
		addi $s5, $s5, 1		#numElementos ++
	
	next:
		j while_vect			#regresa al loop
		
	numElement:					
		addi $s5, $s5, 1		#numElementos ++
		
		la $a0, Enter			# imprime texto
		li $v0,4 
		syscall
		
		la $a0, numArg			# imprime un espacio en blanco
		li $v0,4 
		syscall
		
		move $a0, $s5			#numero de argumentos
		li 	$v0, 1
		syscall					#imprime el numero de elementos
		
#metodo print para Des
	print1:
		la $a0, Enter			# imprime texto
		li $v0,4 
		syscall	
		
		la $a0, Vec1			# imprime texto
		li $v0,4 
		syscall
		
		and $s2, $0, $s2		#j = 0
	L2:
		sll $t1, $s2, 2			#jx4
		add $t2, $a2, $t1		#*(Des[j])
		lw $t3, 0($t2)			# Des[j]
		
		move $a0, $t3			#imprime Des[j]
		li 	$v0, 1
		syscall
		
		beq $t3, $0, parte2
			
		la $a0, coma			# imprime texto
		li $v0,4 
		syscall	
		
		addi $s2, $s2, 1		# j++
		j L2
		
#******************#
#*segundo problema*#
#******************#	
	parte2:						# esta parte utiliza el output del BubbleSort
		and $s2, $0, $s2		#j = 0
		and $s3, $0, $s3		#i = 0
		addi $s4 ,$0, 1			#k = 1
		move $t4, $s5			# numElementos-k = numElementos		
		addi $t0, $0, 1 		# mascara
		
	L3:
		slt $t1, $t4, $s3		#salida de L3: NumElementos-k < i
		beq $t1, $t0, print2
		
		sub	$t4, $s5, $s4		#numElementos-k
		sll $t1, $s2, 2			# $t1 = jx4
		sll $t7, $t4, 2			#(numElementos-k)x4
		sll $t8, $s3, 2			# $t8 = ix4
		
		add $t2, $t1, $a2		# $t2 = *(Des[j])
		lw $t3, 0($t2)			# $t3 = Des[j]
		beq $t3, $0, zero		# Des[j] = 0
		and $t2, $t3, $t0		# Des[j] && 1
		beq $t2, $0, Par		# Si es par, ir a Par
	
	#si es impar, en cambio:
		add $t5, $a1, $t7		# $t5 = *(Ord[numElementos-k])
		sw $t3, 0($t5)			# Ord[numElementos-k] = Des[j]
		addi $s4, $s4, 1		# k++
		addi $s2, $s2, 1		# j++
		j L3
	
	Par:
		add $t5, $a1, $t8		#*(Ord[i])
		sw $t3, 0($t5)			# Ord[j] = Des[j]
		addi $s3, $s3, 1		# i++
		addi $s2, $s2, 1		# j++
		j L3
	
	zero:
		sll $t9, $s5, 2			#numElementosx4
		add $t5, $a1, $t9		#*(Ord[i])
		sw $t3, 0($t5)			# Ord[j] = Des[j]
		j L3
		
#metodo print para Ord	
	print2:
		la $a0, Enter			# imprime texto
		li $v0,4 
		syscall		
	
		la $a0, Vec2			# imprime texto
		li $v0,4 
		syscall		
		
		add $s2, $0, $0			#j = 0
	
	L4:
		sll $t1, $s2, 2			#jx4
		add $t2, $a1, $t1		#*(Ord[j])
		lw $t3, 0($t2)			# Ord[j]
		
		move $a0, $t3			#imprime Ord[j]
		li 	$v0, 1
		syscall
		
		#beq $t3, $0, fin
		beq $s2, $s5, fin		
		
		la $a0, coma			# imprime texto
		li $v0,4 
		syscall	
		
		addi $s2, $s2, 1		# j++
		j L4
		
	fin:
		li $v0, 10        		# Systemcall para salir.
		syscall					

#*fin del programa*#