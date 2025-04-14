extends CharacterBody3D


const move_speed = 5.0
const JUMP_VELOCITY = 4.5
var moving:bool=false
var target_position:Vector3
@onready var marker_3d: Marker3D = $Marker3D
@onready var grade_skills: GridContainer = $UI/g

@export var camera:Camera3D
var vetorcamera=Vector3(0,13,7)
var pode_se_mover:float = 0.0

func _ready():
	Comum.player = self # referencio esta variavel em comum para ser recuperada em outras partes do código
	get_parent().get_node("Camera3D").global_position = global_position + vetorcamera
	atualizar_skills() # atualizar todos os icones de skill do player

func _physics_process(delta: float) -> void:
	if not Comum.eu.mover: # verifica se pode ou não se mover
		return
	pode_se_mover -= delta # decrementa poder se mover
	if pode_se_mover < 0: #veita de ficar abaixo de zero
		pode_se_mover=0
	if pode_se_mover == 0: # se pode se mover, ok senão pula a ação de se mover
		if not is_on_floor():
			velocity.y -= 9.0
			move_and_slide()
		movimento(delta)
	olhar_para()	# redireciona a visao do player para onde encontramos o mouse
	atirar(delta)	# analisea se pode atirar ou nao
	get_parent().get_node("Camera3D").global_position = global_position + vetorcamera # posiciona a camera acima do player + vetorcamera (a visão fixa)
	#if Input.is_action_just_pressed("SPACE"):
		#Comum.lista_posicao.append({"x":global_position.x,"y":global_position.y,"z":global_position.z})
	#if Input.is_action_just_pressed("ENTER"):
		#print_debug(Comum.lista_posicao)
	
func _input(event):
	if not Comum.eu.mover: # verifica se pode ou não se mover. neste caso não executa nada deste player
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var space_state = get_world_3d().direct_space_state 
		var ray_origin = get_viewport().get_camera_3d().project_ray_origin(event.position) #
		var ray_end = ray_origin + get_viewport().get_camera_3d().project_ray_normal(event.position) * 1000
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result = space_state.intersect_ray(query)
		if result:
			target_position = result.position
			target_position.y=global_position.y
			var tmp=preload("res://scenes/marca/marca.tscn").instantiate() #instancia o objeto onde marca o local do click do mouse
			tmp.position=target_position # posiciona o objeto que marca o click do mouse
			Comum.mapa.addObjeto(tmp,"marca") # posiciona a marca do click do mouse na tela
			moving = true #libera o player para mover até a marca

func olhar_para():
	# Rotação para olhar na direção do mouse
	var mouse_pos = get_viewport().get_mouse_position()
	var space_state = get_world_3d().direct_space_state
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	var result = space_state.intersect_ray(query)
	if result:
		var look_at_point = result.position
		look_at_point.y = global_transform.origin.y  # Mantém rotação no plano horizontal
		look_at(look_at_point)

func movimento(delta):
	if moving: # se pode mover, pegaremos distancia destino  esubitrairemos da distancia do player
		var direction = (target_position - global_transform.origin).normalized() # normalized é para transformar os valores entre -1 até 1, para x,y,z
		velocity = direction * move_speed  # aplicamos move_speed para mover na direçao desejada (velocidade). Se usar o delta, lembra-se de amuentar o valor da speed senão parecerá bem lento
		move_and_slide() # registra o movimento do character3D

	# Verifica se chegou ao destino
	if global_transform.origin.distance_to(target_position) < 0.2: # se a distância for < 0.2, setar o moviemnto para zero
		moving = false # não vamos mais mover
		velocity = Vector3.ZERO # setamos a velocidade para ZERO

		look_at(target_position) # Faz o jogador olhar para onde está indo

func atirar(delta):
	if not Comum.eu.pode_atirar: #setada para não poder atirar
		return
	var atalhos=["q","w","e","r","t"]
	for i in range(0,5): # são 5 stalhos
		var key=atalhos[i] # pega o valor do atalho na posicao i para analisar no codigo abaixo
		if not Comum.eu.atalhos.get(key).is_empty(): # se existe uma arma em W associada .. 
			Comum.eu.atalhos.get(key).deltatempo.atual -= delta # pega o tempo de W e subtrai delta dele
			grade_skills.get_node("p%s"%[i]).get_node("t1/t2").value=Comum.eu.atalhos.get(key).deltatempo.atual * 10 # multipliquei por 10 para ficar visivel. Este é o progressbar da skill pressionada
			if Comum.eu.atalhos.get(key).deltatempo.atual < 0: # se for menor que zero,,, coloca em ZERO para testar
				Comum.eu.atalhos.get(key).deltatempo.atual=0
			if Input.is_action_pressed(key.to_upper()): # se pressionado W, indicando que queremos utilizar esta arma ..
				if Comum.eu.atalhos.get(key).deltatempo.atual == 0: # se o tempo já se passou ...
					Comum.eu.atalhos.get(key).deltatempo.atual = Comum.eu.atalhos.get(key).deltatempo.maximo # retorna o tempo para seu valor inicial (origem) para ser decrementando...
					var nome=Comum.getArma(key.to_upper()) # a função retornará o arquivo certo em W
					if nome != null: # se conseguiu o arquivo correto, então voltará o path do arquivo a se executado
						var tmp=load(nome).instantiate() # instancie o arquivo retornado
						tmp.estrutura=Comum.eu.atalhos.get(key) # replica o valor da arma utilizada para a arma
						tmp.transform=marker_3d.global_transform # marca origem, direção (vetor) do player -> marca_3d
						Comum.mapa.addObjeto(tmp,"tiros") # adicione o tiro ao mapa

func add_pralisia_pernas(valor): # se recebe um ataque que impedirá de andar
	pode_se_mover = valor # seta para evitar que o player se mova
	
func add_damage(valor): # damage recebido dos mobs ou qqr outra coisa no ambiente
	print_debug(valor)

func atualizar_skills():
	var atalhos=["q","w","e","r","t"] # todos os atalhos listados
	for i in range(0,5): # iteracao de zero ate 4  inclusos
		var id=Comum.eu.atalhos.get(atalhos[i]) # pega o valor de atalho
		if id != {}: # se for diferente de vazio,
			grade_skills.get_node("p%s"%[i]).get_node("t1/t2").max_value=id.deltatempo.maximo * 10 # multipliquei por 10 para ficar visivel
			grade_skills.get_node("p%s"%[i]).get_node("t1/t1").texture=Comum.getImageById(id.id,false) # coloca a imagem
		else:
			grade_skills.get_node("p%s"%[i]).get_node("t1/t1").texture=null # senão, colocaremos null, limpara a imagem antiga
		grade_skills.get_node("p%s"%[i]).get_node("t1/t2").value=0 # zera o valor, inicializar desta forma
