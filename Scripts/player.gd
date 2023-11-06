
### Player.gd

extends CharacterBody2D

# Custom signals 
signal health_updated 
signal stamina_updated
signal ammo_pickups_updated 
signal health_pickups_updated 
signal stamina_pickups_updated

# Node references
@onready var animation_sprite = $AnimatedSprite2D
@onready var health_var = $UI/HealthBar
@onready var stamina_var = $UI/StaminaBar
@onready var ammo_amount = $UI/AmmoAmount 
@onready var stamina_amount = $UI/StaminaAmount 
@onready var health_amount = $UI/HealthAmount

# UI variables 
var health = 100 
var max_health = 100 
var regen_health = 1 
var stamina = 100 
var max_stamina = 100 
var regen_stamina = 5

# Pickups 
enum Pickups { AMMO, STAMINA, HEALTH } 
var ammo_pickup = 0 
var health_pickup = 0 
var stamina_pickup = 0

# Player states
@export var speed = 50
var is_attacking = false

#direction and animation to be updated throughout game state
var new_direction = Vector2(0,1) #only move one spaces
var animation

# --------------------------------- Movement & Animations -----------------------------------
func _physics_process(delta):
	# Get player input (left, right, up/down)
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# Normalize movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	# Sprinting          
	if Input.is_action_pressed("ui_sprint"):
		if stamina >= 25: 
			speed = 100 
			stamina = stamina - 5 
			stamina_updated.emit(stamina, max_stamina)

	elif Input.is_action_just_released("ui_sprint"):
		speed = 50  
	# Apply movement if the player is not attacking
	var movement = speed * direction * delta
	if is_attacking == false:
		move_and_collide(movement)
		player_animations(direction)
	# If no input is pressed, idle
	if !Input.is_anything_pressed():
		if is_attacking == false:
			animation  = "Idle_" + returned_direction(new_direction)	
			
func _input(event):
	#input event for our attacking, i.e. our shooting
	if event.is_action_pressed("ui_attack"):
		#attacking/shooting anim
		is_attacking = true
		animation  = "Attack_" + returned_direction(new_direction)
		animation_sprite.play(animation)

# Animation Direction
func returned_direction(direction : Vector2):
	#it normalizes the direction vector to make sure it has length 1 (1, or -1 up, down, left, and right) 
	var normalized_direction  = direction.normalized()
	var default_return = "side"
	
	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		#(right)
		$AnimatedSprite2D.flip_h = false
		return "side"
	elif normalized_direction.x < 0:
		#flip the animation for reusability (left)
		$AnimatedSprite2D.flip_h = true
		return "side"
		
	#default value is empty
	return default_return
	
# Animations
func player_animations(direction : Vector2):
	#Vector2.ZERO is the shorthand for writing Vector2(0, 0).
	if direction != Vector2.ZERO:
		#update our direction with the new_direction
		new_direction = direction
		#play walk animation, because we are moving
		animation = "Walk_" + returned_direction(new_direction)
		animation_sprite.play(animation)
	else:
		#play idle animation, because we are still
		animation  = "Idle_" + returned_direction(new_direction)
		animation_sprite.play(animation)

# Reset Animation states
func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
	
func _ready(): 
		# Connect the signals to the UI components' functions 
		health_updated.connect(health_var.update_health_ui) 
		stamina_updated.connect(stamina_var.update_stamina_ui)
		ammo_pickups_updated.connect(ammo_amount.update_ammo_pickup_ui) 
		health_pickups_updated.connect(health_amount.update_health_pickup_ui) 
		stamina_pickups_updated.connect(stamina_amount.update_stamina_pickup_ui)
	# ------------------------- UI -------------------------------------------------- 
func _process(delta): #regenerates health 
	var updated_health = min(health + regen_health * delta, max_health) 
	if updated_health != health: 
		health = updated_health 
		health_updated.emit(health, max_health) 
		
#regenerates stamina 
	var updated_stamina = min(stamina + regen_stamina * delta, max_stamina) 
	if updated_stamina != stamina: 
		stamina = updated_stamina 
		stamina_updated.emit(stamina, max_stamina)

# Add the pickup to our GUI-based inventory 
func add_pickup(item): 
	if item == Pickups.AMMO: 
		ammo_pickup = ammo_pickup + 3 # + 3 bullets 
		ammo_pickups_updated.emit(ammo_pickup) 
		print("ammo val:" + str(ammo_pickup)) 
	if item == Pickups.HEALTH: 
		health_pickup = health_pickup + 1 # + 1 health drink 
		health_pickups_updated.emit(health_pickup) 
		print("health val:" + str(health_pickup)) 
	if item == Pickups.STAMINA: 
		stamina_pickup = stamina_pickup + 1 # + 1 stamina drink
		stamina_pickups_updated.emit(stamina_pickup) 
		print("stamina val:" + str(stamina_pickup))
