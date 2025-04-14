extends Node2D

@onready var mapa: Node = $mapa


func _ready() -> void:
	#todo load ultimo save
	Comum.game=self
	Comum.atualizarPrecos()
	trocarParaEstacao()

func _process(delta: float) -> void:
	pass

func trocarParaNave():
	for i in mapa.get_children():
		i.queue_free()
	Comum.warp = false 
	Comum.mob = false
	var temp=preload("res://scene/mapa/mapa.tscn").instantiate()
	mapa.add_child(temp)

func trocarParaEstacao():
	for i in mapa.get_children():
		i.queue_free()
	var temp=preload("res://scene/estacao/estacao.tscn").instantiate()
	mapa.add_child(temp)
