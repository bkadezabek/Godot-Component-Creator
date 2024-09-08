@tool
extends Control

signal selected_component_signal(component_name, path, description)

@onready var grid_container = $GridContainer
@onready var btn_import = $VBoxContainer2/BtnImport

#const SAVED_COMPONENT_LIBRARY_PATH: StringName = GODOT_COMPONENT_CREATOR + &"saved_component_library_path"

var component_view: PackedScene = preload("res://addons/godot-component-generator/ComponentView/component_view.tscn")
var file_dialog: PackedScene = preload("res://addons/godot-component-generator/FileDialog/file_dialog.tscn")
var file_dialog_target: PackedScene = preload("res://addons/godot-component-generator/FileDialogTarget/file_dialog_target.tscn")
var export_path: String = ""  
var current_selected_component_path: String = ""
var num_of_subdirectories: int = 0
var subdirectory_structure: Dictionary = {}
var selected_component_name: String = ""

func _ready() -> void:
	selected_component_signal.connect(_on_component_selected)
	prepare_custom_plugin_settings()

func prepare_custom_plugin_settings() -> void:
	var settings = EditorInterface.get_editor_settings()
	if settings.get_setting("plugin/component_creator/component_library_path") == null or \
		settings.get_setting("plugin/component_creator/component_library_path") == "":
		var component_library_path_properties = {
			"name": "plugin/component_creator/component_library_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": "example/test"
		}
		var show_description_of_components_properties = {
			"name": "plugin/component_creator/show_description_of_components",
			"type": TYPE_BOOL,
			"hint_string": "example/test"
		}
		settings.add_property_info(component_library_path_properties)
		settings.add_property_info(show_description_of_components_properties)
		
		settings.set_setting("plugin/component_creator/component_library_path", "example/test")
		settings.set_setting("plugin/component_creator/show_description_of_components", true)
		
		print("NEWLY CREATED")
	else:
		print("I ALREADY EXIST")
		return

func _on_btn_load_pressed() -> void:
	var file_dialog_instance = file_dialog.instantiate()
	add_child(file_dialog_instance)
	file_dialog_instance.dir_selected.connect(_on_dir_selected)
	
func _on_dir_selected(dir_path: String) -> void:
	export_path = dir_path
	subdirectory_structure = get_folders_in_directory(export_path)
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
	return folders_dict 

func generate_component_views(target_structure: Dictionary) -> void:
	for folder in target_structure:
		var component_view_instance = component_view.instantiate() as PanelContainer
		grid_container.add_child(component_view_instance)
		component_view_instance.prepare_values(str(folder), str(target_structure[folder]))

func _on_component_selected(component_name: String, component_path: String, component_desc: String) -> void:
	current_selected_component_path = component_path
	selected_component_name = component_name
	btn_import.disabled = false

func _on_btn_import_pressed() -> void:
	var file_dialog_target_instance = file_dialog_target.instantiate()
	add_child(file_dialog_target_instance)
	file_dialog_target_instance.dir_selected.connect(_on_dir_target_selected)

func _on_dir_target_selected(destination_path: String) -> void:
	var new_destination_path: String = destination_path + "/" + selected_component_name
	create_target_directory(destination_path)
	copy_folder(current_selected_component_path, new_destination_path)

func create_target_directory(dest_path: String) -> void:
	var dir: DirAccess = DirAccess.open(dest_path)
	dir.make_dir(selected_component_name)
	
func copy_folder(source_path: String, dest_path: String) -> void:
	var dir: DirAccess = DirAccess.open(source_path)
	if dir == null:
		printerr("Error: Cannot open source directory: ", source_path)
		return
	dir.make_dir(dest_path)
	var dest_dir: DirAccess = DirAccess.open(dest_path)
	if dest_dir == null:
		printerr("Destination directory does not exist. Creating: ", dest_path)
		var result = dest_dir.make_dir_recursive(dest_path)
		if result != OK:
			printerr("Error: Failed to create destination directory: ", dest_path)
			return
	dir.list_dir_begin()  # Begin listing the directory
	
	var file_name = dir.get_next()  # Get the first file
	while file_name != "":  # Continue until the end
		if file_name != "." and file_name != "..":  # Skip "." and ".."
			var src_file_path = source_path + file_name
			var dest_file_path = dest_path + "/" + file_name
			
			if dir.current_is_dir():  # If it's a directory, copy recursively
				copy_folder(src_file_path, dest_file_path)  # Recursive call
			else:  # If it's a file, copy the file
				var file = FileAccess.open(src_file_path, FileAccess.READ)
				if file:
					var file_data = file.get_buffer(file.get_length())
					file.close()
					var dest_file = FileAccess.open(dest_file_path, FileAccess.WRITE)
					if dest_file:
						dest_file.store_buffer(file_data)
						dest_file.close()
					else:
						printerr("Error: Cannot open destination file for writing: ", dest_file_path)
				else:
					printerr("Error: Cannot open source file for reading: ", src_file_path)
		file_name = dir.get_next()  # Get the next file
	
	dir.list_dir_end()  # End listing the directory
	
	reload_dock_filesystem()

func reload_dock_filesystem() -> void:
	EditorInterface.get_resource_filesystem().scan()
