extends Area2D

var speed = 500
var damage = 600
var slow_rate = 20
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
		if body.has_method("get_slow"):
			body.get_slow(slow_rate)
			print("yavaşladı")
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
