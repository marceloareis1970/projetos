extends Node3D



var estrutura:Dictionary={
	"damage":50,
	"speed":100,
	"elapsedtime":0.5,
	"recochetear":0
}


func _physics_process(delta: float) -> void:
	estrutura.elapsedtime -= delta
	if estrutura.elapsedtime <= 0:
		queue_free()
	else:
		var direcao = -global_transform.basis.z # Quando colocamos o objeto na tela, colocamo sempre com uma sentido e direcao, ou seja, com um vetor
		global_translate(direcao * estrutura.speed * delta ) # movimentamos ele novetor Y (matemos altura)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"): # verifico se o algo é um enemy
		# adiciono  damage ao alvo, como será feito em node3D,  
		# seu contato sempre estará abaixo do alvo
		area.get_parent().add_damage(estrutura.damage) 
		estrutura.recochetear -= 1 # decremento o recochetear do tiro
		if estrutura.recochetear < 0: #se zero, destruo ele
			queue_free()
		else:
			global_transform.basis.y +=Vector3(randf_range(-5,5),0,randf_range(-5,5)) # redireciono o tiro
	else:
		queue_free() # destruo se bater em qualquer coisa
