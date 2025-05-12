extends TextureProgressBar
#Autor:https://gameidea.org/2024/12/13/making-a-health-bar-and-health-system-in-godot/  in 03/05/2025 (dd/mm/yyyy)


@onready var no_nivel: Label = $Label

var camera: Camera3D
var vetorcamera:Vector3

func _ready() -> void:
	max_value = Comum.eu.hp.maximo
	value = Comum.eu.hp.atual
	camera = get_viewport().get_camera_3d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var screen_pos = camera.unproject_position(Comum.player.global_position + vetorcamera + Vector3(0, 0, 300)) 
	print_debug(screen_pos) #(576.0, 9659837440.0)

	global_position = screen_pos
	global_position += Vector2(-get_rect().size.x / 2, 0)

func addNivel():
	no_nivel.text="%d" %[Comum.eu.nivel.atual]
