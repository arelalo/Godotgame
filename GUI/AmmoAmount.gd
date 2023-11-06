extends ColorRect

 # Node ref
@onready var value = $Value

	# Update ui
func update_ammo_pickup_ui(ammo_pickup):
		value.text = str(ammo_pickup)
