extends CharacterBody2D

var armor = 25
var health = 1000
var target_position :Vector2
var can_use_skill_1 = true

@export var movement_speed = 50
@onready var armor_timer = $zirh_timer
@onready var skill1_timer = $skill1timer

func _ready() -> void:
	add_to_group("player")
	Gb.current_mode = "soil"
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SKILL1") and can_use_skill_1:
		use_skill_1()
func _physics_process(delta: float) -> void:
	move()
	move_and_slide()

func use_skill_2():
	pass
func use_skill_1():
		print("armor 75 e yükseldi")
		armor = 75
		can_use_skill_1 = false
		armor_timer.start()
		skill1_timer.start()
	
func move():
	var movement_direction = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	velocity = movement_direction * movement_speed
	
func take_damage(damage):
	if health > 0:
		health -= damage - (damage * (float(armor) / 100.0))
		print("player health : ",health)
	else:
		queue_free()

func _on_zirh_timer_timeout() -> void:
	print("armor 25e düşürüldü")
	armor = 25

func _on_skill_1_timer_timeout() -> void:
	can_use_skill_1 = true
