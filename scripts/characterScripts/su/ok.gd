extends Area2D


var damage = 100
@export var speed = 500
var direction : Vector2 = Vector2.ZERO
@onready var timer = $Timer
func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta
	
func _ready() -> void:
	timer.start()
	

func set_direction(dir:Vector2):
		direction = dir
		rotation = dir.angle()
		



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()


func _on_timer_timeout() -> void:
	queue_free()
