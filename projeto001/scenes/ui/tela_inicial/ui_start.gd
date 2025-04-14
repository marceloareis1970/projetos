extends CanvasLayer

@onready var t_4: Button = $NinePatchRect/VBoxContainer/t4


func _ready() -> void:
	t_4.disabled = Database.read("eu").is_empty()

func _on_t_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/novo_game/ui_novo_game.tscn")


func _on_t_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/creditos/creditos.tscn")


func _on_t_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mapa/mapa.tscn")

func _on_t_2_pressed() -> void:
	pass # Replace with function body.
