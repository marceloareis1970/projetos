extends CharacterBody2D

@onready var blindagem: TextureProgressBar = $CanvasLayer/blindagem
@onready var label_estacao: Label = $CanvasLayer/Label


const SPEED = 300.0
var tamanho 
var tempo:float=0



func _ready() -> void:
	Comum.player=self
	label_estacao.text = "Destino: %s" % [Comum.getEstacaoNome()]
	tamanho = DisplayServer.screen_get_size()
	blindagem.max_value=Comum.eu.blindagem.maximo
	blindagem.value=Comum.eu.blindagem.atual

func _physics_process(delta: float) -> void:
	if not Comum.eu.vivo:
		for i in Comum.eu.bag.itens: # destroi toda sua bag
			i.id=""
			i.qtd=0
		queue_free()
	if Comum.station != 1:  #1 - estação do ponto A, #0 - a estação do ponto B
		move(delta)
		shooting(delta)

func _input(event: InputEvent) -> void:
		if Input.is_action_just_pressed("M"):
			Comum.mapa.mapa_normal()
		if Input.is_action_just_pressed("P"):
			Comum.mapa.displayTela()
		if Input.is_action_just_pressed("I"):
			Comum.mapa.displayInventario()

func move(delta)->void:
	var direction_y := Input.get_axis("W", "S")
	if direction_y:
		if position.y < 60:
			position.y = 60
		elif position.y > tamanho.y - 157:
			position.y = tamanho.y - 157
		else:
			velocity.y =  direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	var direction := Input.get_axis("A", "D")
	if direction:
		if position.x < 40:
			position.x = 40
		elif position.x > tamanho.x - 250:
			position.x = tamanho.x - 250
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func getDamage(valor):
	valor =  Comum.eu.blindagem.reforco - valor
	if valor <= 0:
		return false
	Comum.eu.blindagem.atual -= valor
	blindagem.value -= valor
	if Comum.eu.blindagem.atual < 0:
		Comum.eu.blindagem.atual = 0
		Comum.eu.vivo=false
		Comum.eu.cash_extra=true
		var tmp=preload("res://scene/ui/fim_de_jogo/fim_de_jogo.tscn").instantiate()
		Comum.mapa.addTiros(tmp)
	return true
	
func shooting(delta)->void:
	if Comum.warp:
		return
	tempo -= delta
	if tempo < 0:
		tempo=0
	if Input.is_action_pressed("leftbutton") and tempo == 0:
		tempo = 0.1
		var temp=preload("res://scene/tiro/tiro.tscn").instantiate()
		temp.position=global_position
		Comum.mapa.addTiros(temp)
