extends TextureRect

var dragging = false
var offset = Vector2.ZERO

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dragging = true
			offset = get_global_mouse_position() - global_position
		elif event.button_index == MOUSE_BUTTON_LEFT:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - offset
