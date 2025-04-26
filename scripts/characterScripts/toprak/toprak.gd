extends CharacterBody2D

var damage = 150
var armor = 25
var health = 1000
var target_position :Vector2
var can_use_skill_1 = true
var canmove = true
var hurt = false
var dead = false
var skill_range = 56
var can_use_skill_2 = true


@export var movement_speed = 50
@onready var skill2timer = $skill2timer
@onready var armor_timer = $zirh_timer
@onready var skill1_timer = $skill1timer
@onready var animated_sprite = $AnimatedSprite2D
@onready var hurttimer = $hurttimer
@onready var deathtimer = $DeathTimer
@onready var attack_area = $baseattack
@onready var sars = preload("res://scenes/characters/sars.tscn")

func _ready() -> void:
	add_to_group("player")
	Gb.current_mode = "soil"
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ATTACK"):
		attack()
	if Input.is_action_just_pressed("SKILL1") and can_use_skill_1:
		use_skill_1()
	if Input.is_action_just_pressed("SKILL2") and can_use_skill_2:
		var mouse_pos = get_global_mouse_position()
		if is_valid_mouse_position(mouse_pos):
			var s = sars.instantiate()
			s.global_position = mouse_pos
			add_child(s)
			can_use_skill_2 = false
			skill2timer.start()
func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
func attack():
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
func use_skill_1():
		print("armor 75 e yükseldi")
		armor = 75
		can_use_skill_1 = false
		armor_timer.start()
		skill1_timer.start()
func move():
	if canmove and not dead:
		var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
		if velocity == Vector2.ZERO :
				animated_sprite.play("idle")
		else:
			if movement_direction.x < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			animated_sprite.play("walk")
		
		velocity = movement_direction * movement_speed
func take_damage(damage):
	if health > 0:
		health -= damage - (damage * (float(armor) / 100.0))
		animated_sprite.play("get_damage")
		print("player health : ",health)
	else:
		animated_sprite.play("die")
		deathtimer.start()
func _on_zirh_timer_timeout() -> void:
	print("armor 25e düşürüldü")
	armor = 25
func _on_skill_1_timer_timeout() -> void:
	can_use_skill_1 = true
func _on_death_timer_timeout() -> void:
	queue_free()
func is_valid_mouse_position(pos):
	return self.position.distance_to(pos) <= skill_range	
func _on_skill_2_timer_timeout() -> void:
	can_use_skill_2= true
