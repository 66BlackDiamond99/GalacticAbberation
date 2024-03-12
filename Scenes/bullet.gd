extends Area3D

func _physics_process(_delta):
	global_position.z -= 5
	if global_position.z <= -150:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("Obsticle"):
		body.queue_free()
		queue_free()
