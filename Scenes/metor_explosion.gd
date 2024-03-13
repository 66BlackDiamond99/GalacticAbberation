extends Node3D

@onready var gpu_particles_3d = $GPUParticles3D
@onready var audio_stream_player = $AudioStreamPlayer

@export var sfx : Array[AudioStream]

func _ready():
	audio_stream_player.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player.stream = sfx.pick_random()
	audio_stream_player.play()
	gpu_particles_3d.emitting = true
	await gpu_particles_3d.finished
	queue_free()
