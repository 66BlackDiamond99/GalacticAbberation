extends CharacterBody3D

@export var max_speed : float = 60
@export var accelaration : float = 1

var game_manager
func _ready():
	game_manager = get_tree().current_scene.find_child("GameManager") as GameManager
func _physics_process(delta):
	velocity.z = lerpf(velocity.z, 60 * randf_range(1,2)*game_manager.global_speed_scale, accelaration*delta)
	rotation_degrees.x += 0.75
	rotation_degrees.z += 0.5
	move_and_slide()
	if transform.origin.z >= 20:
		queue_free()
