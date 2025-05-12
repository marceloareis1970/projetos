extends Node3D

@onready var no_panel: Panel = $CanvasLayer/Panel

var ativo:bool=false

func _ready() -> void:
	no_panel.visible=ativo

func _physics_process(delta: float) -> void:
	no_panel.visible=ativo # display ou não display a letra na tela
	if ativo: # se ativo ... 
		if Input.is_action_just_pressed("F"): # se pressionar a tecla F
			ativo=false # dsabilito a visualizacao da tela e carreo a escolha de player
			var tmp=preload("res://scene/ui/escolhe_player/ui_escolhe_player.tscn").instantiate()
			add_child(tmp)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=false
