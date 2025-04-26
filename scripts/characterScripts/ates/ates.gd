extends CharacterBody2D

var health = 100
@export var movement_speed = 50
@onready var attack_cooldown = $attack_cooldown
@onready var spawn_timer = $dragon_spawner
@onready var sprite = $Sprite2D
var dragon_scene = preload("res://scenes/characters/ates_ejderi.tscn")
var can_spawn_dragon = true
func _ready() -> void:
	add_to_group("player")
	pass
	
	
func _process(delta: float) -> void:
	updateattack()
	updatepos()
	if Input.is_action_just_pressed("SKILL2"):
		spawn_dragon()

func _physics_process(delta: float) -> void:
	move()
	move_and_slide()
	
	
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

func updateattack():
	if Input.is_action_just_pressed("ATTACK"):
		AtesGlobal.attacking = true
	else:
		AtesGlobal.attacking = false
		
func updatepos() -> void:
	AtesGlobal.ates_position = global_position

func take_damage(damage):
	if health > 0:
		health -= damage
	else:
		queue_free()

func _on_dragon_spawner_timeout() -> void:
	can_spawn_dragon = true
	print("skill-2 yeniden kullanılabilir")
