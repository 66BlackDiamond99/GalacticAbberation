extends Node3D

@onready var sparks = $sparks
@onready var flash = $flash
@onready var fire = $fire
@onready var smoke = $smoke
@onready var audio_stream_player = $AudioStreamPlayer

@export var sfx: Array[AudioStream]

func _ready():
	audio_stream_player.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player.stream = sfx.pick_random()
	audio_stream_player.play()
	Engine.time_scale = 0.25
	sparks.emitting = true
	flash.emitting = true
	fire.emitting = true
	smoke.emitting = true
	await smoke.finished
	Engine.time_scale = 1
