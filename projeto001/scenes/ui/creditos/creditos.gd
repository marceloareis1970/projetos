extends CanvasLayer

@onready var tree: Tree = $n/c/h/Tree


var creditos ={
	"arte - objetos 3D":[
			{"texto":"Mixamo - os players peguei lá"},
		],
	"imagens":[
		{"texto":"Dos players - Geradas lindamente pelo copilot"},
		{"texto":"Icone - Me superei. Copilot novamente (ele quem disse isso viu kkk)"},
		{"texto":"Espada e cajado - https://snoopethduckduck.itch.io/swords"}
	],
	"fonts utlizadas":[
		{"texto":"dafont - https://www.dafont.com/pt/theme.php?cat=401"},
	],
	"cursores":[
		{"texto":"Baixado de https://wenrexa.itch.io/cursors5"}
	],
	"Ferramentas":[
		{"texto":"programa desktop para abrir um arquivo SQLLite FREE - https://sqlitebrowser.org/"},
		{"texto":"Programa para trabalhar com imagens FREE - https://www.getpaint.net/download.html"}
	],
	"AssetLib":[
		{"texto":"G-kanban para organizar seu projeto"},
		{"texto":"Godot SQLlite - para armazenar seus dados em um repositório"}
	],
	
	
	# deixar o agradecimento por último
	"agradecimentos":[
		{"texto":"Ao meu filho, por ter me incentivado a fazer este processo todo"},
		{"texto":"A minha esposa, sempre amorosa,com todos e com uma visão bem a frente"},
	],
}

func _ready() -> void:
	#
	var root = tree.create_item()  # crio a raiz do root ( este no fim ficará invisível, mas precisaremos dele )
	var keys = creditos.keys() # lista de todas as keys do array
	for i in keys: # iteramos em key para colocar ele como um tipo de header na tela
		var child1 = tree.create_item(root) # o nosso header virá do root (ou seja da raiz)
		child1.set_text(0,i) # aqui adicionamos ele na coluna ZERO, << texto >>
		for j in creditos.get(i): # Agora, com o header definidos, poderemos pegar todos os demais deste.
			var subchild1 = tree.create_item(child1) # Vamos apontar para um sub itenm do item 
			subchild1.set_text(0, j.texto) # novamente setamos na coluna ZERO, com o texto em j.texto

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/tela_inicial/ui_start.tscn") # quando pressionamos o botão, vamos executar esta rotina
