extends ColorRect

# Node ref 
@onready var value = $Value
# Update ui 
func update_stamina_pickup_ui(stamina_pickup):
	
	print("Stamina val:" + str(stamina_pickup))
	value.text = str(stamina_pickup)


