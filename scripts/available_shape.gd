extends Control

var shape: BuildingShape:
	set(value):
		shape = value
		$Panel/CenterContainer/ShapeSprite.shape = value

var multiplier: float:
	set(value):
		multiplier = value
		$Panel/CenterContainer/Label.text = "x" + str(value)
		$Button.multiplier_value = value

