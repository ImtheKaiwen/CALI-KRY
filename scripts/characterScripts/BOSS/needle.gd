extends Area2D

var speed = 400
var direction = Vector2.ZERO
var damage = 50

func _physics_process(delta):
	rotation = direction.angle()
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
