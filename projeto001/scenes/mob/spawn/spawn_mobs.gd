extends Node3D

@onready var lista: Node3D = $lista

var mobs=[]
var array_mobs=[
	preload("res://scenes/mob/mob.tscn"), # mob qualquer
	preload("res://scenes/mob/mob.tscn"), # mob qualquer
	preload("res://scenes/mob/mob.tscn"), # mob qualquer .. add mais mobs ao seu gosto
]
var tamanho:int=randi_range(1,3) # idnica quanto mobs teremos neste spawn de mobs

func _ready() -> void:
	for i in range(0,tamanho): # iteracao de 0 .. tamanho - 1
		var tmp=array_mobs[randi_range(0,array_mobs.size()-1)].instantiate() # pego o mob da lista randomicamente
		lista.add_child(tmp) # adiciono ao ponto de spawn 
		tmp.global_position.x += randf_range(-3,3) # randomizo a posicao atual de -3 até 3
		tmp.global_position.z += randf_range(-3,3) # randomizo a posicao atual de -3 até 3
		tmp.rotation_degrees.y=randi_range(0,360) # rotaciono o mob para não aparecerem todos na mesma direcao
		
func _physics_process(delta: float) -> void:
	if global_position.distance_to(Comum.player.global_position) > 30: # detruir o slot se chegar a mais  de 30 metros do player
		if lista.get_child_count() > 0: # indica que ainda existem mobs, então, poderá receber um respawn
			Comum.mapa.removerSpawnMobsDaLista("%s_%s_%s" % [position.x,position.y,position.z]) # se existe, remove da listagem 
		queue_free() # destroi este nó de spawn de mobs
