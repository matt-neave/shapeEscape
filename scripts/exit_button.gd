extends Button

func _pressed() -> void:
	SoundManager.play_sound(SoundManager.SOUNDS.BUTTON_CLICK)
	get_tree().quit()
