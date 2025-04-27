extends CharacterBody2D

var health = 250
var can_use_skill1 = true
var can_use_skill2 = true
var attacking = false
var hurt = false
var skill1_used = false
var skill2_used = false
var movement_speed = 200
@onready var skill1_timer = $skill1_timer
@onready var skill2_timer = $skill2_timer
@onready var arrow_scene = preload("res://scenes/characters/ok.tscn")
@onready var ulti_scene = preload("res://scenes/characters/sultisi.tscn")
@onready var animated_sprite = $AnimatedSprite2D
func _ready() -> void:
	add_to_group("player")
	Gb.current_mode = "water"



func _process(delta: float) -> void:
	update_position()
	if Input.is_action_just_pressed("SKILL2") and can_use_skill2:
		use_ult()
		can_use_skill2 = false
		skill2_timer.start()
	if Input.is_action_just_pressed("ATTACK"):
		attacking = true
		shoot_arrow()
	else:
		attacking = false
		
	heal()
	
func _physics_process(delta: float) -> void:
	update_animation_state()
	move()
	move_and_slide()
@onready var skil1usedtimer = $skil1used
@onready var hurttimer = $hurt
func heal():
	if Input.is_action_just_pressed("SKILL1") and can_use_skill1:
		skill1_used = true
		skil1usedtimer.start()
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
	
func apply_knockback(force: Vector2):
	velocity += force
func update_position():
	Gb.last_seen_position = global_position	
	
@onready var skil2usedtimer = $skil2used
func use_ult():
	skill2_used = true
	skil2usedtimer.start()
	var ult = ulti_scene.instantiate()
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	ult.global_position = global_position
	ult.set_direction(direction)
	get_tree().current_scene.add_child(ult)
	
func take_damage(damage):
	hurt = true
	hurttimer.start()
	health -= damage
	if health <= 0:
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
	
	
func update_animation_state():
	if velocity.length()!=0:
		if not attacking and not hurt and not skill1_used:
			if velocity.x < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			animated_sprite.play("walk")
		elif attacking:
			animated_sprite.play("attack")
		elif  hurt:
			animated_sprite.play("get_attack")
		elif  skill1_used:
			animated_sprite.play("heal")
		elif skill2_used:
			animated_sprite.play("attack")
		else :
			animated_sprite.play("idle")


func _on_skil_1_used_timeout() -> void:
	skill1_used = false


func _on_skil_2_used_timeout() -> void:
	skill2_used = false


func _on_hurt_timeout() -> void:
	hurt = false
