extends Node2D

var tempo:float = 1.5
var speed:float = 500.0

func _process(delta: float) -> void:
	tempo -= delta
	if tempo < 0:
		queue_free()

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.getDamage(randi_range(10,20)): # se retornar true,indica que a nave sofreu dano
			var tmp=preload("res://scene/explosao/explosao.tscn").instantiate()
			tmp.position=global_position
			Comum.mapa.addTiros(tmp)
		queue_free()
