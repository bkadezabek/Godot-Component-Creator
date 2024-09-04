@tool
extends EditorPlugin

const MainPanel = preload("res://addons/godot-component-generator/main_panel.tscn")
var component_panel = preload("res://addons/godot-component-generator/ComponentView/component_vew.tscn")

var main_panel_instance

func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	main_panel_instance.hide()
	
	load_components()

func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible) -> void:
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name() -> String:
	return "Component Creator"

func _get_plugin_icon() -> Texture2D:
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("ResourcePreloader", "EditorIcons")

func load_components() -> void:
	main_panel_instance.load_all()
