extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $NinePatchRect/VBoxContainer/c2/ScrollContainer/RichTextLabel

var texto=""

func _ready() -> void:
	rich_text_label.clear()
	rich_text_label.append_text("[color=red]Manifesto[/color]\n")
	rich_text_label.append_text("[color=blue]Minha nave[/color]\n")
	texto = "combustível:%s de %s\n" % [ Comum.eu.combustivel.atual, Comum.eu.combustivel.maximo]
	texto += "Hiper combustível:%s de %s\n" % [ Comum.eu.hiperdrive_combustivel.atual, Comum.eu.hiperdrive_combustivel.maximo]
	texto += "Armas\n"
	texto +="   PST-001 - Damage: 20 kpdu - Resfriamento automático\n"
	texto +="   ???-??? - Sem escudo\n"
	texto +="   MOT-001-A - Tempo de resposta 0.1 mms\n"
	rich_text_label.append_text(texto)
	rich_text_label.append_text("[color=blue]Meu inventário[/color]\n")
	texto = "Modelo: BAG-001 - 05\n"
	texto += "Espaço total: 5\n"
	texto += "Itens no inventário\n"
	texto += "-\n"
	rich_text_label.append_text(texto)
	rich_text_label.append_text("[color=blue]Destino Hiperdriver[/color]\n")
