extends Node3D

@onready var no_camera_3d: Camera3D = $n/Camera3D
@onready var no_animation: AnimationPlayer = $AnimationPlayer



var player  # Referência ao Player
var last_hidden_objects = []  # Objetos que foram tornados transparentes
var vetorcamera=Vector3(0,15,7)

func _ready() -> void:
	player = get_node("player")
	player.vetorcamera = vetorcamera
	player.camera = no_camera_3d
	no_camera_3d.player_node=player

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Z"):
		no_animation.play("zoom_in")
	elif Input.is_action_just_released("Z"):
		no_animation.play_backwards("zoom_in")
