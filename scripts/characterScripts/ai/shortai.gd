extends CharacterBody2D

var attack_range = 24
var health = 1200
var armor = 5
var damage = 75
var speed = 50
var attack_speed = 1.2
var enemy_area = false
var can_attack = true
var current_attack_speed = attack_speed
var current_speed = speed
var player = null

@onready var attack_cooldown = $"../attackCooldown"
@onready var attack_area = $attack_area

func _ready() -> void:
	add_to_group("enemies")


func _physics_process(delta: float) -> void:
	print(player)
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance > attack_range:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
	attack()
	move_and_slide()
				

func attack():
	if enemy_area and can_attack:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("player")	and body.has_method("take_damage"):
				body.take_damage(damage)
				print("hasar verildi")
				can_attack = false
				attack_cooldown.wait_time = attack_speed
				attack_cooldown.start()
func take_damage(damage):
	health -= damage - (damage * float(armor) / 100.0)
	if health <= 0:
		queue_free()

		
func get_slow(slow_rate,slow_time):
	attack_speed += slow_rate
	speed -= slow_rate * 50
	var timer = Timer.new()
	timer.wait_time = slow_time
	add_child(timer) 
	timer.start()
	timer.connect("timeout", Callable(self, "slowend"))

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		enemy_area = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		enemy_area = false


func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func slowend():
	attack_speed = current_attack_speed
	speed = current_speed
	


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player detected")
		player = body


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
