@tool
extends Control

signal selected_component_signal(component_name, path, description)

@onready var grid_container = $GridContainer
@onready var btn_import = $VBoxContainer2/BtnImport

@export var componen_view: PackedScene

var component_view = preload("res://addons/godot-component-generator/ComponentView/component_view.tscn")
var file_dialog = preload("res://addons/godot-component-generator/FileDialog/file_dialog.tscn")
var export_path: String = ""  
var current_selected_component_path: String = ""
var num_of_subdirectories: int = 0
var subdirectory_structure: Dictionary = {}

func _ready() -> void:
	selected_component_signal.connect(_on_component_selected)

func _on_btn_load_pressed() -> void:
	print("LOAD FILE DIALOG")
	var file_dialog_instance = file_dialog.instantiate()
	add_child(file_dialog_instance)
	file_dialog_instance.dir_selected.connect(_on_dir_selected)
	
func _on_dir_selected(dir_path: String) -> void:
	print("DIR PATH: ", dir_path)
	export_path = dir_path
	subdirectory_structure = get_folders_in_directory(export_path)
	print("SUBDIRECTORIES: ", subdirectory_structure)
	generate_component_views(subdirectory_structure)

func get_folders_in_directory(path: String) -> Dictionary:
	var dir = DirAccess.open(path)
	var folder_count = 0
	var folders_dict = {}
	
	if dir:
		dir.list_dir_begin()
		while true:
			var item_name = dir.get_next()
			if item_name == "":
				break
			if dir.current_is_dir() and item_name != "." and item_name != "..":
				folder_count += 1
				var full_path = path + "/" + str(item_name)
				folders_dict[item_name] = full_path
		dir.list_dir_end()
	num_of_subdirectories = folder_count
	print("Number of folders: ", folder_count)
	return folders_dict 

func generate_component_views(target_structure: Dictionary) -> void:
	for folder in target_structure:
		var component_view_instance = component_view.instantiate() as PanelContainer
		grid_container.add_child(component_view_instance)
		component_view_instance.prepare_values(str(folder), str(target_structure[folder]))

func _on_component_selected(component_name: String, component_path: String, component_desc: String) -> void:
	current_selected_component_path = component_path
	btn_import.disabled = false

func _on_btn_import_pressed():
	print("IMPORT PATH: ", current_selected_component_path)
