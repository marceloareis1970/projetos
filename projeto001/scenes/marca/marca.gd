extends Node3D

var tempo:float=0.5

func _process(delta: float) -> void:
	tempo -= delta
	if tempo < 0:
		queue_free()
