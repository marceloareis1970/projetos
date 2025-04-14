extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



var speed:float = 100.0

func _ready() -> void:

	animation_player.speed_scale=randf_range(0.1,5.0)
	if randi_range(0,100) <= 49:
		animation_player.play("start")  #movimento normal
	else:
		animation_player.play_backwards("start") #movimento invertido

func _physics_process(delta: float) -> void:
	if Comum.warp:
		position.y += delta * speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		drop()
		queue_free()

func drop():
	var qtd=randi_range(0,100)
	var qtditens=1
	if qtd < 30:
		qtditens=1
	elif qtd < 80:
		qtditens=2
	else:
		qtditens=3
	for i in qtditens:
		var oque=randi_range(0,Dados.produtos.size()-1)
		qtd=randi_range(1,3)
		if Comum.addBag({"id":Dados.produtos[oque].id,"qtd":qtd}):
			Comum.mapa.setMsg("drop %s de %s" %[qtd,Dados.produtos[oque].descricao])
	
func _on_timer_timeout() -> void:
	queue_free()
