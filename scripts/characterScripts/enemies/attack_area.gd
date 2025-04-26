extends Area2D
var damage = 15
var can_hit = false

var players = []
@onready var cool_down = $cooldown
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	attack()
	


func attack():
	if can_hit:
		for body in players:
			body.take_damage(damage)
		can_hit = false
		cool_down.start()
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			can_hit = true
			players.append(body)
			


func _on_cooldown_timeout() -> void:
	can_hit = true


func _on_body_exited(body: Node2D) -> void:
	players = []
	can_hit = false
