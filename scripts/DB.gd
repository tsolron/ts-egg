extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns");
var db;
var db_path := "res://data/test";
var json_path := "res://data/test.json";


func _ready():
	startup();
	convert_to_json();


func startup():
	db = SQLite.new();
	db.path = db_path;
	db.open_db();


func shutdown():
	db.close_db();


func convert_to_json():
	db.export_to_json(json_path);

func convert_to_db():
	db.import_from_json(json_path);
