extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const speed = 300.0

func _physics_process(delta: float) -> void:
	if Comum.player_estacao:
		look_at(get_global_mouse_position())
		var move_input = Input.get_axis("S", "W")
		velocity = transform.x * move_input * speed
		if move_input:
			animation_player.play("andar")
		else:
			animation_player.play("idle")
		move_and_slide()

func _input(event: InputEvent) -> void:
		if Input.is_action_just_pressed("M"):
			Comum.mapa.mapa_normal()
		if Input.is_action_just_pressed("P"):
			Comum.mapa.displayTela()
		if Input.is_action_just_pressed("I"):
			Comum.mapa.displayInventario()
		if Input.is_action_just_pressed("F1"):
			Comum.mapa.ajuda()
		if Input.is_action_just_pressed("H"):
			Comum.mapa.HiperDriver()
