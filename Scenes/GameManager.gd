extends Node3D
class_name GameManager

var speed_scale: float = 1
var control_dir: int = 1
var meteor_amount: int = 3
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

enum CosmicZones {
	slow,
	speed,
	magnetic,
	none
}

var next_zone = CosmicZones.none
var zone_active = false
func _ready():
	timer.timeout.connect(_on_timer_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _on_timer_timeout():
	if meteor_amount < 5:
		meteor_amount += 1
	if rocket_delay_range.x > 4:
		rocket_delay_range.x -= 2
	if rocket_delay_range.y > 6:
		rocket_delay_range.y -= 2
	next_zone = CosmicZones.keys().pick_random()
	if !zone_active:
		activate_zone(next_zone)

func activate_zone(zone):
	magnetic_cosmic_zone.visible = false
	slow_cosmic_zone.visible = false
	speed_cosmic_zone.visible = false
	control_dir = 1
	speed_scale = 1
	Engine.time_scale = 1
	zone_active = false
	if zone == "magnetic":
		for i in range(3):
			magnetic_zone_warning.visible = true
			await get_tree().create_timer(0.5).timeout
			magnetic_zone_warning.visible = false
			await get_tree().create_timer(0.25).timeout
		magnetic_cosmic_zone.visible = true
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
		zone_animation_player.play("Slow Zone Appear")
		await zone_animation_player.animation_finished
		speed_scale = 1.2
		Engine.time_scale = 0.5
		cooldown_timer.start(5)
		zone_active = true
	if zone == "speed":
		for i in range(3):
			speed_zone_warning.visible = true
			await get_tree().create_timer(0.5).timeout
			speed_zone_warning.visible = false
			await get_tree().create_timer(0.25).timeout
		speed_cosmic_zone.visible = true
		zone_animation_player.play("Speed Zone Appear")
		await zone_animation_player.animation_finished
		speed_scale = 0.75
		Engine.time_scale = 2
		cooldown_timer.start(10)
		zone_active = true


func _on_cooldown_timer_timeout():
	activate_zone("none")
	zone_active = false
