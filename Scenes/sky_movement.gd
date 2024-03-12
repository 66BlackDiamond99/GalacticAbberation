extends WorldEnvironment

func _process(delta):
	environment.sky_rotation.x += 0.025 * delta
