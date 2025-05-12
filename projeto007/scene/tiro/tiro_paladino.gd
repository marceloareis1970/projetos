extends Node3D

var estrutura:Dictionary={
	"damage":50
}

func _physics_process(delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"): # verifico se o algo é um enemy
		# adiciono  damage ao alvo, como será feito em node3D,  
		# seu contato sempre estará abaixo do alvo
		area.get_parent().add_damage(estrutura.damage) 
		if estrutura.has("recochetear"):
			estrutura.recochetear -= 1 # decremento o recochetear do tiro
			if estrutura.recochetear < 0: #se zero, destruo ele
				queue_free()
			else:
				global_transform.basis.y +=Vector3(randf_range(-5,5),0,randf_range(-5,5)) # redireciono o tiro
