extends CharacterBody2D

var health = 250
var movement_speed = 200
var can_use_skill1 = true
var dash_distance = 89
var can_use_skill2 = true

var attacking = false
var hurt = false
var skill1_used = false
var skill2_used = false

@onready var arrow_scene = preload("res://scenes/characters/ok.tscn")
@onready var storm_scene = preload("res://scenes/characters/fırtına.tscn")
@onready var dash_area = $dash
@onready var dash_timer = $dash/dashtimer
@onready var fırtına_timer = $"fırtına_timer"
@onready var animated_sprite = $AnimatedSprite2D
func _ready() -> void:
	add_to_group("player")
	Gb.current_mode = "weather"
	
@onready var skil1usedtimer = $skil1used
func _process(delta: float) -> void:
	update_animation_state()
	update_position()
	if Input.is_action_just_pressed("SKILL2") and can_use_skill2:
		shoot_storm()
		print("fırtına gönderildi")
		can_use_skill2 = false
		fırtına_timer.start()
	if Input.is_action_just_pressed("SKILL1") and can_use_skill1:
		var mouse_pos = get_global_mouse_position()
		if is_in_dash_range(mouse_pos):
			skill1_used = true
			skil1usedtimer.start()
			var tween = create_tween()
			tween.tween_property(self, "position", get_global_mouse_position(), 0.1)	
			can_use_skill1 = false
			dash_timer.start()
			
	if Input.is_action_just_pressed("ATTACK"):
		attacking = true
		shoot_arrow()
		print("ok fırlatıldı")
	else:
		attacking = false
	
func is_in_dash_range(position):
	return self.position.distance_to(position) <= dash_distance
func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
func move():
	var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	velocity = movement_direction * movement_speed
	
@onready var skil2usedtimer = $skil2used
func shoot_storm():
	skill2_used = true
	skil2usedtimer.start()
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
	
func apply_knockback(force: Vector2):
	velocity += force

func update_position():
	Gb.last_seen_position = global_position
@onready var hurttimer = $hurttimer
func take_damage(damage):
	hurt = true
	hurttimer.start()
	health -= damage
	if health <= 0:
		queue_free()
func _on_dashtimer_timeout() -> void:
	print("dash yeniden kullanılabilir")
	can_use_skill1 = true

func update_animation_state():
	if velocity.length()!=0:
		if not attacking and not hurt and not skill2_used:
			if velocity.x < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			animated_sprite.play("walk")
		elif attacking:
			animated_sprite.play("attack")
		elif  hurt:
			animated_sprite.play("get_damage")
		elif skill2_used:
			animated_sprite.play("ulti")
		else :
			animated_sprite.play("idle")

func _on_fırtına_timer_timeout() -> void:
	print("fırtına yeteneği kullanılabilir")
	can_use_skill2 = true


func _on_hurttimer_timeout() -> void:
	hurt = false


func _on_skil_2_used_timeout() -> void:
	skill2_used = false


func _on_skil_1_used_timeout() -> void:
	skill1_used = false
	
