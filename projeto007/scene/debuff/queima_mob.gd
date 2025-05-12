extends Node3D

var estrutura:Dictionary={}

func _process(delta: float) -> void:
	estrutura.tempo -= delta
	if estrutura.tempo <= 0:
		queue_free()
	get_parent().add_damage(estrutura.damage)
