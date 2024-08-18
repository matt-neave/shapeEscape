extends Button
var level_scene_path = "res://scenes/level_select.tscn"

func _pressed():
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)
	get_tree().change_scene_to_file(level_scene_path)
