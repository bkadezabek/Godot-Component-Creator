@tool
extends Control

@onready var grid_container = $GridContainer

@export var componen_view: PackedScene

var component_view = preload("res://addons/godot-component-generator/ComponentView/component_view.tscn")
var file_dialog = preload("res://addons/godot-component-generator/FileDialog/file_dialog.tscn")
var export_path: String = ""  

func _ready() -> void:
	pass

func load_all() -> void:
	grid_container.add_child(component_view.instantiate())
	grid_container.add_child(component_view.instantiate())
	grid_container.add_child(component_view.instantiate())
	grid_container.add_child(component_view.instantiate())
	
	grid_container.add_child(component_view.instantiate())
	grid_container.add_child(component_view.instantiate())
	grid_container.add_child(component_view.instantiate())
	grid_container.add_child(component_view.instantiate())
	
	grid_container.add_child(component_view.instantiate())

func _on_btn_load_pressed() -> void:
	print("LOAD FILE DIALOG")
	var file_dialog_instance = file_dialog.instantiate()
	add_child(file_dialog_instance)
	file_dialog_instance.dir_selected.connect(_on_dir_selected)
	
func _on_dir_selected(dir_path: String) -> void:
	print("DIR PATH: ", dir_path)
	export_path = dir_path
	var num = count_folders_in_directory(export_path)
	print("NUM OF SUBDIRECTORIES: ", num)

## Standard
#var dir = DirAccess.open("user://levels")
#dir.make_dir("world1")
## Static
#DirAccess.make_dir_absolute("user://levels/world1")
#
#Note: Many resources types are imported (e.g. textures or sound files), and their source asset will not be included in the exported game, as only the imported version is used. Use ResourceLoader to access imported resources.
#
#Here is an example on how to iterate through the files of a directory:
#
#func dir_contents(path):
	#var dir = DirAccess.open(path)
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#if dir.current_is_dir():
				#print("Found directory: " + file_name)
			#else:
				#print("Found file: " + file_name)
			#file_name = dir.get_next()
	#else:
		#print("An error occurred when trying to access the path.")



func count_folders_in_directory(path: String) -> int:
	var dir = DirAccess.open(path)
	var folder_count = 0
	
	if dir:
		dir.list_dir_begin()  # Start listing the contents of the directory
		
		while true:
			var item_name = dir.get_next()
			if item_name == "":
				break
			if dir.current_is_dir() and item_name != "." and item_name != "..":
				folder_count += 1
		dir.list_dir_end()
	
	return folder_count
