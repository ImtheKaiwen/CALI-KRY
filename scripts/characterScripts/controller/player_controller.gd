extends Node2D

@onready var fire = preload("res://scenes/characters/ates.tscn")
@onready var water = preload("res://scenes/characters/su.tscn")
@onready var weather = preload("res://scenes/characters/hava.tscn")
@onready var soil = preload("res://scenes/characters/toprak.tscn")
@onready var light = preload("res://scenes/characters/light.tscn")

var current_player = null
var characters = {}

func _ready() -> void:
	characters = {
		"light": light,
		"fire": fire,
		"water": water,
		"weather": weather,
		"soil": soil
	}
	swap("light")

func swap(mode_name: String):
	if current_player:
		position = current_player.global_position
		remove_child(current_player)
		current_player.queue_free()
		
	current_player = characters[mode_name].instantiate()
	add_child(current_player)
	current_player.global_position = position

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key1") and Gb.current_mode != "light":
		swap("light")
	if Input.is_action_just_pressed("key2") and Gb.current_mode != "fire":
		swap("fire")
	if Input.is_action_just_pressed("key3") and Gb.current_mode != "water":
		swap("water")
	if Input.is_action_just_pressed("key4") and Gb.current_mode != "weather":
		swap("weather")
	if Input.is_action_just_pressed("key5") and Gb.current_mode != "soil":
		swap("soil")
