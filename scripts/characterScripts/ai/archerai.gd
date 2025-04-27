extends CharacterBody2D

var health = 1000
var damage = 200
var speed = 75
var attackspeed = 1.4
var player = null
var attack_range = 100
var enemy_in_area = false
var can_attack = true

@onready var arrow = preload("res://scenes/ai/arrowai.tscn")
@onready var cooldown = $cooldown
@onready var animated_sprite = $AnimatedSprite2D


var idles = ["idle", "idle_1"]

func _ready() -> void:
	randomize()
	var anim = idles[randi() % idles.size()]
	animated_sprite.play(anim)
	add_to_group("enemies")
	
func take_damage(damage):
	health -= damage
	if health <=0 :
		queue_free()

func _physics_process(delta: float) -> void:

	if player or Gb.last_seen_position:
		var distance = global_position.distance_to(Gb.last_seen_position)
		if distance > attack_range:
			var direction = (Gb.last_seen_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
	attack()
	move_and_slide()


func attack():
	if enemy_in_area and can_attack:
		var arrow = arrow.instantiate()
		var mouse_pos =  get_global_mouse_position()
		var direction = (player.global_position - global_position).normalized()
		
		arrow.global_position = global_position
		arrow.set_direction(direction)
		
		get_tree().current_scene.add_child(arrow)
		
		can_attack = false
		cooldown.wait_time = attackspeed
		cooldown.start()
	
	

func _on_attackarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		enemy_in_area = true
		



func _on_attackarea_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		enemy_in_area = false
	


func _on_detectarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
	else:
		print("player değil")


func _on_detectarea_body_exited(body: Node2D) -> void:
	if body == player:
		player = null


func _on_cooldown_timeout() -> void:
	can_attack = true
