extends Node2D

var tempo:float = 1.5
var angulo:float = deg_to_rad(90)
var velocidade:float = 500.0

func _process(delta: float) -> void:
	tempo -= delta
	if tempo < 0:
		queue_free()
	global_position.y -= sin(angulo) * velocidade * delta
	global_position.x += cos(angulo) * velocidade * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.get_parent().die() 
		queue_free()
