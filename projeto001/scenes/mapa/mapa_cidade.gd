extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Comum.eu.pode_atirar=false # dentro da cidade não atira
	if Comum.npcs.has("mapa_cidade"): # verifica se existe este registro em NPC´s
		for i in Comum.npcs.mapa_cidade: # paga todos os NPC´s desta cidade
			pass
	# colocar o elevador para a cidade 001
	var tmp=preload("res://scenes/portal/portal_cidade.tscn").instantiate() # incializa o portal
	add_child(tmp)  # colocaremos na tela
	tmp.destino="regiao_001"  # qual mapa iremos ir ao ativar ele
