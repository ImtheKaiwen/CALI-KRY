extends Area2D


var damage = 1000
var speed = 500
var start_pos :Vector2
var direction : Vector2 = Vector2.ZERO
func _ready() -> void:
	start_pos = global_position
	
func _process(delta: float) -> void:
	if start_pos.distance_to(global_position) > 180:
		queue_free()
	if direction != Vector2.ZERO:
		position += direction * speed * delta
	
func set_direction(dir:Vector2):
		direction = dir
		rotation = dir.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
