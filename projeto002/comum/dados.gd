extends Node

var sistema_solar={
	"sistema-solar-001":{"nome":"Homeland","posicao":{"x":0,"y":0},
		"planetas":[
			{"id":"sistema-solar-001-001","nome":"Planet A","populacao":10000,"demanda":0.4,"posicao":{"x":50,"y":200},"produtos":[]},
			{"id":"sistema-solar-001-002","nome":"Planet B","populacao":2000,"demanda":0.7,"posicao":{"x":50,"y":5000},"produtos":[]},
			{"id":"sistema-solar-001-003","nome":"Planet C","populacao":50000,"demanda":0.3,"posicao":{"x":50,"y":9000},"produtos":[]},
			{"id":"sistema-solar-001-004","nome":"Planet D","populacao":8000,"demanda":0.2,"posicao":{"x":50,"y":20000},"produtos":[]},
		]
	},
	"sistema-solar-002":{"nome":"Caixa-Prego","posicao":{"x":2000,"y":-5380},
		"planetas":[
			{"id":"sistema-solar-002-001","nome":"Planet E1","populacao":10000,"demanda":0.4,"posicao":{"x":50,"y":200},"produtos":[]},
			{"id":"sistema-solar-002-002","nome":"Planet E2","populacao":2000,"demanda":0.7,"posicao":{"x":50,"y":5000},"produtos":[]},
			{"id":"sistema-solar-002-003","nome":"Planet E3","populacao":50000,"demanda":0.3,"posicao":{"x":50,"y":9000},"produtos":[]},
			{"id":"sistema-solar-002-004","nome":"Planet E4","populacao":8000,"demanda":0.2,"posicao":{"x":50,"y":20000},"produtos":[]},
		]
	},
	"sistema-solar-003":{"nome":"Aurora","posicao":{"x":-25000,"y":-750},
		"planetas":[
			{"id":"sistema-solar-003-001","nome":"Planet G1","populacao":1000,"demanda":0.9,"posicao":{"x":50,"y":200},"produtos":[]},
			{"id":"sistema-solar-003-002","nome":"Planet G2","populacao":33382,"demanda":0.3,"posicao":{"x":50,"y":5000},"produtos":[]},
			{"id":"sistema-solar-003-003","nome":"Planet G3","populacao":48320,"demanda":0.6,"posicao":{"x":50,"y":9000},"produtos":[]},
			{"id":"sistema-solar-003-004","nome":"Planet G4","populacao":65843,"demanda":1.2,"posicao":{"x":50,"y":20000},"produtos":[]},
		]
	},
}
var estacoes_espaciais=[
	{"id":"estacao-001","ss_id":"sistema-solar-001","posicao":{"x":50,"y":200},"nome":"estacao-001-45-b",},
	{"id":"estacao-002","ss_id":"sistema-solar-002","posicao":{"x":-250,"y":900},"nome":"estacao-001-45-b",},
]
var produtos=[
		{"id":"1", "descricao":"Alimentos (Produtos orgânicos simples)","preco_venda": 4.4,"preco_compra":2.0,"qtd":20,"perigo":0},
		{"id":"2", "descricao":"Têxteis (Tecidos não processados)","preco_venda": 6.4,"preco_compra":3.0,"qtd":20,"perigo":0}, 
		{"id":"3", "descricao":"Radioativos (minérios e subprodutos)","preco_venda": 21.2,"preco_compra":18.0,"qtd":20,"perigo":0},
		{"id":"4", "descricao":"Escravos (geralmente humanoides)","preco_venda": 8.0,"preco_compra":5.0,"qtd":20,"perigo":1},
		{"id":"5", "descricao":"Licor/Vinhos (destilados exóticos de flores sobrenaturais)","preco_venda": 25.2,"preco_compra":20.0,"qtd":20,"perigo":0},
		{"id":"6", "descricao":"Luxos (Perfumes, Especiarias, Café)","preco_venda": 91.2,"preco_compra":75.0,"qtd":20,"perigo":0},
		{"id":"7", "descricao":"Narcóticos (Tabaco, Drogas ilícitas)","preco_venda": 114.8,"preco_compra":97.0,"qtd":20,"perigo":1},
		{"id":"8", "descricao":"Computadores (máquinas inteligentes)","preco_venda": 84.0,"preco_compra":54.0,"qtd":20,"perigo":0},
		{"id":"9", "descricao":"Máquinas (equipamentos de fábrica e agrícolas)","preco_venda": 56.4,"preco_compra":38.0,"qtd":20,"perigo":0},
		{"id":"10","descricao":"Ligas (metais industriais)","preco_venda": 32.8,"preco_compra":15.0,"qtd":20,"perigo":0},
		{"id":"11","descricao":"Armamento (artilharia de pequena escala, armas secundárias etc.)","preco_venda": 70.4 ,"preco_compra":50.0,"qtd":20,"perigo":1},
		{"id":"12","descricao":"Peles (inclui couros, peles de animais da fauna)","preco_venda": 56.0 ,"preco_compra":51.0,"qtd":20,"perigo":0},
		{"id":"13","descricao":"Minerais (rocha não refinada contendo oligoelementos)","preco_venda": 8.0,"preco_compra":5.0,"qtd":20,"perigo":0},
]
var armamento=[
	{"id":0,"text":"Fuel", "tecnical_level":0, "price":30},
	{"id":1,"text":"Missile", "tecnical_level":0,  "price":30},
	{"id":2,"text":"Large Cargo Bay", "tecnical_level":0,  "price":400},
	{"id":3,"text":"ECM System", "tecnical_level":2,  "price":600},
	{"id":4,"text":"Pulse Laser", "tecnical_level":3,  "price":400},
	{"id":5,"text":"Beam Laser", "tecnical_level":4,  "price":1000},
	{"id":6,"text":"Fuel Scoops", "tecnical_level":5,  "price":525},
	{"id":7,"text":"Escape Capsule", "tecnical_level":6,  "price":1000},
	{"id":8,"text":"Energy Bomb", "tecnical_level":7,  "price":900},
	{"id":9,"text":"Extra Energy Unit", "tecnical_level":8,  "price":1500},
	{"id":10,"text":"Galactic Hyperdrive", "tecnical_level":10,  "price":5000},
	{"id":11,"text":"Mining Lasers", "tecnical_level":10,  "price":800},
	{"id":12,"text":"Military Lasers", "tecnical_level":10, "price": 6000},
]
