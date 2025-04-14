extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed() -> void:
	Comum.game.trocarParaEstacao()
	Comum.eu.vivo=true
	queue_free()
