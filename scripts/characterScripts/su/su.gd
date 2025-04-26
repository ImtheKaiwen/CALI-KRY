extends CharacterBody2D

var health = 250
var can_use_skill1 = true
var can_use_skill2 = true

var movement_speed = 200
@onready var skill1_timer = $skill1_timer
@onready var skill2_timer = $skill2_timer
@onready var arrow_scene = preload("res://scenes/characters/ok.tscn")
@onready var ulti_scene = preload("res://scenes/characters/sultisi.tscn")
func _ready() -> void:
	add_to_group("player")
	Gb.current_mode = "water"



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SKILL2") and can_use_skill2:
		use_ult()
		can_use_skill2 = false
		skill2_timer.start()
	if Input.is_action_just_pressed("ATTACK"):
		shoot_arrow()
	heal()
	
func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
func heal():
	if Input.is_action_just_pressed("SKILL1") and can_use_skill1:
		if health + 150 > 250:
			health = 250
		else:
			health+= 150
		print("skill-1 kullanıldı")
		print("new health : ",health)
		can_use_skill1 = false
		
		skill1_timer.start()
		
func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	var mouse_pos =  get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	arrow.global_position = global_position
	arrow.set_direction(direction)
	
	get_tree().current_scene.add_child(arrow)
	
	
func use_ult():
	var ult = ulti_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	ult.global_position = global_position
	ult.set_direction(direction)
	get_tree().current_scene.add_child(ult)
	
func take_damage(damage):
	if health > 0:
		health -= damage
		print("health : ",health)
	else:
		queue_free()	
	
func move():
	var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	velocity = movement_direction * movement_speed

func _on_skill_1_timer_timeout() -> void:
	print("skill-1 tekrar kullanılabilir")
	can_use_skill1 = true


func _on_skill_2_timer_timeout() -> void:
	print("ulti kullanılabilir")
	can_use_skill2 = true
	
