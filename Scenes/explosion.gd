extends Node3D

@onready var sparks = $sparks
@onready var flash = $flash
@onready var fire = $fire
@onready var smoke = $smoke


func _ready():
	Engine.time_scale = 0.25
	sparks.emitting = true
	flash.emitting = true
	fire.emitting = true
	smoke.emitting = true
	await smoke.finished
	Engine.time_scale = 1
