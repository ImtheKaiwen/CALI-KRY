extends Area2D

@onready var spawn_timer = $pawn_timer
@onready var duration_timer = $duration_timer
@onready var enemy_timer = $enemt_timer


var minion_scene = preload("res://scenes/ai/shortai.tscn")
var spawn_interval = 1.0  # Her 1 saniyede 1 minion
var spawn_duration = 5.0  # 5 saniye boyunca spawn

var is_spawning = false
var current_player = null

var destroyed = false

var idles = ["enemy_1_idle","enemy_2_idle","enemy_3_idle","enemy_4_idle"]
var anim = null
var spawned = []
func _ready():
	anim = idles[randi() % idles.size()]
	spawn_timer.wait_time = spawn_interval
	duration_timer.wait_time = spawn_duration
	spawn_timer.start()
	duration_timer.start()
	is_spawning = true

func _process(delta: float) -> void:
	if destroyed:
		for minion in spawned:
			destroy(minion)

func _on_pawn_timer_timeout() -> void:
	if is_spawning:
		var minion = minion_scene.instantiate()
		get_parent().add_child(minion)
		# Minion'u biraz rastgele yakınımıza spawnlayabiliriz
		var random_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
		minion.global_position = global_position + random_offset
		spawned.append(minion)
		
		

func set_player(player):
	current_player = player

func destroy(minion):
	if minion:
		minion.queue_free()
func _on_duration_timer_timeout() -> void:
	is_spawning = false
	spawn_timer.stop()
	enemy_timer.start()
	queue_free()  # Süre dolunca kendini yok et


func _on_enemt_timer_timeout() -> void:
	destroyed = true
