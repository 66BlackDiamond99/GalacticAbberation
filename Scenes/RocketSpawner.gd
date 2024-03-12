extends Node3D

@export var Spwaners : Array[Node3D]
@export var Anims : Array[AnimationPlayer]
@export var Rockets :Array[PackedScene]

@onready var timer = $Timer

var timelow = 3.0
var timehigh = 8.0

func _ready():
	timer.start(randf_range(timelow,timehigh))


func _on_timer_timeout():
	var spawner = Spwaners.pick_random()
	var anim = Anims[Spwaners.find(spawner)]
	anim.play("appear")
	await anim.animation_finished
	var Rocket = Rockets.pick_random()
	var rocket = Rocket.instantiate()
	#rocket.transform.origin.z = spawner.transform.origin.x
	get_tree().current_scene.add_child(rocket)
	rocket.global_position = spawner.global_position
