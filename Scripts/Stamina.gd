extends ColorRect

# node refs
@onready var value = $Value

# update UI
func update_stamina_ui(stamina,maxstamina):
	value.size.x = 98 * stamina / maxstamina
