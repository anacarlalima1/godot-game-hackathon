extends Sprite

signal tile_pressed(position)

var position_in_grid = Vector2()
var game

func _ready():
	connect("input_event", self, "_on_input_event")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("tile_pressed", position_in_grid)
		return true # Consume the input event
