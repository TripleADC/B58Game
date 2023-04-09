
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

.data
# Let enemy data be read like player data: e.x, e.y, e.dx, e.dy, e.facing, e.alive, e.timer
enemy_1_data:	.word 30, 54, 1, 0, 1, 1, 15000
enemy_2_data:	.word 54, 21, 0, 0, 0, 1, 15000
enemy_3_data:	.word 4, 36, 0, 0, 1, 1, 15000

kirby_full:	.word 0
kirby_facing:	.word 1		# 1 for right, 0 for left
kirby_health:	.word 5
kirby_invincible_frames:	.word 2000
kirby_attack_frames:		.word 1500


.eqv BASE_ADDRESS 0x10008000

.text
	# INITIALIZING BASE ADDRESS
	li $t0, BASE_ADDRESS
	
	# PREAMBLE
	# Let p be the player, and any values 
	# Let $s0 = p.x, $s1 = p.y, $s2 = p.dx, $s3 = p.dy
	# These values are stored in registers because they are accessed frequently 
	# Let $t9 hold the last button pressed
	# Let $t7, $t8 hold enemy data
	
	# Let $t3, $t4 be temporary variables
game_start:
	li $s0, 30	# Initializing player values
	li $s1, 21
	li $s2, 0
	li $s3, 0
	
	la $t3, kirby_health
	li $t4, 5
	sw $t4, 0($t3)
	
	# Initializing enemy 1 data
	la $t7, enemy_1_data
	li $t3, 30
	sw $t3, 0($t7)		
	li $t3, 54
	sw $t3, 4($t7)
	li $t3, 1
	sw $t3, 8($t7)
	
	# Initializing enemy 2 data
	la $t7, enemy_2_data
	li $t3, 56
	sw $t3, 0($t7)		
	li $t3, 21
	sw $t3, 4($t7)
	
	# Initializing enemy 3 data
	la $t7, enemy_3_data
	li $t3, 2
	sw $t3, 0($t7)		
	li $t3, 36
	sw $t3, 4($t7)
	
loop:
	li $v0, 32
	li $a0, 30	# Achieving 24fps
	syscall
	
### HEALTH AND INVINCIBILITY

	# Let $t1, $t2, $t3, $t4 be temporary variables
health_check:
	la $t1, kirby_health
	lw $t2, 0($t1)
	blez $t2, exit
	
invincible_check:
	la $t1, kirby_invincible_frames
	lw $t2, 0($t1)
	blt $t2, 2000, invincible_decrement
	j attackframe_check
	
invincible_decrement:
	addi $t2, $t2, -100
	sw $t2, 0($t1)
	
	blez $t2, invincible_update
	j attackframe_check
	
invincible_update:
	li $t2, 2000
	sw $t2, 0($t1)
	
attackframe_check:
	la $t1, kirby_attack_frames
	lw $t2, 0($t1)
	blt $t2, 1500, attackframe_decrement
	j enemy_1_respawn_check
	
attackframe_decrement:
	addi $t2, $t2, -100
	sw $t2, 0($t1)
	
	blez $t2, attackframe_update
	j enemy_1_respawn_check
	
attackframe_update:
	li $t2, 1500
	sw $t2, 0($t1)
	
enemy_1_respawn_check:
	la $t1, enemy_1_data
	lw $t2, 24($t1)
	blt $t2, 15000, enemy_1_decrement
	j enemy_2_respawn_check
	
enemy_1_decrement:
	addi $t2, $t2, -100
	sw $t2, 24($t1)
	
	blez $t2, enemy_1_respawn
	j enemy_2_respawn_check
	
enemy_1_respawn:
	li $t2, 30		# Resetting positions
	sw $t2, 0($t1)
	li $t2, 54
	sw $t2, 4($t1)
	li $t2, 1		# Resetting speeds and facing
	sw $t2, 8($t1)	
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	li $t2, 0
	sw $t2, 12($t1)
	li $t2, 15000		# Resetting timer
	sw $t2, 24($t1)
	
enemy_2_respawn_check:
	la $t1, enemy_2_data
	lw $t2, 24($t1)
	blt $t2, 15000, enemy_2_decrement
	j enemy_3_respawn_check
	
enemy_2_decrement:
	addi $t2, $t2, -100
	sw $t2, 24($t1)
	
	blez $t2, enemy_2_respawn
	j enemy_3_respawn_check
	
enemy_2_respawn:
	li $t2, 54		# Resetting positions
	sw $t2, 0($t1)
	li $t2, 21
	sw $t2, 4($t1)
	li $t2, 1		# Resetting speeds and facing
	sw $t2, 20($t1)
	li $t2, 0
	sw $t2, 8($t1)	
	sw $t2, 12($t1)	
	sw $t2, 16($t1)
	li $t2, 15000		# Resetting timer
	sw $t2, 24($t1)
	
enemy_3_respawn_check:
	la $t1, enemy_3_data
	lw $t2, 24($t1)
	blt $t2, 15000, enemy_3_decrement
	j background_draw_prelude
	
enemy_3_decrement:
	addi $t2, $t2, -100
	sw $t2, 24($t1)
	
	blez $t2, enemy_3_respawn
	j background_draw_prelude
	
enemy_3_respawn:
	li $t2, 4		# Resetting positions
	sw $t2, 0($t1)
	li $t2, 36
	sw $t2, 4($t1)
	li $t2, 1		# Resetting speeds and facing
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	li $t2, 0
	sw $t2, 8($t1)	
	sw $t2, 12($t1)
	li $t2, 15000		# Resetting timer
	sw $t2, 24($t1)

### DRAWING BACKGROUND
background_draw_prelude:
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
	
### DRAWING PLATFORMS
	# Let $t1 store the address of where the player character should be printed
	# Let $t2 store colours that will be printed
	# Let $t3, $t4, $t5, $t6, $t7 be a TEMPORARY register for calculations in this label
	# where $t3, y coordinate for the platform
	
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	li $t2, 0x00d2e2e4		# 2nd LAYER of screen
					
	addi $t1, $t1, 2816		
	li $t3, 1024			# $t3 = 256 * 4, since each platform will be 4 units wide
	li $t4, 0
	
	# First platform - Topmost starting on 12th layer
first_platform:
	beq $t3, $t4, second_platform_prelude
	addi $t1, $t1, 256
	
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
	sw $t2, 168($t1)
	sw $t2, 172($t1)
	sw $t2, 176($t1)
	sw $t2, 180($t1)
	sw $t2, 184($t1)
	sw $t2, 188($t1)
	
	addi $t4, $t4, 256
	
	j first_platform
	
second_platform_prelude:
	addi $t1, $t1, 2816	# Second platform - Topmost starting on 22th layer
	li $t4, 0

second_platform:	
	beq $t3, $t4, third_platform_prelude
	addi $t1, $t1, 256
	
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
	
	addi $t4, $t4, 256
	
	j second_platform
	
third_platform_prelude:
	addi $t1, $t1, 2816
	li $t4, 0

third_platform:
	beq $t3, $t4, floor_prelude
	addi $t1, $t1, 256
	
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
	
	addi $t4, $t4, 256
	
	j third_platform

floor_prelude:
	addi $t1, $t1, 3584
	li $t4, 0
	
floor:
	beq $t3, $t4, print_player_prelude
	addi $t1, $t1, 256
	
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
	sw $t2, 88($t1)
	sw $t2, 92($t1)
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
	sw $t2, 244($t1)
	sw $t2, 248($t1)
	sw $t2, 252($t1)
	
	addi $t4, $t4, 256
	j floor

### DRAWING PLAYER
	# Let $t1 store the address of where the player character should be printed
	# Let $t2 store colours that will be printed
	# Let $t3, $t4 be a TEMPORARY register for calculations in this label
	
print_player_prelude:
	la $t3, kirby_invincible_frames	# Checking if kirby is invincible
	lw $t4, 0($t3)
	blt $t4, 2000, print_player_invincible
	
	la $t3, kirby_attack_frames	# Checking if kirby is attacking
	lw $t4, 0($t3)
	blt $t4, 1500, print_player_attack_prelude
	
	la $t3, kirby_facing
	lw $t4, 0($t3)				# Checking if kirby is facing left
	beq $t4, 0, print_player_left_prelude
	ble $s3, -5, print_player_jumping_right
	bge $s3, 2, print_player_falling_right
	j print_player
	
print_player_invincible:
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	mult $t3, $t4		# $t3 = p.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + p.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + p.y * 256)
	
	li $t2, 0x00ffe8ff	# FIRST LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)

	j print_enemy_prelude
	
print_player_attack_prelude:
	la $t3, kirby_facing
	lw $t4, 0($t3)
	beq $t4, 0, print_player_attack_left
	j print_player_attack_right

print_player_attack_left:
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
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00a775b0
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	li $t2, 0x009a3048
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)

	j print_enemy_prelude

print_player_attack_right:
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
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	
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
	
	j print_enemy_prelude

print_player_left_prelude:
	ble $s3, -5, print_player_jumping_left
	bge $s3, 2, print_player_falling_left
	j print_player_left

print_player_jumping_left:
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	mult $t3, $t4		# $t3 = p.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + p.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + p.y * 256)
	
	li $t2, 0x00a775b0	# FIRST LAYER of character
	sw $t2, 0($t1)
	li $t2, 0x00000000
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00a775b0
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	sw $t2, 0($t1)
	li $t2, 0x00000000
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00a775b0
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	li $t2, 0x00a775b0
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	li $t2, 0x009a3048
	sw $t2, 12($t1)
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	li $t2, 0x009a3048
	sw $t2, 4($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	j print_enemy_prelude
	
print_player_falling_left:
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	mult $t3, $t4		# $t3 = p.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + p.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + p.y * 256)
	
	li $t2, 0x009a3048 	# FIRST LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	li $t2, 0x00a775b0
	sw $t2, 0($t1)
	li $t2, 0x009a3048
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	li $t2, 0x00a775b0
	sw $t2, 12($t1)
	li $t2, 0x009a3048
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	li $t2, 0x00a775b0
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	li $t2, 0x009a3048
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	li $t2, 0x00a775b0
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	j print_enemy_prelude

print_player_left:
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
	li $t2, 0x00000000
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00a775b0
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	li $t2, 0x00000000
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00a775b0
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	li $t2, 0x00a775b0
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	li $t2, 0x009a3048
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	li $t2, 0x009a3048
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	j print_enemy_prelude
	
print_player_jumping_right:
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	mult $t3, $t4		# $t3 = p.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + p.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + p.y * 256)
	
	li $t2, 0x00a775b0	# FIRST LAYER of character
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
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	li $t2, 0x009a3048
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	li $t2, 0x00a775b0
	sw $t2, 12($t1)
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	li $t2, 0x009a3048
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 16($t1)
	
	j print_enemy_prelude
	
print_player_falling_right:
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	mult $t3, $t4		# $t3 = p.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + p.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + p.y * 256)
	
	li $t2, 0x009a3048 	# FIRST LAYER of character
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	li $t2, 0x009a3048
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	li $t2, 0x00a775b0
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	li $t2, 0x009a3048
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00a775b0
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	j print_enemy_prelude
	

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
	
### DRAWING ENEMIES

print_enemy_prelude:	
	# Let $t7, and $t8 hold enemy data
	la $t7, enemy_1_data
	jal print_enemy
	la $t7, enemy_2_data
	jal print_enemy
	la $t7, enemy_3_data
	jal print_enemy
	
	j print_hearts_prelude
	
print_enemy:
	lw $t8, 0($t7)		# $t8 = e1.x
	
	sll $t3, $t8, 2 	# $t3 = e1.x * 4 = e1.x * pixel size
	addi $t1, $t3, 0	# $t1 = e1.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	lw $t8, 4($t7)		# $t8 = e1.y
	
	addi $t3, $t8, 0	# $t3 = e1.y
	mult $t3, $t4		# $t3 = e1.y * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = e1.x * 4 + e1.y * 256
	add $t1, $t0, $t1	# $t1 = base address + (e1.x * 4 + e1.y * 256)
	
	lw $t5, 8($t7)
	bgtz $t5, print_enemy_right
	bltz $t5, print_enemy_left
	
facing_test:
	lw $t5, 16($t7)
	beq $t5, 1, print_enemy_right
	
print_enemy_left:
	li $t2, 0x00ca6037	# FIRST LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	sw $t2, 0($t1)
	li $t2, 0x00000000
	sw $t2, 4($t1)
	li $t2, 0x00f1ad5c
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00ca6037
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	li $t2, 0x00000000
	sw $t2, 4($t1)
	li $t2, 0x00f1ad5c
	sw $t2, 8($t1)
	li $t2, 0x00000000
	sw $t2, 12($t1)
	li $t2, 0x00ca6037
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	li $t2, 0x00f1ad5c
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	li $t2, 0x00ca6037
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	li $t2, 0x00f1ad5c
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	jr $ra
	
print_enemy_right:
	li $t2, 0x00ca6037	# FIRST LAYER of character
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	addi $t1, $t1, 256	# SECOND LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00000000
	sw $t2, 8($t1)
	li $t2, 0x00f1ad5c
	sw $t2, 12($t1)
	li $t2, 0x00000000
	sw $t2, 16($t1)
	li $t2, 0x00ca6037
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# THIRD LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00000000
	sw $t2, 8($t1)
	li $t2, 0x00f1ad5c
	sw $t2, 12($t1)
	li $t2, 0x00000000
	sw $t2, 16($t1)
	li $t2, 0x00ca6037
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FOURTH LAYER of character
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	li $t2, 0x00f1ad5c
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	addi $t1, $t1, 256	# FIFTH LAYER of character
	li $t2, 0x00f1ad5c
	sw $t2, 4($t1)
	li $t2, 0x00ca6037
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)

	addi $t1, $t1, 256	# SIXTH LAYER of character
	li $t2, 0x00f1ad5c
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 16($t1)
	sw $t2, 20($t1)
	
	jr $ra
	
	# Let $t1, $t2, $t3, $t4, $t5, $t6 be temporary variables
print_hearts_prelude:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	li $t2, 0x00a775b0		
	la $t3, kirby_health
	lw $t4, 0($t3)
	
print_heart_1:
	addi $t1, $t1, 256
	sw $t2, 4($t1)
	sw $t2, 12($t1)
	addi $t1, $t1, 256
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	addi $t1, $t1, 256
	sw $t2, 8($t1)
	
	bgt $t4, 1, print_heart_2
	j control_prelude
	
print_heart_2:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	addi $t1, $t1, 256
	sw $t2, 20($t1)
	sw $t2, 28($t1)
	addi $t1, $t1, 256
	sw $t2, 20($t1)
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	addi $t1, $t1, 256
	sw $t2, 24($t1)
	
	bgt $t4, 2, print_heart_3
	j control_prelude
	
print_heart_3:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	addi $t1, $t1, 256
	sw $t2, 36($t1)
	sw $t2, 44($t1)
	addi $t1, $t1, 256
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	sw $t2, 44($t1)
	addi $t1, $t1, 256
	sw $t2, 40($t1)
	
	bgt $t4, 3, print_heart_4
	j control_prelude
	
print_heart_4:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	addi $t1, $t1, 256
	sw $t2, 52($t1)
	sw $t2, 60($t1)
	addi $t1, $t1, 256
	sw $t2, 52($t1)
	sw $t2, 56($t1)
	sw $t2, 60($t1)
	addi $t1, $t1, 256
	sw $t2, 56($t1)
	
	bgt $t4, 4, print_heart_5
	j control_prelude
	
print_heart_5:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	addi $t1, $t1, 256
	sw $t2, 68($t1)
	sw $t2, 76($t1)
	addi $t1, $t1, 256
	sw $t2, 68($t1)
	sw $t2, 72($t1)
	sw $t2, 76($t1)
	addi $t1, $t1, 256
	sw $t2, 72($t1)
	
control_prelude:
	
	li $t3, 0xffff0000	# Checking if a key was pressed
	lw $t4, 0($t3)
	beq $t4, 1, control
	beq $t9, 0x77, gravity
	bltz $s2, friction_slow_a_prelude
	j friction_slow_d_prelude	# If no buttons were pressed, then we reduce velocity (slow the player down)
	
### CONTROLS (VELOCITY)
	# Let $t3, $t4, $t5, $t6 be a TEMPORARY register for calculations in this label
	# Let 3, -3 be maximum velocities
control:
	lw $t4, 4($t3)		# Fetching button pressed
	beq $t4, 0x77, w_pressed
	beq $t4, 0x64, d_pressed
	beq $t4, 0x61, a_pressed
	beq $t4, 0x70, p_pressed
	beq $t4, 0x78, x_pressed
	
a_pressed:
	beq $s2, -4, side_collide	# Checking if max velocity
	addi $s2, $s2, -2	# Changing x velocity -- Let acceleration be 1 for simplicity
	
	la $t3, kirby_facing		# Changing kirby facing
	li $t4, 0
	sw $t4, 0($t3)
	
	# Reduce y velocities to make transition more seamless
	bltz $s3, neg_dy
	j pos_dy

d_pressed:
	beq $s2, 4, side_collide
	addi $s2, $s2, 2
	
	la $t3, kirby_facing		# Changing kirby facing
	li $t4, 1
	sw $t4, 0($t3)
	
	# Reduce y velocities to make transition more seamless
	bltz $s3, neg_dy
	j pos_dy

w_pressed:	
	bnez $s3, gravity	# Cannot jump again until reaches the ground
	addi $s3, $s3, -11	# Changing y velocity "Jumping"
	j gravity
	
x_pressed:
	la $t3, kirby_attack_frames		# Kickstarting attack frames
	lw $t4, 0($t3)
	addi $t4, $t4, -100
	sw $t4, 0($t3)
	
	j object_collide_prelude
	
p_pressed:
	j game_start
	
friction_slow_a_prelude:
	blez $s3, friction_slow_a
	j gravity 

friction_slow_a:
	beqz $s2, gravity		# Checking if velocity is already 0
	addi $s2, $s2, 1
	j gravity
	
friction_slow_d_prelude:
	blez $s3, friction_slow_d
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
	li $s0, 56
	li $t5, -1
	mult $s2, $t5	# Bounce off edge
	mflo $s2
	
side_collide_2:
	bge $s0, 4, floor_collide
	li $s0, 4
	li $t5, -1
	mult $s2, $t5	# Bounce off edge
	mflo $s2

	# Let $t3, $t4, $t5, $t6 be a TEMPORARY register for calculations in this label
	# We want to check (p.x, p.y + 8) and (p.x + 6, p.y + 8) and see if either are white
floor_collide:
	# Checking (p.x, p.y + 8)
	sll $t3, $s0, 2 	# $t3 = p.x * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = p.x * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	addi $t3, $s1, 6	# $t3 = p.y + 6
	mult $t3, $t4		# $t3 = (p.y + 6) * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = p.x * 4 + (p.y + 6) * 256
	add $t1, $t0, $t1	# $t1 = base address + (p.x * 4 + (p.y + 6) * 256)
	
	lw $t4, 0($t1)		# Loading the colour to $t4
	beq $t4, 0x00d2e2e4, floor_collided
	
	# Checking (p.x + 7, p.y + 8)
	addi $t3, $s0, 6	# $t3 = p.x + 6
	sll $t3, $t3, 2 	# $t3 = (p.x + 6) * 4 = p.x * pixel size
	addi $t1, $t3, 0	# $t1 = (p.x + 6) * 4
	
	li $t4, 256		# $t4 = 256 = screen width
	addi $t3, $s1, 0	# $t3 = p.y
	addi $t3, $s1, 6	# $t3 = p.y + 6
	mult $t3, $t4		# $t3 = (p.y + 6) * 256
	mflo $t3
	
	add $t1, $t3, $t1	# $t1 = (p.x + 6) * 4 + (p.y + 6) * 256
	add $t1, $t0, $t1	# $t1 = base address + ((p.x + 6)  * 4 + (p.y + 6) * 256)
	
	lw $t4, 0($t1)		# Loading the colour to $t4
	beq $t4, 0x00d2e2e4, floor_collided
	
	j enemy_move_prelude_pre
	
floor_collided:
	bltz $s3, enemy_move_prelude_pre
	li $s3, 0			# Changing velocity to 0 if it is at the bottom

### MOVING ENEMIES
enemy_move_prelude_pre:

	la $t7, enemy_1_data
	jal move_enemy_prelude
	la $t7, enemy_2_data
	jal move_enemy_prelude
	la $t7, enemy_3_data
	jal move_enemy_prelude
	
	j enemy_collide_prelude

	# Let $t7, and $t8 hold enemy data
	# Let $t5, $t6 be a TEMPORARY VARIABLES for calculations
move_enemy_prelude:	
	lw $t8, 0($t7)		# $t8 = e1.x
	lw $t5, 8($t7)		# $t5 = e1.dx	

	bge $t8, 56, flip_enemy
	ble $t8, 4, flip_enemy
	
	j move_enemy
	
flip_enemy:
	li $t6, -1
	mult $t5, $t6
	mflo $t5		# t5 = -e1.dx
	sw $t5, 8($t7)		# Saving new e1.dx in memory

move_enemy:
	add $t8, $t8, $t5	# $t8 = e1.x + e1.dx
	
	sw $t8, 0($t7)		# Saving new e1.x in memory
	jr $ra

### ENEMY COLISSIONS

	# Let $t7, and $t8 hold enemy data
	# Let $t3, $t4, $t5, $t6 be a TEMPORARY VARIABLES for calculations

enemy_collide_prelude:
	la $t7, enemy_1_data 	
	la $t8, enemy_1_data
	jal check_x
	la $t7, enemy_2_data
	jal check_x
	la $t7, enemy_3_data
	jal check_x
	
	j enemy_1_collide_prelude	# TO-DO: Delete later

check_x:
	lw $t3,0($t7)		# Let $t3 = e.x
	lw $t4,4($t7)		# Let $t4 = e.y
	addi $t5, $s0, 6	# Let $t5 = p.x + 6
	addi $t6, $t3, 6	# Let $t6 = e.x + 6	
	
	ble $s0, $t6, e_before_p	# If p.x < e.x + 6
	jr $ra			
	
e_before_p:	
	ble $t3, $s0, check_velocity_left		# If e.x < p.x 
	
p_before_e_prelude:
	ble $t3, $t5, p_before_e	# If e.x < p.x + 6
	jr $ra

p_before_e:
	ble $s0, $t3, check_velocity_right		# If p.x < e.x
	jr $ra
	
check_velocity_left:
	blez $s2, y_check
	jr $ra
	
check_velocity_right:
	bgez $s2, y_check
	jr $ra

y_check:
	addi $t5, $s1, 6	# Let $t5 = p.y + 6
	addi $t6, $t4, 6	# Let $t6 = e.y + 6

	ble $s1, $t6, p_above_e	# If p.y < e.y + 6
	jr $ra
	
p_above_e:
	bge $s1, $t4, check_velocity_down	# If p.y < e.y
		
e_above_p_prelude:
	ble $t4, $t5, e_above_p	# If e.y < p.y + 6
	jr $ra

e_above_p:
	bge $t4, $s1, check_velocity_down	# If e.y < p.y
	jr $ra
	
check_velocity_down:
	j enemy_collide

enemy_collide:
	
	li $t4, -1	# Making bounce	
	mult $s2, $t4
	mflo $s2
	
reduce_health:
	la $t1, kirby_health	# Reducing health
	lw $t2, 0($t1)		
	la $t3, kirby_invincible_frames
	lw $t4, 0($t3)
	
	blt $t4, 2000, gravity_bounce
	
	addi $t2, $t2, -1	# Updating health
	sw $t2, 0($t1)
	addi $t4, $t4, -100	# Kickstarting invincibility frames
	sw $t4, 0($t3)

gravity_bounce:
	ble $s3, -3, enemy_stop_prelude
	addi $s3, $s3, -3

enemy_stop_prelude:	
	beq $t7, $t8, enemy_stop
	jr $ra		

enemy_stop:
	li $t4, -1
	lw $t5, 8($t7)
	mult $t5, $t4
	mflo $t5	
	sw $t5, 8($t7)		# Flipping enemy velocity
	
	jr $ra
	
enemy_1_collide_prelude:
	la $t7, enemy_1_data
	jal check_x_e1
	
	j move_player
	
check_x_e1:
	lw $t3,0($t7)		# Let $t3 = e.x
	lw $t4,4($t7)		# Let $t4 = e.y
	addi $t5, $s0, 6	# Let $t5 = p.x + 6
	addi $t6, $t3, 6	# Let $t6 = e.x + 6	
	
	ble $s0, $t6, e1_before_p	# If p.x < e.x + 6
	jr $ra			
	
e1_before_p:	
	ble $t3, $s0, y_check_e1		# If e.x < p.x 
	
p_before_e1_prelude:
	ble $t3, $t5, p_before_e1	# If e.x < p.x + 6
	jr $ra

p_before_e1:
	ble $s0, $t3, y_check_e1	# If p.x < e.x
	jr $ra

y_check_e1:
	addi $t5, $s1, 6	# Let $t5 = p.y + 6
	addi $t6, $t4, 6	# Let $t6 = e.y + 6

	ble $s1, $t6, e1_above_p	# If p.y < e.y + 6
	ble $t4, $t5, p_above_e1	# If e.y < p.y + 6
	jr $ra
	
p_above_e1:
	bge $t4, $s1, enemy1_collide	# If e.y < p.y
	jr $ra

e1_above_p:
	bge $s1, $t4, enemy1_collide	# If p.y < e.y
	jr $ra

enemy1_collide:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	li $t2, 0x00e23131		# 2nd LAYER of screen
	
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 8($t1)
	sw $t2, 12($t1)
	sw $t2, 16($t1)
	
	beq $t7, $t8, enemy1_stop
	jr $ra

enemy1_stop:
	li $t4, -1
	lw $t5, 8($t7)
	mult $t5, $t4
	mflo $t5	
	sw $t5, 8($t7)
	
	jr $ra
	

	# Let $t7, and $t8 hold enemy data
	# Let $t3, $t4, $t5, $t6, $s6, $s7 be a TEMPORARY VARIABLES for calculations
object_collide_prelude:
	la $t3, kirby_facing
	lw $t4, 0($t3)
	beq $t4, 1, object_collide_right
	j object_collide_left

object_collide_left:
	la $t7, enemy_1_data	
	addi $s6, $s0, -4	# Let $s6 = p.x - 4
	jal check_x_object
	
	la $t7, enemy_2_data	
	addi $s6, $s0, -4	# Let $s6 = p.x - 4
	jal check_x_object
	
	la $t7, enemy_3_data
	addi $s6, $s0, -4	# Let $s6 = p.x - 4
	jal check_x_object
	
	j gravity

object_collide_right:
	la $t7, enemy_1_data	
	addi $s6, $s0, 6	# Let $s6 = p.x + 6
	jal check_x_object
	
	la $t7, enemy_2_data	
	addi $s6, $s0, 6	# Let $s6 = p.x + 6
	jal check_x_object
	
	la $t7, enemy_3_data
	addi $s6, $s0, 6	# Let $s6 = p.x + 6
	jal check_x_object
	
	j gravity

check_x_object:
	lw $t3,0($t7)		# Let $t3 = e.x
	lw $t4,4($t7)		# Let $t4 = e.y
	addi $t5, $s6, 6	# Let $t5 = p.x + 6
	addi $t6, $t3, 6	# Let $t6 = e.x + 6	
	
	ble $s6, $t6, p_before_o	# If p.x < e.x + 6
	ble $t3, $t5, o_before_p	# If e.x < p.x + 6
	jr $ra			
	
p_before_o:
	bge $t5, $t3, y_check_object		# If e.x < p.x + 6
	jr $ra
	
o_before_p:	
	bge $t6, $s6, y_check_object		# If p.x < e.x + 6
	jr $ra

y_check_object:
	addi $t5, $s1, 6	# Let $t5 = p.y + 6
	addi $t6, $t4, 6	# Let $t6 = e.y + 6

	ble $s1, $t6, o_above_p	# If p.y < e.y + 6
	ble $t4, $t5, p_above_o	# If e.y < p.y + 6
	jr $ra
	
p_above_o:
	bge $t4, $s1, object_collide	# If e.y < p.y
	jr $ra

o_above_p:
	bge $s1, $t4, object_collide	# If p.y < e.y
	jr $ra

object_collide:
	li $t1, BASE_ADDRESS		# $t1 = BASE_ADDRESS
	li $t2, 0x00e23131		# 2nd LAYER of screen
	
	sw $t2, 24($t1)
	sw $t2, 28($t1)
	sw $t2, 32($t1)
	sw $t2, 36($t1)
	sw $t2, 40($t1)
	
	li $t2, 1000			# Setting enemy out of bounds
	sw $t2, 0($t7)
	sw $t2, 4($t7)
	li $t2, 0
	sw $t2, 8($t7)			# Stopping any enemies
	sw $t2, 12($t7)
	sw $t2, 20($t7)			# Branding enemy as dead
	
					# Starting cooldown until enemy respawns
	lw $t2, 24($t7)
	addi $t2, $t2, -100
	sw $t2, 24($t7)
	
	j gravity

### MOVING PLAYER

move_player:
	add $s0, $s2, $s0	# Moving player based on velocity
	add $s1, $s3, $s1
	
	addi $t9, $t4, 0	# Keeping track

go_back:
	j loop
exit: 
	li $v0, 10 # terminate the program gracefully
	syscall

