extends Node3D
class_name GameManager

var speed_scale: float = 1
var global_speed_scale: float = 1
var control_dir: int = 1
var meteor_amount: int = 3
var meteor_timer: int = 0.5
var rocket_delay_range: Vector2 = Vector2(10,20)
@onready var timer = $"../Timer"
@onready var magnetic_cosmic_zone = $"../Cosmic Zones/Magnetic Cosmic Zone"
@onready var speed_cosmic_zone = $"../Cosmic Zones/Speed Cosmic Zone"
@onready var slow_cosmic_zone = $"../Cosmic Zones/Slow Cosmic Zone"
@onready var zone_animation_player = $"../Cosmic Zones/ZoneAnimationPlayer"
@onready var cooldown_timer = $"../Cosmic Zones/CooldownTimer"
@onready var magnetic_zone_warning = $"../Cosmic Zones/Magnetic Zone Warning"
@onready var speed_zone_warning = $"../Cosmic Zones/Speed Zone Warning"
@onready var slow_zone_warning = $"../Cosmic Zones/Slow Zone Warning"
@onready var audio_stream_player = $AudioStreamPlayer
@onready var gpu_particles_3d = $"../GPUParticles3D"

@export var sfx_enter : Array[AudioStream]
@export var sfx_exit : Array[AudioStream]
enum CosmicZones {
	slow,
	speed,
	magnetic,
	none
}
@onready var score_label = $"../Cosmic Zones/Game UI/Score"
var game_over = false
var score = 0
var start_time = 0
var next_zone = CosmicZones.none
var zone_active = false
func _ready():
	start_time = Time.get_ticks_msec()
	timer.timeout.connect(_on_timer_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _process(delta):
	if !game_over:
		score = Time.get_ticks_msec() - start_time
	score_label.text = "Score: "+str(int(score/100))

func _on_timer_timeout():
	if meteor_amount < 20:
		meteor_amount += 1
	if rocket_delay_range.x > 2:
		rocket_delay_range.x -= 1
	if rocket_delay_range.y > 4:
		rocket_delay_range.y -= 1
	next_zone = CosmicZones.keys().pick_random()
	if !zone_active:
		activate_zone(next_zone)

func activate_zone(zone):
	magnetic_cosmic_zone.visible = false
	slow_cosmic_zone.visible = false
	speed_cosmic_zone.visible = false
	control_dir = 1
	speed_scale = 1
	global_speed_scale = 1
	meteor_timer = 0.5
	gpu_particles_3d.speed_scale = global_speed_scale
	zone_active = false
	if zone == "magnetic":
		for i in range(3):
			magnetic_zone_warning.visible = true
			await get_tree().create_timer(0.5).timeout
			magnetic_zone_warning.visible = false
			await get_tree().create_timer(0.25).timeout
		magnetic_cosmic_zone.visible = true
		audio_stream_player.stream = sfx_enter.pick_random()
		audio_stream_player.play()
		zone_animation_player.play("Magnetic Zone Appear")
		await zone_animation_player.animation_finished
		control_dir = -1
		cooldown_timer.start(10)
		zone_active = true
	if zone == "slow":
		for i in range(3):
			slow_zone_warning.visible = true
			await get_tree().create_timer(0.5).timeout
			slow_zone_warning.visible = false
			await get_tree().create_timer(0.25).timeout
		slow_cosmic_zone.visible = true
		audio_stream_player.stream = sfx_enter.pick_random()
		audio_stream_player.play()
		zone_animation_player.play("Slow Zone Appear")
		await zone_animation_player.animation_finished
		speed_scale = 0.25
		cooldown_timer.start(5)
		zone_active = true
	if zone == "speed":
		for i in range(3):
			speed_zone_warning.visible = true
			await get_tree().create_timer(0.5).timeout
			speed_zone_warning.visible = false
			await get_tree().create_timer(0.25).timeout
		speed_cosmic_zone.visible = true
		audio_stream_player.stream = sfx_enter.pick_random()
		audio_stream_player.play()
		zone_animation_player.play("Speed Zone Appear")
		await zone_animation_player.animation_finished
		speed_scale = 2
		global_speed_scale = 4
		meteor_timer = 0.1
		gpu_particles_3d.speed_scale = global_speed_scale
		cooldown_timer.start(10)
		zone_active = true


func _on_cooldown_timer_timeout():
	activate_zone("none")
	zone_active = false
	audio_stream_player.stream = sfx_exit.pick_random()
	audio_stream_player.play()
