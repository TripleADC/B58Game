
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
	
game_start:
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
	bge $t1, $t3, background_details
	sw $t2, 0($t1)			# Printing dot
	addi $t1, $t1, 4		# Incrementing along screen
	j background_draw_loop
	
	# Let $t1 be the address that traverses through the screen
	# Let $t2 be the colour that will be printed
background_details:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
					
	addi $t1, $t1, 256
	li $t2, 0x006f9cbf		# 2nd LAYER of screen
	sw $t2, 124($t1)
	
	addi $t1, $t1, 256		# 3rd LAYER of screen
	sw $t2, 124($t1)
	
	addi $t1, $t1, 256		# 4th LAYER of screen
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	
	addi $t1, $t1, 256		# 5th LAYER of screen
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	
	addi $t1, $t1, 256		# 6th LAYER of screen
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	
	addi $t1, $t1, 256		# 7th LAYER of screen
	sw $t2, 112($t1)
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	
	addi $t1, $t1, 256		# 8th LAYER of screen
	sw $t2, 100($t1)
	sw $t2, 104($t1)
	sw $t2, 108($t1)
	sw $t2, 112($t1)
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	sw $t2, 140($t1)
	sw $t2, 144($t1)
	sw $t2, 148($t1)
	
	addi $t1, $t1, 256		# 9th LAYER of screen
	sw $t2, 112($t1)
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	li $t2, 0x003e3765
	sw $t2, 240($t1)
	sw $t2, 244($t1)
	sw $t2, 248($t1)
	
	addi $t1, $t1, 256		# 10th LAYER of screen
	sw $t2, 16($t1)
	li $t2, 0x006f9cbf
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	li $t2, 0x003e3765
	sw $t2, 224($t1)
	sw $t2, 228($t1)
	sw $t2, 232($t1)
	sw $t2, 236($t1)
	sw $t2, 240($t1)
	sw $t2, 244($t1)
	sw $t2, 252($t1)
	
	addi $t1, $t1, 256		# 11th LAYER of screen
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	li $t2, 0x006f9cbf
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	li $t2, 0x003e3765
	sw $t2, 200($t1)
	sw $t2, 204($t1)
	sw $t2, 208($t1)
	sw $t2, 212($t1)
	sw $t2, 216($t1)
	sw $t2, 220($t1)
	sw $t2, 224($t1)
	sw $t2, 228($t1)
	sw $t2, 232($t1)
	sw $t2, 236($t1)
	sw $t2, 240($t1)
	sw $t2, 244($t1)
	sw $t2, 248($t1)
	sw $t2, 252($t1)
	
	addi $t1, $t1, 256		# 12th LAYER of screen
	sw $t2, 0($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	li $t2, 0x006f9cbf
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	li $t2, 0x003e3765
	sw $t2, 220($t1)
	sw $t2, 224($t1)
	sw $t2, 228($t1)
	sw $t2, 232($t1)
	sw $t2, 236($t1)
	
	addi $t1, $t1, 256		# 13th LAYER of screen
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	sw $t2, 180($t1)
	sw $t2, 184($t1)
	sw $t2, 188($t1)
	sw $t2, 192($t1)
	sw $t2, 196($t1)
	sw $t2, 200($t1)
	sw $t2, 204($t1)
	sw $t2, 208($t1)
	sw $t2, 212($t1)
	sw $t2, 216($t1)
	sw $t2, 220($t1)
	sw $t2, 224($t1)
	sw $t2, 228($t1)
	sw $t2, 232($t1)
	sw $t2, 236($t1)
	sw $t2, 240($t1)
	sw $t2, 244($t1)
	
	addi $t1, $t1, 256		# 14th LAYER of screen
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	sw $t2, 164($t1)
	sw $t2, 168($t1)
	sw $t2, 172($t1)
	sw $t2, 176($t1)
	sw $t2, 180($t1)
	sw $t2, 184($t1)
	sw $t2, 188($t1)
	sw $t2, 192($t1)
	sw $t2, 196($t1)
	sw $t2, 200($t1)
	sw $t2, 204($t1)
	sw $t2, 208($t1)
	sw $t2, 212($t1)
	sw $t2, 216($t1)
	sw $t2, 220($t1)
	sw $t2, 224($t1)
	sw $t2, 228($t1)
	sw $t2, 232($t1)
	sw $t2, 236($t1)
	sw $t2, 240($t1)
	
	addi $t1, $t1, 256		# 15th LAYER of screen
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	sw $t2, 156($t1)
	sw $t2, 160($t1)
	sw $t2, 164($t1)
	sw $t2, 168($t1)
	sw $t2, 176($t1)
	sw $t2, 180($t1)
	sw $t2, 184($t1)
	sw $t2, 188($t1)
	sw $t2, 192($t1)
	sw $t2, 196($t1)
	sw $t2, 200($t1)
	sw $t2, 204($t1)
	sw $t2, 208($t1)
	sw $t2, 212($t1)
	sw $t2, 216($t1)
	sw $t2, 220($t1)
	
	addi $t1, $t1, 256		# 16th LAYER of screen
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	sw $t2, 156($t1)
	sw $t2, 160($t1)
	sw $t2, 164($t1)
	sw $t2, 168($t1)
	sw $t2, 172($t1)
	sw $t2, 176($t1)
	sw $t2, 180($t1)
	sw $t2, 184($t1)
	sw $t2, 188($t1)
	
	addi $t1, $t1, 256		# 17th LAYER of screen
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	sw $t2, 236($t1)
	sw $t2, 240($t1)
	sw $t2, 244($t1)
	
	addi $t1, $t1, 256		# 18th LAYER of screen
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	sw $t2, 80($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	
	addi $t1, $t1, 256		# 19th LAYER of screen
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	sw $t2, 80($t1)
	sw $t2, 84($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	
	addi $t1, $t1, 256		# 20th LAYER of screen
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	sw $t2, 80($t1)
	sw $t2, 84($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	li $t2, 0x003e3765
	
	addi $t1, $t1, 256		# 21th LAYER of screen
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	sw $t2, 80($t1)
	sw $t2, 84($t1)
	sw $t2, 88($t1)
	sw $t2, 92($t1)
	sw $t2, 96($t1)
	sw $t2, 100($t1)
	
	addi $t1, $t1, 256		# 22th LAYER of screen
	sw $t2, 104($t1)
	sw $t2, 108($t1)
	sw $t2, 112($t1)
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 144($t1)
	sw $t2, 148($t1)
	sw $t2, 152($t1)
	
	addi $t1, $t1, 256		# 23rd LAYER of screen
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	sw $t2, 80($t1)
	sw $t2, 84($t1)
	sw $t2, 88($t1)
	sw $t2, 136($t1)
	sw $t2, 140($t1)
	
	addi $t1, $t1, 256		# 24th LAYER of screen
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	sw $t2, 48($t1)
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	li $t2, 0x006f9cbf
	sw $t2, 124($t1)
	
	addi $t1, $t1, 2304		# 33rd LAYER of screen
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 48($t1)
	sw $t2, 60($t1)
	sw $t2, 64($t1)
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	sw $t2, 80($t1)
	sw $t2, 84($t1)
	sw $t2, 88($t1)
	sw $t2, 92($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	sw $t2, 140($t1)
	sw $t2, 144($t1)
	sw $t2, 148($t1)
	sw $t2, 152($t1)
	sw $t2, 156($t1)
	sw $t2, 160($t1)
	sw $t2, 164($t1)
	sw $t2, 168($t1)
	sw $t2, 172($t1)
	sw $t2, 176($t1)
	sw $t2, 180($t1)
	sw $t2, 184($t1)
	sw $t2, 188($t1)
	sw $t2, 192($t1)
	sw $t2, 196($t1)
	sw $t2, 204($t1)
	sw $t2, 208($t1)
	sw $t2, 212($t1)
	
	addi $t1, $t1, 768		# 36th LAYER of screen
	sw $t2, 96($t1)
	sw $t2, 100($t1)
	sw $t2, 104($t1)
	sw $t2, 108($t1)
	sw $t2, 112($t1)
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	sw $t2, 140($t1)
	sw $t2, 144($t1)
	sw $t2, 148($t1)
	sw $t2, 152($t1)
	sw $t2, 156($t1)
	sw $t2, 160($t1)
	sw $t2, 164($t1)
	
	addi $t1, $t1, 256		# 37th LAYER of screen
	sw $t2, 116($t1)
	sw $t2, 120($t1)
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	sw $t2, 140($t1)
	sw $t2, 144($t1)
	sw $t2, 148($t1)
	
	addi $t1, $t1, 256		# 38th LAYER of screen
	sw $t2, 124($t1)
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)	
	
	addi $t1, $t1, 512		# 39th LAYER of screen
	sw $t2, 128($t1)
	sw $t2, 132($t1)
	sw $t2, 136($t1)
	sw $t2, 140($t1)
	
	addi $t1, $t1, 256		# 40th LAYER of screen
	sw $t2, 136($t1)
	
	addi $t1, $t1, 512		# 41th LAYER of screen
	sw $t2, 136($t1)
	
	addi $t1, $t1, 512		# 42th LAYER of screen
	sw $t2, 136($t1)
	
	addi $t1, $t1, 256		# 43th LAYER of screen
	sw $t2, 136($t1)
	
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
	
	li $t2, 0x00a775b0	# FIRST LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00000000
	sw $t2, 8($t1)
	li $t2, 0x00a775b0
	sw $t2, 12($t1)
	li $t2, 0x00000000
	sw $t2, 16($t1)
	li $t2, 0x00a775b0
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00000000
	sw $t2, 8($t1)
	li $t2, 0x00a775b0
	sw $t2, 12($t1)
	li $t2, 0x00000000
	sw $t2, 16($t1)
	li $t2, 0x00a775b0
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	li $t2, 0x009a3048
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	li $t2, 0x009a3048
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	li $t3, 0xffff0000	# Checking if a key was pressed
	lw $t4, 0($t3)
	beq $t4, 1, control
	bltz $s2, friction_slow_a
	j friction_slow_d	# If no buttons were pressed, then we reduce velocity (slow the player down)
	
### CONTROLS (VELOCITY)
	# Let $t3, $t4, $t5, $t6 be a TEMPORARY register for calculations in this label
	# Let 3, -3 be maximum velocities
control:
	lw $t4, 4($t3)		# Fetching button pressed
	beq $t4, 0x77, w_pressed
	beq $t4, 0x64, d_pressed
	beq $t4, 0x61, a_pressed
	
a_pressed:
	beq $s2, -6, side_collide	# Checking if max velocity
	addi $s2, $s2, -2	# Changing x velocity -- Let acceleration be 1 for simplicity
	
	# Reduce y velocities to make transition more seamless
	bltz $s3, neg_dy
	j pos_dy

d_pressed:
	beq $s2, 6, side_collide
	addi $s2, $s2, 2
	
	# Reduce y velocities to make transition more seamless
	bltz $s3, neg_dy
	j pos_dy

w_pressed:	
	bnez $s3, gravity	# Cannot jump again until reaches the ground
	addi $s3, $s3, -9	# Changing y velocity "Jumping"
	j gravity
	
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
	bge $s3, 2, side_collide	# Checking if max velocity
	addi $s3, $s3, 2
	
### PLATFORMS
	# Let white be the designated colour of platofmrs

### EDGE COLISSION
side_collide:
	ble $s0, 56, side_collide_2
	li $t5, -1
	mult $s2, $t5	# Bounce off edge
	mflo $s2
	
side_collide_2:
	bge $s0, 4, floor_collide
	li $t5, -1
	mult $s2, $t5	# Bounce off edge
	mflo $s2

floor_collide:
	# TO-DO: Check if the floor is white
	blt $s1, 50, move_player
	bltz $s3, move_player
	li $s3, 0			# Changing velocity to 0 if it is at the bottom

### MOVING PLAYER

move_player:
	add $s0, $s2, $s0	# Moving player based on velocity
	add $s1, $s3, $s1
	
	addi $t5, $t4, 0	# Keeping track
	
	
	j loop
exit: 
	li $v0, 10 # terminate the program gracefully
	syscall

