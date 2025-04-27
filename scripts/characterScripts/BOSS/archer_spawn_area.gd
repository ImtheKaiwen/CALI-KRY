extends Area2D

@onready var spawn_timer = $spawn_timer
@onready var duration_timer = $duration_timer

var minion_scene = preload("res://scenes/ai/archerai.tscn")
var spawn_interval = 1.0  # Her 1 saniyede 1 minion
var spawn_duration = 5.0  # 5 saniye boyunca spawn

var is_spawning = false
var current_player = null

var idles = ["idle","idle_1"]
var anim = null

func _ready():
	anim = idles[randi() % idles.size()]
	spawn_timer.wait_time = spawn_interval
	duration_timer.wait_time = spawn_duration
	spawn_timer.start()
	duration_timer.start()
	is_spawning = true



	
		

func set_player(player):
	current_player = player


	


func _on_spawn_timer_timeout() -> void:
	if is_spawning:
		var minion = minion_scene.instantiate()
		get_parent().add_child(minion)
		# Minion'u biraz rastgele yakınımıza spawnlayabiliriz
		var random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		minion.global_position = global_position + random_offset


func _on_duration_timer_timeout() -> void:
	is_spawning = false
	spawn_timer.stop()
	queue_free()  # Süre dolunca kendini yok et
