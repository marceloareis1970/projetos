extends Node3D

@onready var no_texture_progress_bar: TextureProgressBar = $CanvasLayer/Panel/TextureProgressBar
@onready var no_label: Label = $CanvasLayer/Panel/Label


var ativo:bool=false

func _ready() -> void:
	no_label.visible=ativo

func _physics_process(delta: float) -> void:
	no_label.visible=ativo
	if ativo and not Comum.campo.temos_boss:
		if Input.is_action_pressed("F"):
			no_texture_progress_bar.value += 1
			if no_texture_progress_bar.value == no_texture_progress_bar.max_value:  # chamar o boss
				Comum.campo.addBoss(false) # adicionar o boss no mapa
				queue_free() # não precisamos mais desta tela
		else:
			no_texture_progress_bar.value = 0
	if Comum.campo.temos_boss:
		queue_free() # o boss já foi chamando, ficou desnecessário isto

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not Comum.campo.temos_boss:
		ativo=true
		no_texture_progress_bar.value = 0

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=false
