extends Node3D

@export var offsetX : float = 6
@export var offsetY : float = 5
@export var Obsticles : Array[PackedScene]

@onready var game_manager = $"../GameManager"
@onready var spawn_timer = $SpawnTimer

func _on_spawn_timer_timeout():
	spawn_timer.start(0.5)
	for i in game_manager.meteor_amount:
		var current_obsticle = Obsticles.pick_random().instantiate()
		get_tree().current_scene.add_child(current_obsticle)
		current_obsticle.transform.origin = transform.origin
		current_obsticle.transform.origin.x += randf_range(offsetX,-offsetX)
		current_obsticle.transform.origin.y += randf_range(offsetY,-offsetY)
