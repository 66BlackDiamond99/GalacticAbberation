extends Node3D

@export var offsetX : float = 6
@export var offsetY : float = 5

@export var Obsticles : Array[PackedScene]

func _on_spawn_timer_timeout():
	var current_obsticle = Obsticles.pick_random().instantiate()
	current_obsticle.transform.origin = transform.origin
	current_obsticle.transform.origin.x += randf_range(offsetX,-offsetX)
	current_obsticle.transform.origin.y += randf_range(offsetY,-offsetY)
	get_tree().current_scene.add_child(current_obsticle)
