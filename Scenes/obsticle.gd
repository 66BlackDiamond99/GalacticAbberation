extends CharacterBody3D

@export var max_speed : float = 60
@export var accelaration : float = 1

func _physics_process(delta):
	velocity.z = lerpf(velocity.z, 60 * randf_range(1,2), accelaration*delta)
	rotation_degrees.x += 0.75
	rotation_degrees.z += 0.5
	move_and_slide()
	if transform.origin.z >= 20:
		queue_free()
