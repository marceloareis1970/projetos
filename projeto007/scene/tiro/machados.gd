extends Node3D

var estrutura={
"damage":100,
"tempo":{"atual":5,"maximo":5}
}

func _ready() -> void:
	estrutura.tempo.atual=estrutura.tempo.maximo

func _process(delta: float) -> void:
	estrutura.tempo.atual -= delta
	if estrutura.tempo.atual <= 0:
		queue_free()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().add_damage(estrutura.damage)
		
