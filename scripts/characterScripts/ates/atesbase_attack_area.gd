extends Area2D

var damage = 150
@onready var attackArea = $"."
@onready var attack_timer = $attack_timer

func ready():
	add_to_group("attack_area")
	
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	rotation += deg_to_rad(90)
	

	


func _on_body_entered(body: Node2D) -> void:
		print("attacking")
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				if AtesGlobal.attacking and AtesGlobal.can_attack:
					body.take_damage(damage)
					AtesGlobal.attacking = false
					AtesGlobal.can_attack = false
					attack_timer.start()
	
		


func _on_attack_timer_timeout() -> void:
	AtesGlobal.can_attack = true
