extends Area2D

var range = 75
var damage = 100
@export var speed = 500
var direction : Vector2 = Vector2.ZERO
@onready var timer = $Timer
var fist_position :Vector2


	
func _process(delta: float) -> void:
	if fist_position.distance_to(global_position) > 71:
		queue_free()
	if direction != Vector2.ZERO:
		position += direction * speed * delta
	
func _ready() -> void:
	timer.start()
	fist_position = global_position
	

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
