extends Node2D
class_name ENEMY

enum MOVIMENTO{LINEAR,ZIGZAG,CIRCULAR,FORMAR_S}  	# todos os movimentos disponíveis
@export var movimento:MOVIMENTO 					# define qual movimento desta nave
# estas variáveis serão utilizadas de acordo o movimento da nave
@export var velocidade: float = 50.0
@export var amplitude: float = 2.0
@export var frequencia: float = 1.0 			# Oscilações por segundo
@export var raio: float = 5.0
@export var angulo_velocidade: float = 2.0 		# Velocidade angular
var angulo: float = 0.0

# definimos onde escreveremos a nave inimiga (neste exemplo) 
@onready var sprite_2d: Sprite2D = $Sprite2D

# todas as naves inimigas. Estes são so retangulos da imagem principal
var shapes_ships=[
		Rect2(240,144,168,120),
		Rect2(432,136,176,136),
		Rect2(376,312,144,112),
		Rect2(0,288,160,144),
		Rect2(64,144,152,120),
		Rect2(0,0,96,112),
		Rect2(264,8,120,104),
		Rect2(392,8,144,112),
	]
var atirar={
	"atirar":false,
	"tempo":0.0,
	"atual":0
}


func _ready() -> void:
	shapes_ships.shuffle()  # embaralha os rectangles de cada sprite da tela
	sprite_2d.region_rect=shapes_ships.get(0) # a gente pega apenas o primeiro shape
	var rand_atirar=randi_range(0,100)
	if rand_atirar >= 20:
		atirar.atirar=true
		atirar.tempo=randf_range(0.1,1.0)

func _physics_process(delta: float) -> void:
	shooting(delta)
	# abaixo teremos cada movimento sendo executado de acordo com o valor da variável movimento
	match movimento:
		MOVIMENTO.LINEAR:
			position.y += velocidade * delta
		MOVIMENTO.ZIGZAG:	
			position.y += velocidade * delta
			position.x += amplitude * sin(PI * frequencia * position.y / 100)
		MOVIMENTO.CIRCULAR:
			angulo += angulo_velocidade * delta
			position.y += velocidade * delta
			position.x += raio * cos(angulo)
			position.y += raio * sin(angulo)
		MOVIMENTO.FORMAR_S:
			position.y += velocidade * delta
			position.x += amplitude * cos(frequencia * position.y / 100)
	if position.y > 600: 
		queue_free()

func shooting(delta):
	# bem simples, sem analisar bem a posicao do inimigo
	if not Comum.eu.vivo:
		return
	if atirar.atirar:
		atirar.atual -= delta
		if atirar.atual < 0:
			atirar.atual = atirar.tempo
			var tiro=preload("res://scene/tiro/tiro_inimigo.tscn").instantiate()
			tiro.position=global_position
			Comum.mapa.addTiros(tiro)
			tiro.look_at(Comum.player.position)

func die():
	if randi_range(0,100)>70: #probabilidade de 70% de dropar qualquer coisa
		var tmp=preload("res://scene/carga/carga.tscn").instantiate()
		tmp.position=global_position
		Comum.mapa.addTiros(tmp)
	queue_free()
