extends CharacterBody3D

@export var MAXSPEED :float = 30
@export var ACCELERATION :float = 1
@export var SENSITIVITY : float = 8

var inputVector = Vector3()
var dir = 1
var cooldown_timer = 5
var cooldown = 0

@export var guns: Array[Marker3D]
@export var Bullet: PackedScene


func _input(event):
	if event is InputEventMouseMotion:
		var e = event as InputEventMouseMotion
		var mouseX = e.relative.x
		var mouseY = e.relative.y
		if mouseX != 0:
			inputVector.x = mouseX/((11-SENSITIVITY)*10)*dir
		if mouseY != 0:
			inputVector.y = -mouseY/((11-SENSITIVITY)*10)*dir

func invertControl():
	dir *= -1

func _physics_process(delta):
	velocity.x = lerp(velocity.x, inputVector.x * MAXSPEED, ACCELERATION*delta)
	velocity.y = lerp(velocity.y, inputVector.y * MAXSPEED, ACCELERATION*delta)
	rotation_degrees.z = velocity.x * -2
	rotation_degrees.x = velocity.y / 2
	rotation_degrees.y = -velocity.x / 2
	move_and_slide()
	transform.origin.x = clamp(transform.origin.x, -6, 6)
	transform.origin.y = clamp(transform.origin.y, -5, 3)
	inputVector = Vector3.ZERO
	if Input.is_action_pressed("fire") && cooldown <= 0:
		cooldown = cooldown_timer*delta
		for g in guns:
			var bullet = Bullet.instantiate()
			bullet.global_position = g.global_position
			get_tree().current_scene.add_child(bullet)
	if cooldown > 0:
		cooldown -= delta

func _on_area_3d_body_entered(body):
	if body.is_in_group("Obsticle"):
		queue_free()
		get_tree().reload_current_scene()
