extends Area2D

@export var explosion_delay = 1.0 # Küre ne kadar sonra patlayacak
@export var damage = 100
@export var explosion_radius = 80

@onready var timer = $Timer
@onready var collision = $coll
@onready var sprite = $Sprite2D
@onready var animated_sprite = $AnimatedSprite2D
var has_exploded = false

func _ready():
	animated_sprite.play("default")
	timer.wait_time = explosion_delay
	timer.start()
	scale = Vector2.ZERO
	collision.disabled = true
	# Küre doğarken küçük olsun animasyon verebilirsin
	# İstersen doğarken büyüme efekti de ekleyebiliriz

func _process(delta):
	if not has_exploded:
		# Doğarken büyüsün (isteğe bağlı efekt)
		if scale.x < 1:
			scale += Vector2(1, 1) * delta * 2
	

func explode():
	if has_exploded:
		return
	has_exploded = true

	# Patlama animasyonu / efekt istersen burada yaparsın
	collision.disabled = false
	collision.shape.radius = explosion_radius

	# Oyuncu küre alanındaysa hasar ver
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage) # Oyuncuda bu fonksiyon olmalı

	# Patlama efekti vs koyabiliriz burada
	queue_free()


func _on_timer_timeout() -> void:
	explode()
