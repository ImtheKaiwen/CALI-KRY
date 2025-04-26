extends CharacterBody2D

var health = 1000

func _ready() -> void:
	add_to_group("enemies")

func take_damage(damage):
	
	if health > 0 and health > damage:
		health -= damage
		print("enemy health :",health)
	else:
		get_parent().queue_free()
		
		
func health_info():
	return health
