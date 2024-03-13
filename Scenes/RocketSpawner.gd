extends Node3D

@export var Spwaners : Array[Node3D]
@export var Anims : Array[AnimationPlayer]
@export var Rockets :Array[PackedScene]

@onready var timer = $Timer
@onready var game_manager = $"../GameManager"
@onready var audio_stream_player = $AudioStreamPlayer


func _ready():
	timer.start(randf_range(game_manager.rocket_delay_range.x,game_manager.rocket_delay_range.x))

func _on_timer_timeout():
	timer.start(randf_range(game_manager.rocket_delay_range.x,game_manager.rocket_delay_range.x))
	var spawner = Spwaners.pick_random()
	var anim = Anims[Spwaners.find(spawner)]
	audio_stream_player.play()
	anim.play("appear")
	await anim.animation_finished
	var Rocket = Rockets.pick_random()
	var rocket = Rocket.instantiate()
	#rocket.transform.origin.z = spawner.transform.origin.x
	get_tree().current_scene.add_child(rocket)
	rocket.global_position = spawner.global_position
