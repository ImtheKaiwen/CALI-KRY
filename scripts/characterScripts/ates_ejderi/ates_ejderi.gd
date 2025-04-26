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
func _ready() -> void:
	live_timer.start()
	

func _on_live_timer_timeout() -> void:
	print("skill-2 ended (ejderha yok edildi)\n->10sn bekleme süresi")
	
	queue_free()

func _process(delta: float) -> void:
	
	if can_hit:
		if choosen and not cooldown:  # cooldown aktif değilse vur
			choosen.take_damage(damage)
			cooldown = true
			cooldowntimer.start()
		
	
	if enemies:
		var closest_enemy = null
		var closest_distance = INF  # sonsuzdan başla ki her mesafe daha küçük olsun
		
		for body in enemies:
			var distance = global_position.distance_to(body.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = body
		
		if closest_enemy and not can_hit:
			choosen = closest_enemy
			var direction = (closest_enemy.global_position - global_position).normalized()
			velocity = direction * speed
			
		
				
			

	move(delta)

func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()



func move(delta):
	if attacking == false:
		var direction = (AtesGlobal.ates_position - global_position).normalized()
		var distance = global_position.distance_to(AtesGlobal.ates_position)
		
		if distance > follow_distance:
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO

		


func _on_followarea_area_entered(area: Area2D) -> void:


	pass
func _on_followarea_area_exited(area: Area2D) -> void:
	pass	


func _on_detectarea_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies.append(body)
		attacking = true


func _on_detectarea_body_exited(body: Node2D) -> void:
	if body in enemies:
		enemies.erase(body)
		print(body)
		if enemies.is_empty():
			attacking = false
		else:
			attacking = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		can_hit = true
		velocity = Vector2.ZERO


func _on_cooldown_timeout() -> void:
	cooldown = false


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		can_hit = false
		enemies = []
