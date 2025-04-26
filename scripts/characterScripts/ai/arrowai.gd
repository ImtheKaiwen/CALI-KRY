extends Area2D

var target_distance = 110
var speed = 400
var damage = 150
var start_pos : Vector2
var direction : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if start_pos.distance_to(global_position) > target_distance:
		queue_free()
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _ready() -> void:
	start_pos = global_position
	
func set_direction(dir:Vector2):
		direction = dir
		rotation = dir.angle()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
