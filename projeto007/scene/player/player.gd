extends CharacterBody3D

@export var camera:Camera3D
@export var dash_speed = 15.0  # Velocidade durante o dash
@export var dash_duration = 1.5  # Tempo do dash (segundos)
@export var double_click_threshold = 0.3  # Tempo máximo entre dois cliques rápidos (segundos)

@onready var no_player: Node3D = $player
@onready var no_marca: Marker3D = $player/marca
@onready var no_braco_marcador: Node3D = $player/braco_marcador
@onready var no_espada: Marker3D = $player/espada
@onready var no_target: Node3D = $player/on_esta_o_boss/target


var is_dashing = false
var dash_timer = 0.0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var vetorcamera:Vector3=Vector3(0,15,3)
var last_pressed_time = {}  # Armazena o tempo de pressão de cada tecla
var moving:bool=true
var target_position:Vector3
var acerto_y=0 #POG
var mascfem:String
var target = null # se este target for valido, indica que temos um target para ir

func _ready() -> void:
	Comum.player=self
	if Comum.eu.sexo == "f":
		var tmp=preload("res://scene/player/feminino.tscn").instantiate()
		no_player.get_node("player").add_child(tmp)
		mascfem="feminino"
	else:
		var tmp=preload("res://scene/player/masculino.tscn").instantiate()
		no_player.get_node("player").add_child(tmp)
		mascfem="masculino"
	await get_tree().process_frame
	if Comum.onde_estou == "campo":
		Comum.campo.atualizaStatus()
		position = Vector3.UP
		Comum.campo.addFoto()
	elif Comum.onde_estou == "cidade":
		Comum.cidade.identificacao()
	acerto_y=position.y
	resetarDados()

func _physics_process(delta: float) -> void:
	movimento(delta)
	moverCamera()
	if Comum.onde_estou == "campo":
		tiro(delta)
		recuperarHP(delta)
		todo_ataques(delta)

func resetarDados():
	Comum.eu.arma.damage = 50
	Comum.eu.arma.tempo={"atual": 0.0,"maximo": 0.5}
	Comum.eu.atributos={"cura": 2,"defesa": 2,"mana": 2,"velocidade_ataque": 2}
	Comum.eu.extras=[]
	Comum.eu.hp={"atual": 300,"maximo": 300}
	Comum.eu.mp={"atual": 300,"maximo": 300}
	Comum.eu.nivel={"atual": 1,"maximo": 99}
	Comum.eu.tempo_recupera_hp={"atual": 0,"maximo": 10}

func recuperarHP( delta ):
	# Esta rotina se destina a receber cura a cada tempo passado, qndo recebe, o tempo 
	# vai a 0.5 para não ficar carregando tudo de uma vez só
	if not Comum.eu.vivo: # verificar se vc está vivo, se não estiver, sai
		return
	Comum.eu.tempo_recupera_hp.atual -= delta # decrementa este tempo, para recuperar tempo
	if Comum.eu.tempo_recupera_hp.atual < 0:
		Comum.eu.tempo_recupera_hp.atual = 0.5
		recebeMana(Comum.eu.atributos.mana)
		recebeCura(Comum.eu.atributos.cura) # faz a atualização d cura

func recebeMana(valor) -> void:
	Comum.eu.mp.atual +=  valor
	if Comum.eu.mp.atual > Comum.eu.mp.maximo:
		Comum.eu.mp.atual = Comum.eu.mp.maximo
	Comum.campo.atualizaStatus()

func recebeCura(valor) ->void:
	Comum.eu.hp.atual +=  valor
	if Comum.eu.hp.atual > Comum.eu.hp.maximo:
		Comum.eu.hp.atual = Comum.eu.hp.maximo
	Comum.campo.atualizaStatus()


func movimento(delta):
	if moving: # se pode mover, pegaremos distancia destino  esubitrairemos da distancia do player
		if not is_on_floor():
			velocity += get_gravity() * delta * 100
			move_and_slide()
		var space_state = get_world_3d().direct_space_state
		var mouse_pos = get_viewport().get_mouse_position()
		var result=getPosicaoCamera(mouse_pos)
		if result:
			target_position = result.position
			target_position.y=acerto_y
		var move_direction = (target_position - global_transform.origin).normalized()
		var input = 0
		if Input.is_action_pressed("W"):
			input += 1
		if Input.is_action_pressed("S"): 
			input -= 1
		velocity = move_direction * SPEED * input
		move_and_slide()
		if input != 0:
			if input == 1:
				no_player.get_node("player/%s" % [mascfem]).play("walk")
			else:
				no_player.get_node("player/%s" % [mascfem]).play("walk",false)
		else:
			no_player.get_node("player/%s" % [mascfem]).play("idle")
	else:
		no_player.get_node("player/%s" % [mascfem]).play("idle")

func moverCamera()->void:
	get_parent().get_node("n/Camera3D").global_position = global_position + vetorcamera

func _unhandled_input(event)->void:
	if event is InputEventKey:  # Detecta teclas pressionadas
		var key = event.keycode
		var move_keys = [KEY_W, KEY_A, KEY_S, KEY_D]
		if key in move_keys:
			var current_time = Time.get_ticks_msec() / 1000.0  # Tempo atual em segundos
			if key in last_pressed_time and current_time - last_pressed_time[key] < double_click_threshold:
				start_dash()
			last_pressed_time[key] = current_time
	if event is InputEventMouseMotion:  # Detecta o movimento do mouse
		var mouse_pos = event.position
		var result=getPosicaoCamera(mouse_pos)
		if result.has("position"):  # Se o raio acertar alguma superfície
			result.position.y=global_position.y # alinhamos com o player. Assim não teremos nenhuma visão para o chao do mouse
			no_player.look_at(result.position,Vector3.UP)  # Faz o player olhar para o ponto, somente o player (mesh)

func getPosicaoCamera(mouse_pos):
	var query = PhysicsRayQueryParameters3D.new()
	var ray_origin=camera.project_ray_origin(mouse_pos)
	var ray_to = camera.project_ray_normal(mouse_pos)
	query.from = ray_origin
	query.to =  ray_origin + ray_to * 1000
	query.exclude=Comum.colisores_excluidos
	query.collide_with_bodies = true
	query.collide_with_areas = false
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	return result
		
func start_dash()->void:
	is_dashing = true
	dash_timer = dash_duration

func tiro(delta)->void:
	if not Input.is_action_pressed("LFB"):
		return
	Comum.eu.arma.tempo.atual -= delta #cadencia entre tiros
	if Comum.eu.arma.tempo.atual > 0: #indica que não passou o tempo
		return
	if Comum.eu.arma.qtd.maximo != -1: # verificar se esta arma nunca precisará recarregar
		Comum.eu.arma.qtd.atual -= 1 # decrementamos uma bala
		if Comum.eu.arma.qtd.atual < 0: # se for zero, computamos o tempo para recarregar a arma
			return
	else:
		Comum.eu.arma.tempo.atual = Comum.eu.arma.tempo.maximo
	var tmp=load("res://scene/tiro/tiro_%s.tscn" % [ (Comum.eu.classe as String).to_lower() ]).instantiate() # o tiro
	if (Comum.eu.classe as String).to_lower() == "paladino":
		no_espada.add_child(tmp)
	else:
		Comum.mapa.addTiro(tmp)
		tmp.global_transform = no_marca.global_transform

func todo_ataques(delta)->void:
	for i in Comum.eu.extras:
		i.tempo.atual -= delta
		if i.tempo.atual < 0:
			i.tempo.atual = i.tempo.maximo
			# se este ataque utiliza mana eve se tem mana suficiente para lancar
			if i.has("mana"):
				if Comum.eu.mp.atual - i.mana >= 0:
					Comum.eu.mp.atual-= i.mana
				else:
					i.tempo.atual = 0.2 # coloca para liberar mais a frente
					continue
			var tmp=load("res://scene/tiro/%s.tscn" % [i.arquivo]).instantiate()
			tmp.estrutura=i.duplicate() # para não passar por referencia
			if ["machados"].find(i.arquivo) > -1 : # são magias que estao coladas no corpo do player
				add_child(tmp) # ara não utilizar a rotação para acelerar os ataques
			else:
				Comum.mapa.addTiro(tmp) # são magias/ataques que estão no ambiente, independete do player
				tmp.global_transform = no_marca.global_transform # passamos o VETOR (tem sentido e direcao)

func AddDamage(damage) -> void:
	if not Comum.eu.vivo:
		return
	Comum.eu.hp.atual -= damage
	if Comum.eu.hp.atual <= 0: # morri!! (porpaganda bem antiga)
		Comum.eu.hp.atual = 0
		#Comum.eu.vivo=false #suspender por enquanto
