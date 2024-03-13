extends CharacterBody3D


var speed = 150
var acc = 25

func _physics_process(delta):
	velocity.x = lerpf(velocity.x,speed, acc*delta)
	rotation_degrees.x += 1 
	move_and_slide()
