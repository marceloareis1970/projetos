extends TextureRect

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for child in get_tree().get_nodes_in_group("skills"):
			if child.dragging and child.get_global_rect().intersects(get_global_rect()):
				child.global_position = global_position
				break
