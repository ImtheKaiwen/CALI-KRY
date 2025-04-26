extends CharacterBody2D

var health = 250
var movement_speed = 200
var can_use_skill1 = true
var dash_distance = 89
var can_use_skill2 = true
@onready var arrow_scene = preload("res://scenes/characters/ok.tscn")
@onready var storm_scene = preload("res://scenes/characters/fırtına.tscn")
@onready var dash_area = $dash
@onready var dash_timer = $dash/dashtimer
@onready var fırtına_timer = $"fırtına_timer"
func _ready() -> void:
	add_to_group("player")
	Gb.current_mode = "weather"
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SKILL2") and can_use_skill2:
		shoot_storm()
		print("fırtına gönderildi")
		can_use_skill2 = false
		fırtına_timer.start()
	if Input.is_action_just_pressed("SKILL1") and can_use_skill1:
		var mouse_pos = get_global_mouse_position()
		if is_in_dash_range(mouse_pos):
			var tween = create_tween()
			tween.tween_property(self, "position", get_global_mouse_position(), 0.1)	
			can_use_skill1 = false
			dash_timer.start()
			
	if Input.is_action_just_pressed("ATTACK"):
		shoot_arrow()
		print("ok fırlatıldı")
	
func is_in_dash_range(position):
	return self.position.distance_to(position) <= dash_distance
func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
func move():
	var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	velocity = movement_direction * movement_speed

func shoot_storm():
	var st = storm_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	st.global_position = global_position
	st.set_direction(direction)
	get_tree().current_scene.add_child(st)
	print("ok fırlatıldı")
func shoot_arrow():
	var ok = arrow_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	ok.global_position = global_position
	ok.set_direction(direction)
	get_tree().current_scene.add_child(ok)
	print("ok fırlatıldı")
	


func _on_dashtimer_timeout() -> void:
	print("dash yeniden kullanılabilir")
	can_use_skill1 = true


func _on_fırtına_timer_timeout() -> void:
	print("fırtına yeteneği kullanılabilir")
	can_use_skill2 = true
