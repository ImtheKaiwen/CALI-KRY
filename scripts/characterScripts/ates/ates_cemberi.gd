extends Area2D

var damage = 150
var can_use = true
@onready var collision = $ates_cemberiCollision
@onready var timer = $ates_cemberi_timer
@onready var skill_timer = $skill_timer

func _ready() -> void:
	collision.disabled = true
	skill_timer.one_shot = true
	skill_timer.wait_time = 4
	timer.one_shot = true
	timer.wait_time = 5

@onready var skil1usedtimer = $skil1used
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SKILL1"):
		
		skil1usedtimer.start()
		active_skill()

func active_skill():
	if can_use:
		AtesGlobal.skil1used = true
		print("skill-1 started")
		collision.disabled = false
		timer.start()
		can_use = false

func _on_ates_cemberi_timer_timeout() -> void:
	print("skill-1 ended -- 4sn boyunca kullanılamaz")
	AtesGlobal.skil1used = false
	collision.disabled = true
	skill_timer.start()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)


func _on_skill_timer_timeout() -> void:
	print("skill-1 kullanılabilir")
	can_use = true
