extends Node3D


var estrutura:Dictionary={}

func _ready() -> void:
	get_parent().set_movimento(false) # cancela o movimento

func _process(delta: float) -> void:
	estrutura.tempo -= delta
	if estrutura.tempo <= 0:
		get_parent().set_movimento(true) # retorna o movimento
		queue_free()
	
#todo: fica interessante colocar umas neves caindo dele
