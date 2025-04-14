extends Node2D

var ativo:bool=false
@onready var color_rect: ColorRect = $UI/ColorRect

func _ready() -> void:
	color_rect.visible = false
	
func _physics_process(delta: float) -> void:
	color_rect.visible = ativo
	if ativo:
		if Input.is_action_just_pressed("F"):
			if Comum.eu.blindagem.atual == 0:
				Comum.mapa.setMsg("sua nave precisa de manutenção")
				return
			if Comum.eu.destino.is_empty():
				Comum.mapa.setMsg("Defina um destino antes")
				return
			ativo = false
			Comum.eu.cash_extra=false # não tem direito a trabalhos comunitários
			Comum.game.trocarParaNave()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo = false
