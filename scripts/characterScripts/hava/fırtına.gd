extends Area2D

var speed = 500
var damage = 600
var slow_rate = 20

var direction : Vector2 = Vector2.ZERO
var canmove = false
@onready var timer = $Timer
@onready var wait = $wait
func _process(delta: float) -> void:
	if canmove:
		if direction != Vector2.ZERO:
			position += direction * speed * delta
@onready var animated_sprite = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite.play("idle")
	timer.start()
	wait.start()

func set_direction(dir:Vector2):
		direction = dir
		rotation = dir.angle()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		if body.has_method("get_slow"):
			body.get_slow(slow_rate,3)
			print("yavaşladı")
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_wait_timeout() -> void:
	canmove = true
	
