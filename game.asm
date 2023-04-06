
#####################################################################
#
# CSCB58 Winter 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Ashtian Dela Cruz, 1008154710, delac170, ashtian.delacruz@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################



.eqv BASE_ADDRESS 0x10008000

.text
	# INITIALIZING BASE ADDRESS
	li $t0, BASE_ADDRESS
	
	# PREAMBLE
	# Let p be the player, and any values 
	# Let $s0 = p.x, $s1 = p.y, $s2 = p.dx, $s3 = p.dy
	# These values are stored in registers because they are accessed frequently 
	
	# INITIALIZING PLAYER VALUES
	li $s0, 10
	li $s1, 10
	li $s2, 0
	li $s3, 0
	
loop:
	li $v0, 32
	li $a0, 30	# Achieving 24fps
	syscall

### DRAWING BACKGROUND

	# TO-DO: Draw background from file

	# Let $t1 be the address that traverses through the screen
	# Let $t2 be the colour that will be printed
	# Let $t3 be the end address to stop the loop
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	li $t2, 0x00000000		# $t2 = Black
	li $t3, BASE_ADDRESS
	addi $t3, $t3, 16624		# $t3 = BASE_ADDRESS + 16624
	
background_draw_loop:
	bge $t1, $t3, print_player
	sw $t2, 0($t1)			# Printing dot
	addi $t1, $t1, 4		# Incrementing along screen
	j background_draw_loop
	
### DRAWING PLAYER

	# Let $t1 store the address of where the player character should be printed
	# Let $t2 store colours that will be printed
	# Let $t3, $t4 be a TEMPORARY register for calculations in this label
print_player: 
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	mult $t3, $t4		# $t3 = p.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + p.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + p.y * 256)
	
	li $t2, 0xFAB3E8
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	
	li $t3, 0xffff0000	# Checking if a key was pressed
	lw $t4, 0($t3)
	beq $t4, 1, control
	j gravity
	
### CONTROLS (VELOCITY)
	# Let $t3, $t4, $t5, $t6 be a TEMPORARY register for calculations in this label
	# Let 3, -3 be maximum velocities
control:
	lw $t4, 4($t3)		# Fetching button pressed
	beq $t4, 0x77, w_pressed
	beq $t4, 0x64, d_pressed
	beq $t4, 0x61, a_pressed
	
				# If no buttons were pressed, then we reduce velocity (slow the player down)
	bltz $s2, friction_slow_a
	j friction_slow_d
	
a_pressed:
	beq $s2, -3, move_player	# Checking if max velocity
	addi $s2, $s2, -1	# Changing x velocity -- Let acceleration be 1 for simplicity
	
	# Reduce y velocities to make transition more seamless
	bltz $s3, neg_dy
	j pos_dy

d_pressed:
	beq $s2, 3, move_player
	addi $s2, $s2, 1
	
	# Reduce y velocities to make transition more seamless
	bltz $s3, neg_dy
	j pos_dy

w_pressed:	
	beq $t5, 0x77, gravity
	addi $s3, $s3, -9	# Changing y velocity "Jumping"
	
	# Reduce x velocities to make transition more seamless
	bltz $s2, friction_slow_a
	j friction_slow_d
	
friction_slow_a:
	beqz $s2, gravity		# Checking if velocity is already 0
	addi $s2, $s2, 1
	j gravity
	
friction_slow_d:
	beqz $s2, gravity		# Checking if velocity is already 0
	addi $s2, $s2, -1
	j gravity

pos_dy:
	li $s3, 1
	j gravity
	
neg_dy:
	li $s3, -1

### GRAVITY

gravity:
	
	bge $s3, 2, move_player	# Checking if max velocity
	addi $s3, $s3, 2
	
### PLATFORMS
	
### MOVING PLAYER

move_player:
	add $s0, $s2, $s0	# Moving player based on velocity
	add $s1, $s3, $s1
	
	addi $t5, $t4, 0	# Keeping track
	
	j loop
exit: 
	li $v0, 10 # terminate the program gracefully
	syscall

