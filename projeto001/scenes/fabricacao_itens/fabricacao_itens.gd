extends CharacterBody3D

@onready var label: Label = $UI/Label

var ativo:bool=false

func _ready() -> void:
	label.visible=false
	
func _physics_process(delta: float) -> void:
	if ativo:
		if Input.is_action_just_pressed("R"):
			pass



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ativo=false
