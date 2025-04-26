extends Area2D

var damage = 4000
var charge_time = 1.2
var duration_after_explode = 0.2

@onready var timer = $Timer

var exploded = false

func _ready() -> void:
	timer.wait_time = charge_time
	timer.start()
	
func _process(delta: float) -> void:
	if exploded:
		modulate.a -= delta * 5 
		


func _on_timer_timeout() -> void:
	if not exploded:
		explode()
		
func explode():
	exploded = true
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies") and body.has_method("take_damage"):
			body.take_damage(damage)
	timer.wait_time = duration_after_explode
	timer.start()


func _on_second_timeout() -> void:
	queue_free()
