extends CharacterBody2D

@export var follow_distance = 50
@export var speed = 50
@onready var live_timer = $live_timer
var can_follow = true
var attacking = false
var enemies = []
var can_hit = false
var choosen = null
var damage = 500
var cooldown = false
@onready var cooldowntimer = $cooldown
@onready var follow_area = $followArea
@onready var animated_sprite = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite.play("idle")
	live_timer.start()

func _on_live_timer_timeout() -> void:
	print("skill-2 ended (ejderha yok edildi)\n->10sn bekleme süresi")
	queue_free()
func chechsprite():
	if velocity.x > 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	animated_sprite.play("idle")

func _process(delta: float) -> void:
	chechsprite()
	if attacking:
		update_choosen_enemy()

	if can_hit and choosen and not cooldown:
		if is_instance_valid(choosen):
			choosen.take_damage(damage)
			cooldown = true
			cooldowntimer.start()

func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()

func move(delta):
	if attacking and choosen:
		# Hedef düşmana doğru hareket
		var direction = (choosen.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		# AtesGlobal konumuna geri dön
		var direction = (AtesGlobal.ates_position - global_position).normalized()
		var distance = global_position.distance_to(AtesGlobal.ates_position)
		if distance > follow_distance:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO

func update_choosen_enemy():
	# Eğer şu anki choosen düşman yok olduysa veya öldüyse
	if choosen == null or not is_instance_valid(choosen):
		if enemies.size() > 0:
			choosen = enemies[0]
		else:
			choosen = null
			attacking = false  # Hiç düşman kalmadıysa geri döner
			return

func _on_detectarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies.append(body)
		attacking = true
		update_choosen_enemy()

func _on_detectarea_body_exited(body: Node2D) -> void:
	if body in enemies:
		enemies.erase(body)
		if body == choosen:
			choosen = null
		update_choosen_enemy()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		can_hit = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		can_hit = false

func _on_cooldown_timeout() -> void:
	cooldown = false
