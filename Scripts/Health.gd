extends ColorRect

# node refs
@onready var value = $Value

# update UI
func update_health_ui(health,maxhealth):
	value.size.x = 98 * health / maxhealth

