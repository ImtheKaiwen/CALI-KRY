extends CharacterBody2D

var health = 100
var damage = 150
var dragon_scene = preload("res://scenes/characters/ates_ejderi.tscn")
var can_spawn_dragon = true
var attacking = false
var hurt = false
var skill1_used = false
var death = false

@export var movement_speed = 50
@onready var attack_cooldown = $attack_cooldown
@onready var spawn_timer = $dragon_spawner
@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_area = $baseAttackArea
@onready var attacking_timer = $attacking_timer

func _ready() -> void:
	add_to_group("player")
	animated_sprite.play("idle")
	pass
func _process(delta: float) -> void:
	print("character : ", global_position)
	updatepos()
	if Input.is_action_just_pressed("ATTACK"):
		print("attacking")
		attacking = true
		attack()
	else:
		attacking = false
		
	
	if Input.is_action_just_pressed("SKILL2"):
		skil2used.start()
		spawn_dragon()
		
	updatepos()
func _physics_process(delta: float) -> void:
	update_animation_state()
	move()
	move_and_slide()
func attack():
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(damage)
func move():
	var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	velocity = movement_direction * movement_speed
func spawn_dragon():
	if can_spawn_dragon:
		var dragon = dragon_scene.instantiate()
		get_parent().add_child(dragon)
		
		var offset = Vector2(50,0)
		dragon.global_position = global_position + offset
		print("skill-2 started (ejderha çağırıldı)")
		spawn_timer.start()
func updatepos() -> void:
	AtesGlobal.ates_position = global_position
	Gb.last_seen_position = global_position
	
@onready var hurttimer = $hurttimer
@onready var skil2used = $skil2used
func take_damage(damage):
	hurt = true
	hurttimer.start()
	health -= damage
	if health <= 0:
		death = true
func _on_dragon_spawner_timeout() -> void:
	can_spawn_dragon = true
	print("skill-2 yeniden kullanılabilir")
func update_pos():
	Gb.last_seen_position = global_position
func apply_knockback(force: Vector2):
	velocity += force


func update_animation_state():
	if velocity.length()!=0:
		if not attacking and not hurt and not AtesGlobal.skil1used:
			if velocity.x < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			animated_sprite.play("walk")
		elif attacking:
			animated_sprite.play("basic_attack")
		elif  hurt:
			animated_sprite.play("get_damage")
		elif  AtesGlobal.skil1used:
			animated_sprite.play("skill1")
		elif death:
			animated_sprite.play("die")
			await animated_sprite.animation_finished
			queue_free()
		else :
			animated_sprite.play("idle")


func _on_hurttimer_timeout() -> void:
	hurt = false


func _on_attacking_timer_timeout() -> void:
	attacking = false
