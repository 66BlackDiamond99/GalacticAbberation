extends Control

const SAVE_PATH = "user://"
@onready var music_value = $"Options/Main Container/Menu/Music/music value"
@onready var sfx_value = $"Options/Main Container/Menu/SFX/sfx value"
@onready var sens_value = $"Options/Main Container/Menu/Sensitivity/sens value"
@onready var sens_slider = $"Options/Main Container/Menu/Sensitivity/sens slider"
@onready var music_slider = $"Options/Main Container/Menu/Music/music slider"
@onready var sfx_slider = $"Options/Main Container/Menu/SFX/sfx slider"

@onready var main_screen = $"Main Screen"
@onready var credits = $Credits
@onready var options = $Options

func save_var(name,value):
	var file = FileAccess.open(SAVE_PATH+name+".save", FileAccess.WRITE)
	file.store_var(value)
	file.close()

func load_var(name,default):
	var v = 0
	if not FileAccess.file_exists(SAVE_PATH+name+".save"): return default
	var file = FileAccess.open(SAVE_PATH+name+".save", FileAccess.READ)
	v = file.get_var()
	file.close()
	return v

func _ready():
	main_screen.visible = true
	options.visible = false
	credits.visible = false
	var last_sfx = load_var("sfx",0)
	var last_music = load_var("music",0)
	var last_sens = load_var("sens",8)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),remap(last_sfx,0,100,-40,6))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),remap(last_music,0,100,-40,6))
	sfx_value.text = str(last_sfx)
	music_value.text = str(last_music)
	sens_value.text = str(last_sens)
	sens_slider.value = last_sens
	sfx_slider.value = last_sfx
	music_slider.value = last_music

func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/space.tscn")


func _on_options_pressed():
	main_screen.visible = false
	options.visible = true
	credits.visible = false


func _on_credits_pressed():
	main_screen.visible = false
	options.visible = false
	credits.visible = true


func _on_credits_back_pressed():
	main_screen.visible = true
	options.visible = false
	credits.visible = false


func _on_options_back_pressed():
	main_screen.visible = true
	options.visible = false
	credits.visible = false


func _on_sfx_slider_value_changed(value):
	sfx_value.text = str(value)
	save_var("sfx",value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),remap(value,0,100,-40,6))


func _on_music_slider_value_changed(value):
	music_value.text = str(value)
	save_var("music",value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),remap(value,0,100,-40,6))


func _on_sens_slider_value_changed(value):
	sens_value.text = str(value)
	save_var("sens",value)
