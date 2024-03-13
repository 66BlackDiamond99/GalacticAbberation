extends Node3D

@onready var sparks = $sparks
@onready var flash = $flash
@onready var fire = $fire
@onready var smoke = $smoke
@onready var audio_stream_player = $AudioStreamPlayer

@export var sfx: Array[AudioStream]
@export var game_over: AudioStream

func _ready():
	audio_stream_player.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player.stream = sfx.pick_random()
	audio_stream_player.play()
	var music = get_tree().current_scene.find_child("Game Music") as AudioStreamPlayer
	var tween = get_tree().create_tween()
	tween.tween_property(music,"pitch_scale",0.0,0.5)
	tween.play()
	Engine.time_scale = 0.25
	sparks.emitting = true
	flash.emitting = true
	fire.emitting = true
	smoke.emitting = true
	await smoke.finished
	Engine.time_scale = 1
	await get_tree().create_timer(0.25).timeout
	music.pitch_scale = 1
	music.stream = game_over
	music.play()
	
