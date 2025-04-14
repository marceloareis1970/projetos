extends ParallaxBackground

@onready var speed: int = 100

func _physics_process(delta: float) -> void:
	if Comum.warp and Comum.eu.vivo:
		scroll_offset.y += speed * delta
