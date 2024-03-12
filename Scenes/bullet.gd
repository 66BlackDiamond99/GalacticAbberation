extends Area3D

func _physics_process(delta):
	global_position.z -= 5
	pass


func _on_body_entered(body):
	if body.is_in_group("Obsticle"):
		body.queue_free()
		queue_free()
		
