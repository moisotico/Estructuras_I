# Universidad de Costa Rica 															#
# Facultad de Ingenieria. Escuela de Ingenieria Electrica								#
# Estructuras de Computadoras I, IE0321. Prof. Roberto Rodriguez R.						#
# Tarea 2																				#
# Moises Campos Zepeda. B31400															#
# moiso.camposcr@gmail.com																#
#***************************************************************************************#
#***************************************************************************************#
#	Programa para identificar palindromos, capaz de detectar espacios en blanco y		
# mayusculas.
#***************************************************************************************#
#***************************************************************************************# 
# $s0: string leido , $s1: string simplificado, $s7: bandera de simbolo no valido,
# $s2-$s6, $t6, $t7: mascaras para identificar mayusculas, minusculas, puntos, espacios 
# y comas.
#***************************************************************************************#
#***************************************************************************************#


.data
#pendiente espacio a $s1
	intro:		.asciiz "Es su frase un palindromo? Averiguemoslo:\n "	
	ask_input: .asciiz "\nEscriba una frase de menos de 30 caracteres, solo puede contener puntos, comas o espacios (., ):"
	buffer1: 	.space 60 
	buffer2:	.space 60
	show_input: .asciiz "\nLa frase escrita fue: \n"
	msj: 	.asciiz	"longitud de string: "
	Char:	.asciiz "\nLetra: "
	Enter: 	.asciiz "\n"
	yes: 	.asciiz "La frase es un palindromo\n"
	nope:	.asciiz "La frase NO es un palindromo!\n"
	err:	.asciiz "\nAdvertencia: algunos caracteres no se pudieron leer!! Se procede a ignorarlos.\n" 
	retry_msg: .asciiz "Desea probar otra frase? (Y, y, S, s, Enter para seguir; otras teclas para salir): "
	retry_input: .space 4
	
	
.text
main:

text_intro:
	la $a0, intro				#texto introductorio
	li $v0, 4 
	syscall

#mascaras
		addi $s2, $0, 32		# ASCII de space
		addi $s3, $0, 44		# ASCII de comma
		addi $s4, $0, 46		# ASCII de point
		addi $s5, $0, 64		# banda inf. de Mayusc
		addi $s6, $0, 91		# banda sup. de Mayusc	
		addi $t6, $0, 97		# banda inf. de minusc
		addi $t7, $0, 123		# banda sup. de minusc	
		
while_true:
#mensajes de inicio
		and $s7, $s7, $0		#flag = 0 
		la $a0, ask_input		#texto explicativo
		li $v0, 4 
		syscall
		
		li $v0, 8				#ingresar input
		la $a0, buffer1			#Carga bits de espacio a $a0 
		li	$a1, 60
		syscall
		
		move $s0, $a0			#guardamos string y string size

		la $a0, show_input		#texto explicativo
		li $v0, 4 
		syscall
		
		la $a0, buffer1			#Recargar espacio
		move $a0,$s0			#t0 se carga a direccion
		li $v0,4 				# imprimir trexto leido
		syscall
		
		la $s1, buffer2			#recarga espacio
	
		la $a0, Enter			#siguiente linea
		li $v0, 4 
		syscall
		
		la $a0, msj				#texto explicativo
	#	li $v0, 4 
	#	syscall
		
	#	move $a0, $s1			#numero de argumentos
	#	li 	$v0, 1
	#	syscall	

	#	la $a0, Char			#texto explicativo
	#	li $v0, 4 
	#	syscall

		move $t0, $s0			# $t0 parte de la direccion del string 
		and $t4, $t4, $0		# t4 = strlen = 0 
		move $t5, $s1			# $t5 parte de inicio de string simplificado
		
		#move $a0, $s1			

#quitamos chars del string para "limpiarlo"		
	L_string:

		
		lb $t1, 0($t0) 			#t1 es str[t0]
	#	move $a0, $t1			#codigo ascii de la letra
	#	li 	$v0, 1
	#	syscall	

	#	la $a0, Enter			
	#	li $v0, 4 
	#	syscall
		
		beq $t1, 10, out			#si el char es una nueva linea termina el string

		rm_space:
			beq $t1, $s2, next
		rm_comma:
			beq $t1, $s3, next
		rm_pt:
			beq $t1, $s4, next
		rm_caps:
			slt $t2, $s5, $t1		# $t2 = 1 si $t1 >= 65
			slt $t3, $t1, $s6		# $t2 = 1 si $t1 < 91
			and $t3, $t3, $t2		#cumple ambas condiciones
			beq $t3, $0, valid
			addi $t1, $t1, 32		#Paso de Mayusc a minusc
			sb $t1, 0($t5)			# guardamos char en minusc
			addi $t4, $t4, 1		#strlen++
			add $t5, $s1, $t4		#avanzamos una poscicion
			j next
		
		valid:
			sge $t2, $t1, $t6		# $t2 = 1 si $t1 >= 97
			slt $t3, $t1, $t7		# $t2 = 1 si $t1 < 123
			and $t3, $t3, $t2		#cumple ambas condiciones
		
			beq $t3, $0, warning	#si no cumple ambas cod
			sb $t1, 0($t5)			#si cumple ambas se guarda
			addi $t4, $t4, 1		#strlen++
			add $t5, $s1, $t4		#avanzamos una poscicion
			j next
		
		warning:	
			addi $s7, $0, 1
		
		next:
			addi $t0, $t0, 1		# i++
			addi $t8, $t8, 1	
			j L_string
	
	out:
		slt $t9, $t4, 2  
		beq $t9, 1, false
		move $a2, $t4			#paso strlen a $a2 
		beq $s7, $0, cont 
	
	flag:
		la $a0, err			
		li $v0, 4 
		syscall
	
	cont:
		add $t1, $s1, $0		# $t1: es direccion de inicio para str reducido
		add $t2, $s1, $a2		
		addi $t2, $t2, -1		# t2 = dir de inicio+strlen-1
	
L2:	
		slt $t4, $t1, $t2		#$t4 = 1 si t2 > t1
		bne $t4, $0, B2			#salta si t4 = 1
		j true

	B2:
		lb $t3 ($t2)			# cargamos el byte
		lb $t4 ($t1)
		beq $t3, $t4, B3		
		j false

	B3:
		addi $t2, $t2, -1	#t2++
		addi $t1, $t1, 1	#t1++
		j L2
		
true:
	la $a0, yes				#imprime mensaje si es palindromo
	li $v0,4 
	syscall
	j retry
	
false:
	la $a0,nope				#imprime mensaje si es palindromo
	li $v0,4 
	syscall
	j retry
	
 retry:
	la $a0, Enter				#imprime mensaje si es palindromo
	li $v0,4 
	syscall
 
	la $a0, retry_msg
	syscall
	li $a1, 4
	li $v0, 8
	la $a0, retry_input    #Preguntamos si el usuario quiere probar de nuevo. 
	syscall

	#interpretaciones de seguir
	lb $t0, 0($a0)
	beq $t0, 121, while_true	#regresa al loop
	beq	$t0, 89, while_true
	beq	$t0, 115, while_true
	beq	$t0, 83, while_true
	beq	$t0, 10, while_true
	j fin
	
fin:
	addi $v0, $0, 10        # Systemcall para salir.
    syscall