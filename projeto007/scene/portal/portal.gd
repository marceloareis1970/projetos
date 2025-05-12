extends Node3D

var ativo:bool = false
@onready var no_panel: Panel = $CanvasLayer/Panel

func _ready() -> void:
	no_panel.visible = ativo

func _physics_process(delta: float) -> void:
	no_panel.visible = ativo
	if ativo:
		if Input.is_action_just_pressed("F"):
			ativo = false
			Comum.onde_estou=""
			var tmp = preload("res://scene/cidade/cidade.tscn").instantiate()
			Comum.mapa.carregarMapa(tmp)
			queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo = false
