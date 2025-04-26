extends Area2D

var skill_distance = 90
var damage = 150
var can_hit = false
var can_use = true
var enemies_in_area = []
@onready var skill_timer = $skill_time
@onready var damage_timer = $damage_time
@onready var timer = $cooldown
@onready var area = $"."
@onready var coll = $sars_collision
@onready var skill_range = $"../toprak/skill_range"

func _ready() -> void:
	area.visible = false
	coll.disabled = true

	
func _process(delta: float) -> void:
	print(get_global_mouse_position())
	attack()
	if can_hit and enemies_in_area:
			for body in enemies_in_area:
				if body and body.has_method("take_damage"):
					body.take_damage(damage)
					print("hasar verildi ->","-",damage)
			can_hit = false
			timer.start()
			
func attack():
	if Input.is_action_just_pressed("SKILL2") and can_use:
		var mouse_position = get_global_mouse_position()
		if is_valid_mouse_pos(mouse_position):
			area.global_position = mouse_position
			area.visible = true
			coll.disabled = false
			can_hit = true
			can_use = false
			damage_timer.start()
			skill_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			enemies_in_area.append(body)
		
			
			
func _on_cooldown_timeout() -> void:
	can_hit = true

func _on_damage_time_timeout() -> void:
	area.visible = false
	coll.disabled = true
	can_hit = false
	enemies_in_area = []
	

func is_valid_mouse_pos(pos):
	return self.position.distance_to(pos) <= skill_distance
func _on_skill_time_timeout() -> void:
	print("skill-2 yeniden kullanılabilir")
	can_use = true
