extends Node3D

var tempo:float=1.5
var estrutura:Dictionary={}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tempo -= delta
	if tempo <=0:
		queue_free()
