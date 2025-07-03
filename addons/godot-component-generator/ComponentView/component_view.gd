@tool
extends PanelContainer

@onready var lbl_name = $MarginContainer/VBoxContainer/LblName
@onready var lbl_path = $MarginContainer/VBoxContainer/LblPath
@onready var lbl_description = $MarginContainer/VBoxContainer/LblDescription
@onready var component_view = $"."

var default_stylebox: StyleBoxFlat = preload("res://addons/godot-component-generator/ComponentView/default_view_stylebox.tres")
var parent
var component_name: String
var component_path: String
var component_description: String

func _ready() -> void:
	prepare_view_structure()
	parent = get_parent().get_parent()

func prepare_view_structure() -> void:
	var settings = EditorInterface.get_editor_settings()
	var show_description_state: bool = settings.get_setting("plugin/component_creator/show_description_of_components")
	if show_description_state:
		lbl_description.visible = true
	else:
		lbl_description.visible = false 

func _on_mouse_entered() -> void:
	component_view.self_modulate = Color(0.9, 0.9, 0.9)

func _on_mouse_exited() -> void:
	component_view.self_modulate = Color(1, 1, 1)

func prepare_tooltip(hover_name: String, hover_path: String) -> void:
	tooltip_text = hover_name + "\n" + hover_path

func prepare_values(local_component_name: String, path: String = "C://", description: String = "* * *") -> void:
	component_name = local_component_name
	component_path = path
	component_description = description
	lbl_name.text = component_name
	lbl_path.text = component_path
	lbl_description.text = component_description
	prepare_tooltip(local_component_name,  path)

func _on_gui_input(event: InputEvent) -> void:
	# before only if the action was pressed was checked for. 
	# this more 'rigorous' check instead fixes the fact that
	# when you scroll with the mouse-wheel, you select a component 
	if event is InputEventMouseButton && \
	event.button_index == MOUSE_BUTTON_LEFT && \
	event.is_pressed():
		component_view.self_modulate = Color(0.7, 0.7, 0.7)
		parent.selected_component_signal.emit(component_name, component_path, component_description)
