extends Node3D

@onready var no_animation: AnimationPlayer = $mob/AnimationPlayer

enum TIPO_MOBS{BOLA,CACHORRO,UM_OUTRO,MAIS_UM,CONTINUA_VOCE}
@export var tipo_mob:TIPO_MOBS=TIPO_MOBS.BOLA
var estrutura={
	"hp":5,
	"xp":50,
	"vivo":true,
	"tempo_vivo":15,
	"speed":5,
}
var ativo:bool=true
var libera_movimento_cogelado:bool=true
var itens_drop=[
	{"id":"drop_001","porcentagem":100},
] # colocamos aqui os drops comums e suas probabilidade de drops
var itens_drop_extras=[] 
# neste array "itens_drop_extras" colocaremos os itens de qualquer quest
# que é exclusivo do mob instanciado, ou seja, a análise e preenchimento deve
# se incluida apenas na criação do mob

func _ready() -> void:
	estrutura.hp = Comum.campo.calcularHPInimigo(100)

func _physics_process(delta: float) -> void:
	if ativo and libera_movimento_cogelado:
		movimentar(delta)
	escolhendo_tipo_ataque()
	escolhendo_tipo_ataque_perto()


func escolhendo_tipo_ataque():
	match tipo_mob:
		TIPO_MOBS.BOLA:
			pass
		TIPO_MOBS.CACHORRO:
			pass
		TIPO_MOBS.UM_OUTRO:
			pass
		TIPO_MOBS.MAIS_UM:
			pass
			
func escolhendo_tipo_ataque_perto():
	match tipo_mob:
		TIPO_MOBS.BOLA:
			pass
		TIPO_MOBS.CACHORRO:
			pass
		TIPO_MOBS.UM_OUTRO:
			pass
		TIPO_MOBS.MAIS_UM:
			pass

func movimentar(delta):
	if global_position.distance_to(Comum.player.global_transform.origin) > 1:
		no_animation.play("andando")
		look_at(Comum.player.global_transform.origin)
		var direcao = -global_transform.basis.z # Quando colocamos o objeto na tela, colocamo sempre com uma sentido e direcao, ou seja, com um vetor
		global_translate(direcao * estrutura.speed * delta ) # movimentamos ele novetor Y (matemos altura)
	else:
		no_animation.play("ataque")

func add_debuff(qual:Dictionary) -> void:
	if qual.is_empty():
		return
	var tmp = load("res://scene/debuff/%s.tscn" % [ qual.id ]).instantiate() # carreo o debuff correto
	tmp.estrutura=qual.duplicate() # duplico a estrutura de comandos
	add_child(tmp) # adiciono ao mob

func add_damage(damage) -> void:
	if not estrutura.vivo: # evitará duplicidades
		return
	estrutura.hp -= damage
	if estrutura.hp <= 0:
		estrutura.vivo=false
		drop()
		Comum.campo.addXP(estrutura.xp)
		queue_free()

func set_movimento(lMovimento:bool) ->void:
	no_animation.stop()
	libera_movimento_cogelado = lMovimento

func drop():
	# podemos analisar se é um item q será dropado de uma quest, teste sua probabilidade de drop etc
	# ideal seria algo
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=false

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=true
