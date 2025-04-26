extends Area2D

var damage = 150
var can_attack = false
@onready var timer = $attack_time
@onready var area = $"."
func _ready() -> void:
	timer.start()
	can_attack = true
	
	
func _process(delta: float) -> void:
	if can_attack:
		for body in area.get_overlapping_bodies():
			if body.is_in_group("enemies") and body.has_method("take_damage"):
				body.take_damage(damage)
				



func _on_attack_time_timeout() -> void:
	can_attack = false
	queue_free()
