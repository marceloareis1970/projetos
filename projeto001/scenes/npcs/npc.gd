extends CharacterBody3D

enum TIPO_DE_NPC{CRIAR_RECEITAS,ALTERAR_SKILLS} # o que ele faz- lista
@export var tipo_de_npc:TIPO_DE_NPC = TIPO_DE_NPC.CRIAR_RECEITAS
@onready var interface_tipo_de_npc: Control = $UI/item

enum QUAL_NPC{OLDMAN,MICHELLE}  # personagens - lista
@export var qual_npc:QUAL_NPC= QUAL_NPC.OLDMAN # indica qual tipo estamos de npc estamos utilizando
@onready var personagem: Node3D = $personagem
@onready var panel: Panel = $UI/Panel

@onready var trabalho: Label3D = $trabalho

var ativo:bool=false # indica se o player chegou até a regiao de contato (area3d)

func _ready() -> void:
	panel.visible=false # deixamos de visualizar qndo criamos o texto 
	#vamos carregar o npc que foi definido
	match qual_npc: # swith o valor em qual_npc tem
		QUAL_NPC.OLDMAN: # se for oldman, carregamos ele e inserimos em personagem
			var tmp=preload("res://scenes/npcs/tipos/oldman.tscn").instantiate()
			personagem.add_child(tmp) # adicionar ao npc para ser visualizada o personagem definido
		QUAL_NPC.MICHELLE:
			var tmp=preload("res://scenes/npcs/tipos/michelle.tscn").instantiate()
			personagem.add_child(tmp) # adicionar ao npc para ser visualizada o personagem definido
		# você poderá escolher outros para colocar aqui
	match tipo_de_npc: # carregar a interface de trabalho do npc correto
		TIPO_DE_NPC.CRIAR_RECEITAS: # carregar criar receitas
			trabalho.text="Receitas" # descreve o seu trabalho,que é fazer receitas
		TIPO_DE_NPC.ALTERAR_SKILLS: # carregar skills
			trabalho.text="Habilidades" # descreve o seu trabalho que é desabilitar habilidades

func _physics_process(delta: float) -> void:
	panel.visible=ativo # resetamos no início
	if not is_on_floor(): # para se colocar-mos o npc flutuando, ele sera setado nesta posicao
		velocity.y -= 9.0 # jogamos o character para o chao até achar algo
		move_and_slide() # registramos o movimento corretamente, utilizando a física definida (apneas mover e deslisar)
	if ativo:
		if Input.is_action_just_pressed("F"): #somente se estiver ativo, que analisamos o pressionamento da letra F
			ativo=false# para desaparecer o display de pressionar a letra na tela
			match tipo_de_npc: # carregar a interface de trabalho do npc correto
				TIPO_DE_NPC.CRIAR_RECEITAS: # carregar criar receitas
					var tmp=preload("res://scenes/ui/receitas/ui_receitas_criar.tscn").instantiate() # instanciar a tela de receitas
					interface_tipo_de_npc.add_child(tmp) # adicionar ao npc para ser visualizada
				TIPO_DE_NPC.ALTERAR_SKILLS: # carregar skills
					var tmp=preload("res://scenes/ui/alterar_skill/ui_alterar_skill.tscn").instantiate() # instanciar a tela de receitas
					interface_tipo_de_npc.add_child(tmp) # adicionar ao npc para ser visualizada

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"): # se detectamos que o player entrou na área de contato
		ativo=true # registramos que estpa dentro da área de contato

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"): # se detectamos que o player saiu da área de contato
		ativo=false # desativamos sua análise
