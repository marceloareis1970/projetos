extends Node3D

@onready var animation_player: AnimationPlayer = $player/AnimationPlayer


func play(oque:String,default=true) -> void:
	if default:
		animation_player.play(oque)
	else:
		#fix parece que no godot está invertido o ultimo parametro
		#isto é o mesmo que play_blackwards
		animation_player.play(oque,-1,-1.0, false)
