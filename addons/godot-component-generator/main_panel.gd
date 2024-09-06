@tool
extends Control

signal selected_component_signal(component_name, path, description)

@onready var grid_container = $GridContainer
@onready var btn_import = $VBoxContainer2/BtnImport

var component_view: PackedScene = preload("res://addons/godot-component-generator/ComponentView/component_view.tscn")
var file_dialog: PackedScene = preload("res://addons/godot-component-generator/FileDialog/file_dialog.tscn")
var file_dialog_target: PackedScene = preload("res://addons/godot-component-generator/FileDialogTarget/file_dialog_target.tscn")
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
	var dir: DirAccess = DirAccess.open(path)
	var folder_count: int = 0
	var folders_dict: Dictionary = {}
	
	if dir:
		dir.list_dir_begin()
		while true:
			var item_name = dir.get_next()
			if item_name == "":
				break
			if dir.current_is_dir() and item_name != "." and item_name != "..":
				folder_count += 1
				var full_path = path + "/" + str(item_name) + "/"
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

func _on_btn_import_pressed() -> void:
	print("IMPORT PATH: ", current_selected_component_path)
	var file_dialog_target_instance = file_dialog_target.instantiate()
	add_child(file_dialog_target_instance)
	file_dialog_target_instance.dir_selected.connect(_on_dir_target_selected)

func _on_dir_target_selected(destination_path: String) -> void:
	print("PATH TO IMPORT: ", destination_path)
	copy_folder(current_selected_component_path, destination_path)

func copy_folder(source_path: String, dest_path: String) -> void:
	print("SOURCE:", source_path, " DEST: ", dest_path)
	var dir: DirAccess = DirAccess.open(source_path)
	if dir == null:
		print("Error: Cannot open source directory: ", source_path)
		return
	var dest_dir: DirAccess = DirAccess.open(dest_path)
	if dest_dir == null:
		print("Destination directory does not exist. Creating: ", dest_path)
		var result = dest_dir.make_dir_recursive(dest_path)
		if result != OK:
			print("Error: Failed to create destination directory: ", dest_path)
			return
	
	dir.list_dir_begin()  # Begin listing the directory
	
	var file_name = dir.get_next()  # Get the first file
	while file_name != "":  # Continue until the end
		if file_name != "." and file_name != "..":  # Skip "." and ".."
			var src_file_path = source_path + file_name
			var dest_file_path = dest_path + "/" + file_name
			
			if dir.current_is_dir():  # If it's a directory, copy recursively
				print("Copying folder: ", src_file_path, " to ", dest_file_path)
				copy_folder(src_file_path, dest_file_path)  # Recursive call
			else:  # If it's a file, copy the file
				print("Copying file: ", src_file_path, " to ", dest_file_path)
				var file = FileAccess.open(src_file_path, FileAccess.READ)
				if file:
					var file_data = file.get_buffer(file.get_length())
					file.close()
					
					var dest_file = FileAccess.open(dest_file_path, FileAccess.WRITE)
					if dest_file:
						dest_file.store_buffer(file_data)
						dest_file.close()
					else:
						print("Error: Cannot open destination file for writing: ", dest_file_path)
				else:
					print("Error: Cannot open source file for reading: ", src_file_path)
		
		file_name = dir.get_next()  # Get the next file
	
	dir.list_dir_end()  # End listing the directory
