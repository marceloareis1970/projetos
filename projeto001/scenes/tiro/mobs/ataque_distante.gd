extends CharacterBody3D


@onready var som: AudioStreamPlayer3D = $som

var posicao_inicial:Vector3
var posicao_final:Vector3
var p2:Vector3
var p3:Vector3
var damage:float=10
var duration:float=1.5 # Tempo para atingir o alvo. Praticamente é a a velocidade do tiro
var time := 0.0 # tempo para indicar onde pegaremos o ponto na equação formada cubic_bezier veja:https://docs.godotengine.org/en/latest/tutorials/math/beziers_and_curves.html

func _ready():
	p2=(posicao_inicial + posicao_final) / 2 + Vector3(-0.1,5,-0.1) # pega a méida da distancia e adiciona Vector3(-0.1,5,-0.1) para se aproximar mais do ponto origem
	p3=(posicao_inicial + posicao_final) / 2 + Vector3(0.1,5,0.1) # pega a méida da distancia e adiciona Vector3(0.1,5,0.1) para se aproximar mais do ponto final
	
func _physics_process(delta: float) -> void:
	if time < duration:
		var t = time / duration # Normalizar tempo entre 0 e 1
		global_position = Comum.cubic_bezier(posicao_inicial,p2,p3,posicao_final,t) # executa o cálculo e retorna a posicao em T tempos
		time += 0.01  # aumenta o tempo na função trajetoria_da_curva
	else:
		queue_free()  # chegou ao mob, então some, e não acertou nada

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"): # detecta se o alvo é um player
		body.add_damage(damage)  # adiciona um damage no player
		som.play() # quando acertar, toca um som
		if randf_range(0,100)>50: # pega um número randomico e se for maior que 
			body.add_pralisia_pernas(randf_range(2.0,5.0)) # faz com que ele fique preso por um tempo definido pelo randomico
		queue_free() # atingiu um player então vamos fazer com que seja destruido
