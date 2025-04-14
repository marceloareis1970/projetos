extends CharacterBody3D

# penso que podemos fazer de duas formas os mobs
# a primeira seria um código único que teria o STATE machine para definir como agir e 
# a segunda forma seria um código para cada

# se o mob apareceu, indica que o player encontra-se próximo a ele, então já tem o player como alvo

@onready var marker_3d: Marker3D = $bicho/Marker3D
@onready var bicho: Node3D = $bicho
@onready var timer: Timer = $Timer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var som_perto: AudioStreamPlayer3D = $som_perto

var estrutura={} # esta variável expressa tudo que este mob terá, como damage dado, vida etc
var rotation_speed := 2.0 # Velocidade da rotação

func _ready() -> void:
	var tamanho=randf_range(0.1,1)
	bicho.scale=Vector3(tamanho,tamanho,tamanho)
	if estrutura.is_empty():
		estrutura={
			"vivo":true, # se esta vivo ou não
			"hp":100, # hp deste mob
			"velocidade":10.0, # velocidade em que o mob anda até o alvo
			"ataque":{
				"pode_atacar":false, # qndo entramos na visao do mob, fica verdadeiro epodemos atacar
				"velocidade":randf_range(0.1,2), # velocidade de cada ataque
				"distancia_minima":5, # distancia mínima para emitir um ataque proximo
				"distancia_maxima":20, # distancia máxima para emitir um ataque a distância
				"fator":0.2,  # fator que aplicamos ao damage para um ataque a distância
				"tempo":{
					"atual":0, # qndo chega a zero, indica que pode atacar
					"maximo":2.5 # qndo atacamos, o contador atual passa a ser o valor de máximo, intevalo entre ataques
				},
				"tempo_distancia_maxima":{ # permite atirar em intervalos
					"atual":0, # qndo chega a zero, indica que pode atacar
					"maximo":2.5 # qndo atacamos, o contador atual passa a ser o valor de máximo, intevalo entre ataques
				},
				"damage":randf_range(10,20), #dano dado pelo mesmo no ataque
			}
		}

func _process(delta: float) -> void:
	if not estrutura.vivo: # se nosso mob estiver morto vivo=false, ele sai, só espera sair da tela
		return
	estrutura.ataque.tempo.atual -= delta # decrementa o tempo para algum ataque
	if estrutura.ataque.tempo.atual < 0: # se for menor que zero
		estrutura.ataque.tempo.atual=0 # mantem em zero e só altera quando atacar
	estrutura.ataque.tempo_distancia_maxima.atual -= delta
	if estrutura.ataque.tempo_distancia_maxima.atual < 0: # se for menor que zero
		estrutura.ataque.tempo_distancia_maxima.atual=0 # mantem em zero e só altera quando atacarf
	olhar_para(delta) # rotaciona o mob para olhar para o player.. lentamente
	pode_atacar(delta) # verifica se pode atacar, e se puder, ataca. Se atacou retornou true senao false. Isso pode ajudar a agir de uma forma diferente , tipo pausar por segundos apos o ataque, etc
	movimentar(delta)

func movimentar(delta):
	var direction = (Comum.player.global_transform.origin - global_transform.origin).normalized()
	velocity = direction * estrutura.velocidade * delta
	move_and_slide()

func pode_atacar(delta)->bool: # funcção que verifica se ataca ou não e se atacar qual atq vai usar
	var distancia=global_position.distance_to(Comum.player.position) # pega a distancia até o player
	if estrutura.ataque.distancia_minima >= distancia: # se for maior ou igual a menor distancia, infringe ataque proximo
		if estrutura.ataque.tempo.atual == 0:
			ataque_proximo(delta) #cria o ataquel proximo
			estrutura.ataque.tempo.atual  =  estrutura.ataque.tempo.maximo # reposiciona para o valor de inicio da contagem do tempo
			return true # retornou informando que conseguiu um ataque
	elif estrutura.ataque.distancia_maxima >= distancia: # se for maior ou igual a maior distancia, infringe ataque a distância
		if estrutura.ataque.tempo_distancia_maxima.atual == 0:
			ataque_longe(delta) # cria o ataque a distância
			estrutura.ataque.tempo_distancia_maxima.atual  =  estrutura.ataque.tempo_distancia_maxima.maximo # reposiciona para o valor de inicio da contagem do tempo
			return true # retorna inforado que conseguiu um ataque
	return false # retorna informando que não conseguiu um ataque

func olhar_para(delta):
	var target_transform = Transform3D() # para criar uma cópia do original
	target_transform.origin = global_transform.origin # duplico a origem do mob
	target_transform.basis = Basis().looking_at(Comum.player.position - global_transform.origin, Vector3.UP)

	# Interpolar cada eixo separadamente para um movimento suave
	rotation.x = lerp_angle(rotation.x, target_transform.basis.get_euler().x, delta * rotation_speed) # qnto mais longe, mais proximo de 1, e quanto mais perto mais proximo de zero. Este valor, será a relação de delta * rotacao_speed para X
	rotation.y = lerp_angle(rotation.y, target_transform.basis.get_euler().y, delta * rotation_speed) # para y - Esta se a target estivar acima ou abaixo, senão nem precisa esta rotação
	rotation.z = lerp_angle(rotation.z, target_transform.basis.get_euler().z, delta * rotation_speed) # para z
	position.y=0 # evitar que o olhe para o chão, visto que o ponto de origem é o meio do player, que pode dar diferenca
	move_and_slide()

func ataque_proximo(delta):
	som_perto.play() # emite um som pelo ataque emitido
	Comum.player.add_damage(estrutura.ataque.damage) # ataque cheio
	
func ataque_longe(delta):
	if not estrutura.ataque.pode_atacar: #Não está na área de ataque ainda do mob
		return
	# como é um ataque de aranha, vamos fazer da seguinte forma
	# o ataque sai para cima e cai na posicao, e para isso utilizaremos a função curva.
	var tmp=preload("res://scenes/tiro/mobs/ataque_distante.tscn").instantiate() # instanciamos o tiro desejado
	tmp.damage = estrutura.ataque.damage *  estrutura.ataque.fator # o fator permite utilizar apenasa x% (fator) do ataque, por ser adistância
	tmp.transform = marker_3d.global_transform
	tmp.posicao_inicial = marker_3d.global_position
	tmp.posicao_final = Comum.player.global_position
	Comum.mapa.addObjeto(tmp,"tiros") # vamos colocar o tiro fora do mob pq se o mob morrer, todos seus tiros morrem automaticamente.

func _on_timer_timeout() -> void:
	queue_free() # o mob já tinha morrido e passou 5 segundos, vamos remover da visão do player

func addDamage(damage):
	estrutura.hp -= damage 		# decrementa damage do mob
	if estrutura.hp <= 0: 		# se hp do mob for menor ou igual a zero
		estrutura.vivo = false 	# estrutrua.vivo passa a ser falso
		# rotina de drop 
		timer.start() # inicia um tempo para desaparecer ele da tela
		collision_shape_3d.queue_free() # remove o bloqueador para outros mobs e o player possam passar por cima dele

func _on_pode_atacar_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):  # testa para saber se é um player - entrou na região de ataque, ou seja, na frente do mob
		estrutura.ataque.pode_atacar=true # se sim, indica que pode atacar a distancia

func _on_pode_atacar_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"): # verifica se o player saiu da área de detecção
		estrutura.ataque.pode_atacar=false # cancela poder atacar a distancia
