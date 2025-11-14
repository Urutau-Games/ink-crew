extends Control
class_name ResultEntry

@onready var player_label: Label = $PlayerLabel
@onready var area_label: Label = $AreaLabel

var player: String: 
	set(value):
		player = value
		if player_label:
			player_label.text = value
			
var area: String: 
	set(value):
		area = value
		if area_label:
			area_label.text = value
