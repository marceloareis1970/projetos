extends Node


var db : SQLite = null
var db_name  = "res://arquivo.db"
const verbosity_level : int = SQLite.VERBOSE

func _ready() -> void:
	db = SQLite.new()
	db.path = db_name
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()
	db.query("CREATE TABLE IF NOT EXISTS tabela (campo text,valor text)")
	
func read(campo:String,default:String = ""):
	db.query("select valor from tabela where campo = '"+campo+"'")
	var query_result : Array = db.query_result
	if query_result.is_empty():
		return default
	else:
		return  JSON.parse_string(query_result[0].valor)
		
func atualizar(campo:String,valor:String):
	db.query("select valor from tabela where campo = '"+campo+"'")
	var query_result : Array = db.query_result
	if query_result.is_empty():
		db.query("insert into tabela (campo,valor) values ('"+campo+"','"+valor+"')")
	else:
		db.query("update tabela set valor='"+valor+"' WHERE campo='"+campo+"'")
