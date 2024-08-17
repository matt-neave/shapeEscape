extends Control

var shape: BuildingShape:
	set(value):
		$Panel/CenterContainer/ShapeSprite.shape = value
