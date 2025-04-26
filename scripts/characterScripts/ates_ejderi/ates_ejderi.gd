extends CharacterBody2D

@export var follow_distance = 50
@export var speed = 100
@onready var live_timer = $live_timer
var can_follow = false

@onready var follow_area = $followArea
func _ready() -> void:
	live_timer.start()
	

func _on_live_timer_timeout() -> void:
	print("skill-2 ended (ejderha yok edildi)\n->10sn bekleme süresi")
	
	queue_free()

func _process(delta: float) -> void:
	move(delta)

func _physics_process(delta: float) -> void:
	move_and_slide()




func move(delta):
	if can_follow:
		var direction = (AtesGlobal.ates_position - global_position).normalized()
		var distance = global_position.distance_to(AtesGlobal.ates_position)

		# Eğer mesafe 50'den büyükse, ejder karaktere doğru yaklaşsın
		if distance > follow_distance:
			var move_distance = min(distance - follow_distance, speed * delta)  # Karaktere yaklaşma mesafesi
			velocity = direction * move_distance
	else:
		velocity = Vector2()
		
