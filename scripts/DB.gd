extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns");
var db_templates;
var db_templates_path := "res://data/egg-data";


func _ready():
	startup();
	#convert_to_json(db_templates, db_templates_path);


func startup():
	db_templates = SQLite.new();
	db_templates.path = db_templates_path;
	#db_templates.verbose_mode = true
	db_templates.open_db();


func _exit_tree():
	db_templates.close_db();


func convert_to_json(db, path):
	db.export_to_json(path + ".json");

func convert_to_db(db, path):
	db.import_from_json(path + ".json");


func get_equation_templates():
	db_templates.query("SELECT * FROM [EQUATION_TEMPLATE_WITH_PARAMS];");
	return db_templates.query_result;

func get_graph_data(graph_id):
	db_templates.query("SELECT * FROM [GRAPH_DATA] WHERE [GRAPH_ID]='" + str(graph_id) + "';");
	return db_templates.query_result;
