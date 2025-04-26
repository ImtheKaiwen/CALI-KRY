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

@onready var fire = preload("res://scenes/characters/ates.tscn")
@onready var water = preload("res://scenes/characters/su.tscn")
@onready var weather = preload("res://scenes/characters/hava.tscn")
@onready var soil = preload("res://scenes/characters/toprak.tscn")
@onready var light = preload("res://scenes/characters/light.tscn")

@onready var shine_scene = preload("res://scenes/characters/shine_line.tscn")
@onready var speed_of_light = $speed_of_light
@onready var shine = $shine
@onready var speed_timer = $speed
@onready var shinte_timer = $shine_time
func _ready():
	add_to_group("player")
	Gb.current_mode = "light"
	
	
	
func _process(delta: float) -> void:
	
		
	if Input.is_action_just_pressed("SKILL1") and can_use_speed_of_light:
		use_speed_of_light()
		can_use_speed_of_light = false
		speed_of_light.start()
		
	if Input.is_action_just_pressed("SKILL2") and can_use_shine:
		use_shine()
		can_use_shine = false
		shine.start()
		shinte_timer.start()
		
func use_speed_of_light():
	print("speed_of_light active")
	speed += 300
	speed_timer.start()
		
	
func swap(scene):
	var f = scene.instantiate()
	f.global_position = self.global_position
	get_parent().add_child(f)
	queue_free()
	
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
	
