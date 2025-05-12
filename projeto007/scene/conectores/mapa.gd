extends Node3D
@onready var no_panel: Panel = $CanvasLayer/Panel

var ativo:bool=false

func _ready() -> void:
	no_panel.visible=ativo

func _physics_process(delta: float) -> void:
	no_panel.visible=ativo
	if ativo:
		if Input.is_action_just_pressed("F"):
			ativo=false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=false
