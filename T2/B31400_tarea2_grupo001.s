# Universidad de Costa Rica 															#
# Facultad de Ingenieria. Escuela de Ingenieria Electrica								#
# Estructuras de Computadoras I, IE0321. Prof. Roberto Rodriguez R.						#
# Tarea 2																				#
# Moises Campos Zepeda. B31400															#
# moiso.camposcr@gmail.com																#
#***************************************************************************************#
#***************************************************************************************#
#	Programa para identificar palindromos, capaz de detectar espacios en blanco y		#
# mayusculas.
#***************************************************************************************#
#***************************************************************************************# 
# $s0: string leido , $s1: tamano de string, $s2: string simplificado
#***************************************************************************************#
#***************************************************************************************#
.data
intro:		.asciiz "Es su frase un palindromo? Averiguemoslo:\n "	
ask_input: 	.asciiz "\nEscriba una frase(de menos de 30 caracteres):"
buffer: 	.space 30 
show_input: .asciiz "\nLa frase escrita fue: "
msj: 	.asciiz	"longitud de string: "
Let:	.asciiz "\nLetra: "
Enter: 	.asciiz "\n"
yes: 	.asciiz "La frase es un palindromo\n"
nope:	.asciiz "La frase NO es un palindromo!\n"

.text
main:

text_intro:
	la $a0, intro				#texto introductorio
	li $v0, 4 
	syscall

while_true:		
		la $a0, ask_input		#texto explicativo
		li $v0, 4 
		syscall
		
		li $v0, 8				#ingresar input
		la $a0, buffer			#Carga bits de espacio a $a0 
		li	$a1, 30
		syscall
		
		move $s0, $a0			#guardamos string y string size
		move $s1, $a1

		la $a0, show_input		#texto explicativo
		li $v0, 4 
		syscall
		
		la $a0, buffer			#Recargar espacio
		move $a0,$s0			#t0 se carga a direccion
		li $v0,4 				# imprimir trexto leido
		syscall
		
		la $a0, Enter			#siguiente linea
		li $v0, 4 
		syscall
		
		la $a0, msj				#texto explicativo
		li $v0, 4 
		syscall
		
		move $a0, $s1			#numero de argumentos
		li 	$v0, 1
		syscall	

		la $a0, Let				#texto explicativo
		li $v0, 4 
		syscall

Recorrer		
		lb $t1, 0($s0) 			#t4 es str[t1]
		move $a0, $t1			#numero de argumentos
		li 	$v0, 1
		syscall	

		la $a0, Enter			
		li $v0, 4 
		syscall

#	rm_space:
#	rm_comma:
#	rm_pt:
#	rm_caps:

	true:
		la $a0, yes				#imprime mensaje si es palindromo
		li $v0,4 
		syscall
		j fin

	false:
		la $a0,nope				#imprime mensaje si es palindromo
		li $v0,4 
		syscall
	
	j while_true

fin:
	addi $v0, $0, 10        # Systemcall para salir.
    syscall