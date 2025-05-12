extends Node3D

var estrutura:Dictionary={}

func _physics_process(delta: float) -> void:
	estrutura.elapsedtime -= delta
	if estrutura.elapsedtime <= 0:
		queue_free()
	else:
		var direcao = -global_transform.basis.z # Quando colocamos o objeto na tela, colocamo sempre com uma sentido e direcao, ou seja, com um vetor
		global_translate(direcao * estrutura.speed * delta ) # movimentamos ele novetor Y (matemos altura)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().add_damage(estrutura.damage) 
		area.get_parent().add_debuff(estrutura.debuff) 
