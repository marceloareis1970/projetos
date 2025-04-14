extends Node3D

var tempo:float=1.5
var estrutura={}

func _physics_process(delta: float) -> void:
	tempo -= delta
	if tempo < 0:
		queue_free()
	var direcao = -global_transform.basis.z
	global_translate(direcao * estrutura.speed * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.addDamage(estrutura.damage)
		queue_free()
	if body.is_in_group("wall"):
		queue_free()
