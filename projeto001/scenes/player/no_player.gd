extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var ativo:bool=false
var inativo:bool=false

func _ready() -> void:
	get_node("player").camera=get_node("Camera3D") # vamos inserir o a camera (no) no player dinamicamente

func _process(delta):
	if Input.is_action_pressed("V"): 
		if !ativo:
			animation_player.play("aproximar")
	else:
		if ativo:
			animation_player.play("distanciar")

func reset():
	ativo=false

func ativar():
	ativo=true
