extends Node2D


var ativo:bool=false
@onready var color_rect: ColorRect = $UI/ColorRect

func _ready() -> void:
	color_rect.visible=false


func _physics_process(delta: float) -> void:
	color_rect.visible = ativo
	if ativo:
		if Input.is_action_just_pressed("F"):
			if Comum.eu.cash >= Comum.consertarNave():
				Comum.mapa.setMsg("Não temos nada para você no momento.")
				return
			if not Comum.eu.cash_extra:
				Comum.mapa.setMsg("Não temos nada para você no momento.")
				return
			Comum.eu.cash_extra=false
			Comum.player_estacao=false
			ativo=false
			color_rect.visible=false
			await get_tree().create_timer(5.0).timeout
			var cashextra=randi_range(10,20)
			Comum.player_estacao=true
			var valorporcento=randi_range(10,20)
			var randconsertar=valorporcento * Comum.eu.blindagem.maximo/100.0
			Comum.eu.blindagem.atual=randconsertar
			Comum.mapa.setMsg("e conseguimos consertar sua nave, um pouco. (%s%%). Dá pra voar." % [valorporcento])
			Comum.eu.cash += cashextra
			Comum.mapa.setMsg("Muito obrigado. Conseguimos um extra para você de %s cash" % [cashextra])
			

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo=true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ativo=false
