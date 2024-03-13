extends Area3D


@export var Explosion: PackedScene
@export var sfx : Array[AudioStream]
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	audio_stream_player.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player.stream = sfx.pick_random()
	audio_stream_player.play()

func _physics_process(_delta):
	global_position.z -= 5
	if global_position.z <= -150:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Obsticle"):
		var explosion = Explosion.instantiate()
		get_tree().root.add_child(explosion)
		explosion.global_position = body.global_position
		body.queue_free()
		queue_free()
