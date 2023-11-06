@tool

extends Area2D


# Pickups to choose from 
enum Pickups { AMMO, STAMINA, HEALTH } 
@export var item : Pickups

# Node refs 
@onready var sprite = $Sprite2D

# Texture assets/resources 
var ammo_texture = preload("res://Assets/Icons/shard_01i.png") 
var stamina_texture = preload("res://Assets/Icons/potion_02c.png") 
var health_texture = preload("res://Assets/Icons/potion_02a.png")
#allow us to change the icon in the editor 

func _process(_delta): 
	#executes the code in the editor without running the game 
	if Engine.is_editor_hint(): 
		#if we choose x item from Inspector dropdown, change the texture 
		if item == Pickups.AMMO:
			sprite.set_texture(ammo_texture) 
		elif item == Pickups.HEALTH: 
			sprite.set_texture(health_texture) 
		elif item == Pickups.STAMINA: 
			sprite.set_texture(stamina_texture)

func _ready():
#executes the code in the game 
	if not Engine.is_editor_hint(): 
		#if we choose x item from Inspector dropdown, change the texture 
		if item == Pickups.AMMO: 
			sprite.set_texture(ammo_texture) 
		elif item == Pickups.HEALTH: 
			sprite.set_texture(health_texture) 
		elif item == Pickups.STAMINA: 
			sprite.set_texture(stamina_texture)


func _on_body_entered(body):
	#pass # Replace with function body.
	if body.name == "Player":
		body.add_pickup(item)
		get_tree().queue_delete(self)
