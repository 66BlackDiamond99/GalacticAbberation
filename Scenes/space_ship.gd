extends CharacterBody3D

@export var MAXSPEED :float = 30
@export var ACCELERATION :float = 1
var sens : float = 8

var inputVector = Vector3()
var cooldown_timer = 5
var cooldown = 0
var heat = 0
var max_heat = 20
var overheat = false

@export var guns: Array[Marker3D]
@export var Bullet: PackedScene
@export var Explosion: PackedScene
@export var cold: Color
@export var hot: Color

@onready var game_manager = $"../GameManager"
@onready var timer = $Timer
@onready var texture_progress_bar = $"../Cosmic Zones/Game UI/Gun Overheat/TextureProgressBar"
@onready var overheated = $"../Cosmic Zones/Game UI/Gun Overheat/Overheated"


func _input(event):
	if event is InputEventMouseMotion:
		var e = event as InputEventMouseMotion
		var mouseX = e.relative.x
		var mouseY = e.relative.y
		if mouseX != 0:
			inputVector.x = mouseX/((11-sens)*10)*game_manager.control_dir
		if mouseY != 0:
			inputVector.y = -mouseY/((11-sens)*10)*game_manager.control_dir


func _physics_process(delta):
	texture_progress_bar.max_value = max_heat*delta
	texture_progress_bar.step = 0.01
	velocity.x = lerp(velocity.x, inputVector.x * MAXSPEED * game_manager.speed_scale, ACCELERATION*delta)
	velocity.y = lerp(velocity.y, inputVector.y * MAXSPEED * game_manager.speed_scale, ACCELERATION*delta)
	rotation_degrees.z = velocity.x * -2
	rotation_degrees.x = velocity.y / 2
	rotation_degrees.y = -velocity.x / 2
	move_and_slide()
	transform.origin.x = clamp(transform.origin.x, -6, 6)
	transform.origin.y = clamp(transform.origin.y, -3, 3)
	inputVector = Vector3.ZERO
	if Input.is_action_pressed("fire") && cooldown <= 0 && !overheat:
		cooldown = cooldown_timer*delta
		heat += delta
		if heat >= max_heat*delta:
			overheat = true
			timer.start(2)
			overheated.visible = true
		for g in guns:
			var bullet = Bullet.instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = g.global_position
	if cooldown > 0:
		cooldown -= delta
	
	if heat > 0 && !overheat:
		heat -= delta*0.1
	texture_progress_bar.value = heat
	texture_progress_bar.tint_progress = cold.lerp(hot,float(heat/(max_heat*delta)))

func _on_area_3d_body_entered(body):
	if body.is_in_group("Obsticle"):
		var explosion = Explosion.instantiate()
		get_tree().root.add_child(explosion)
		if body.is_in_group("Rocket"):
			var rocket_explosion = Explosion.instantiate()
			get_tree().root.add_child(rocket_explosion)
			rocket_explosion.global_position = body.global_position
			body.queue_free()
		explosion.global_position = global_position
		game_manager.game_over = true
		queue_free()


func _on_timer_timeout():
	overheated.visible = false
	overheat = false
	heat = 0
