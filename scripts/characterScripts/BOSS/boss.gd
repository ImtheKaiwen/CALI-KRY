extends CharacterBody2D

var skills = ["syndra_q", "reflect_shield", "spawn_minions", "needle_attack","spawn_archers"]
var animations = []
var can_cast_skill = true
var skill_cooldown = 2.5
var current_cooldown = skill_cooldown
var player = null
var can_claw = true
var claw_cooldown = 5.0
var health = 300000
var armor = 50
var can_aa = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var aa_timer = $aa_timer
@onready var skill_timer = Timer.new()
@onready var claw_timer = Timer.new()

func _ready():
	animated_sprite.play("idle")
	add_child(skill_timer)
	skill_timer.one_shot = true
	skill_timer.connect("timeout", Callable(self, "_on_skill_ready"))

	add_child(claw_timer)
	claw_timer.one_shot = true
	claw_timer.connect("timeout", Callable(self, "_on_claw_ready"))
	
	add_child(reflect_timer)
	reflect_timer.one_shot = true
	reflect_timer.connect("timeout", Callable(self, "_on_reflect_timer_timeout"))
	
	add_child(claw_cooldown_timer)
	claw_cooldown_timer.one_shot = true
	claw_cooldown_timer.connect("timeout", Callable(self, "_on_claw_cooldown_timeout"))

func _process(delta):
	if can_cast_skill:
		cast_random_skill()

	if player and is_player_in_claw_range() and can_claw:
		use_claw()
		
	if player and can_aa:
		cast_needle_attack()
		can_aa = false
		aa_timer.start()

func cast_random_skill():
	can_cast_skill = false
	var skill = skills[randi() % skills.size()]
	match skill:
		"syndra_q":
			cast_syndra_q()
		"reflect_shield":
			cast_reflect_shield()
		"spawn_minions":
			cast_spawn_minions()
		"spawn_archers":
			cast_spawn_archers()
	skill_timer.start(current_cooldown)

func cast_syndra_q():
	var sphere = preload("res://scenes/ai/sphere.tscn").instantiate()
	get_parent().add_child(sphere)
	sphere.global_position = player.global_position
	# Sphere kendi içinde patlama yapacak
	print("Syndra Q atıldı")

func cast_spawn_archers():
	var spawn_area = preload("res://scenes/ai/archer_spawn_area.tscn").instantiate()
	get_parent().add_child(spawn_area)
	spawn_area.global_position = player.global_position
	print("Minyonlar doğuyor")

var reflecting = false
var reflect_duration = 3.0 # yansıtma süresi
var reflect_damage_multiplier = 1.0 # gelen hasarı kaç kat yansıtacak (1 = tam, 2 = iki katı)

@onready var reflect_timer = Timer.new()

func take_damage(damage_amount):
	if reflecting:
		if player and player.has_method("take_damage"):
			player.take_damage(damage_amount * reflect_damage_multiplier)
			print("Yansıtıldı:", damage_amount)
	else:
		health -= damage_amount - (damage_amount * armor / 100.0)
		print("Boss hasar aldı:", damage_amount)

	if health <= 0:
		queue_free()


func cast_reflect_shield():
	reflecting = true
	reflect_timer.wait_time = reflect_duration
	reflect_timer.start()
	print("Reflect shield açıldı")
	# Bir değişken ile 'hasarı yansıt' moduna geçilecek

func _on_reflect_timer_timeout():
	reflecting = false
	print("Yansıtma bitti.")


func cast_spawn_minions():
	var spawn_area = preload("res://scenes/ai/spawn_area.tscn").instantiate()
	get_parent().add_child(spawn_area)
	spawn_area.global_position = player.global_position
	print("Minyonlar doğuyor")

@onready var needle_scene = preload("res://scenes/ai/needle.tscn")

func cast_needle_attack():
	var needle = needle_scene.instantiate()
	get_parent().add_child(needle)
	needle.global_position = global_position
	var direction = (player.global_position - global_position).normalized()
	needle.direction = direction
	print("Needle fırlatıldı")
# Projectile fırlat, player'ı hedef alacak

var claw_damage = 100
var claw_knockback_force = 300
var claw_cooldown_time = 4.0 # Pençe kullandıktan sonra 4 saniye bekleyecek

@onready var claw_cooldown_timer = Timer.new()
@onready var claw_area = $claw_area

func use_claw():
	if not player:
		return
	if not can_claw:
		return
	print("Pençe atıldı")
	
	if player.has_method("take_damage"):
		player.take_damage(claw_damage)
	
	var knockback_dir = (player.global_position - global_position).normalized()
	if player.has_method("apply_knockback"):
		player.apply_knockback(knockback_dir * claw_knockback_force)
	
	can_claw = false
	claw_cooldown_timer.wait_time = claw_cooldown_time
	claw_timer.start(claw_cooldown)
	# Eğer player varsa onu geriye ittir ve hasar ver

func _on_claw_cooldown_timer_timeout():
	can_claw = true

func _on_skill_ready():
	can_cast_skill = true

func _on_claw_ready():
	can_claw = true

func is_player_in_claw_range():
	if not player:
		return false
	var distance = global_position.distance_to(player.global_position)
	return distance <= 100  # Mesela 100 birim mesafe içinde


func _on_claw_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		use_claw()


func _on_deteckdeneme_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_aa_timer_timeout() -> void:
	can_aa = true
