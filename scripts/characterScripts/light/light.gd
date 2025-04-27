extends CharacterBody2D

#temp
var state = "ates"


var health = 20000
var damage = 5000
var speed = 500
var can_use_speed_of_light = true
var can_use_shine = true
var can_move = true
var current_mode = "light"

var attacking = false
var hurt = false
var skill1_used = false
var skill2_user = false
var death = false

@onready var fire = preload("res://scenes/characters/ates.tscn")
@onready var water = preload("res://scenes/characters/su.tscn")
@onready var weather = preload("res://scenes/characters/hava.tscn")
@onready var soil = preload("res://scenes/characters/toprak.tscn")
@onready var light = preload("res://scenes/characters/light.tscn")
@onready var light_basic_attack = preload("res://scenes/characters/light_basic_attack.tscn")
@onready var shine_scene = preload("res://scenes/characters/shine_line.tscn")
@onready var speed_of_light = $speed_of_light
@onready var shine = $shine
@onready var speed_timer = $speed
@onready var shinte_timer = $shine_time
@onready var animated_sprite = $AnimatedSprite2D

func update_animation_state():
	if velocity.length()!=0:
		if not attacking and not hurt and not skill1_used and skill2_user and skill2_user:
			if velocity.x < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
			animated_sprite.play("walk")
		elif attacking:
			animated_sprite.play("attack")
		elif  hurt:
			animated_sprite.play("get_damage")
		elif  skill1_used:
			animated_sprite.play("skil1")
		elif skill2_user:
			animated_sprite.play("ulti")
		else :
			animated_sprite.play("idle")

@onready var hurttimer = $hurttimer
func _ready():
	add_to_group("player")
	Gb.current_mode = "light"
	
	

func take_damage(damage):
	hurt = true
	hurttimer.start()
	health -= damage
	if health <= 0:
		death = true
		queue_free()
		
func apply_knockback(force: Vector2):
	velocity += force

func _process(delta: float) -> void:
	update_animation_state()
	update_position()
	if Input.is_action_just_pressed("ATTACK"):
		attacking = true
		shoot_arrow()
	else:
		attacking = false
		
	if Input.is_action_just_pressed("SKILL1") and can_use_speed_of_light:
		use_speed_of_light()
		can_use_speed_of_light = false
		speed_of_light.start()
		
	if Input.is_action_just_pressed("SKILL2") and can_use_shine:
		skill2_user = true
		skil2used.start()
		use_shine()
		can_use_shine = false
		shine.start()
		shinte_timer.start()

@onready var skil1usedtimer = 	$skil1used	
func use_speed_of_light():
	skill1_used = true
	skil1usedtimer.start()
	print("speed_of_light active")
	speed += 300
	speed_timer.start()
		

func update_position():
	Gb.last_seen_position = global_position
func shoot_arrow():
	var arrow = light_basic_attack.instantiate()
	var mouse_pos =  get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	arrow.global_position = global_position
	arrow.set_direction(direction)
	
	get_tree().current_scene.add_child(arrow)
func swap(scene):
	var f = scene.instantiate()
	f.global_position = self.global_position
	get_parent().add_child(f)
	queue_free()
	
@onready var skil2used = $skil2used
func use_shine():
	
	can_move = false
	var shine_line = shine_scene.instantiate()
	get_parent().add_child(shine_line)
	
	var mouse_position = get_global_mouse_position()
	shine_line.global_position = global_position
	shine_line.look_at(mouse_position)
	print("shine used")
	
	
func move():
	if can_move:
		var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
		velocity = movement_direction * speed
	else:
		velocity = Vector2.ZERO

func _physics_process(delta):
	move()
	move_and_slide()


func _on_speed_of_light_timeout():
	print("speed_of_light ready")
	can_use_speed_of_light = true
	


func _on_speed_timeout() -> void:
	print("speed_of_light ended")
	speed = 500


func _on_shine_timeout() -> void:
	print("shine ready")
	can_use_shine = true


func _on_shine_time_timeout() -> void:
	can_move = true
	


func _on_hurttimer_timeout() -> void:
	hurt = false


func _on_skil_1_used_timeout() -> void:
	skill1_used = false

func _on_skil_2_used_timeout() -> void:
	skill2_user = false
