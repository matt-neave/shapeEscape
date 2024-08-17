extends Control

var shape: BuildingShape:
	set(value):
		$Panel/CenterContainer/ShapeSprite.shape = value

var multiplier: float:
	set(value):
		$Panel/CenterContainer/Label.text = "x" + str(value)
		$Button.multiplier_value = value
