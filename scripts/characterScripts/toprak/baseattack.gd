extends Area2D

func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	rotation += deg_to_rad(90)
