extends Area3D


@export var Explosion: PackedScene

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
