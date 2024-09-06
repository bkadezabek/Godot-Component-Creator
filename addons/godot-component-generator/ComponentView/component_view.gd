@tool
extends PanelContainer

@onready var lbl_name = $MarginContainer/VBoxContainer/LblName
@onready var component_view = $"."

var default_stylebox: StyleBoxFlat = preload("res://addons/godot-component-generator/ComponentView/default_view_stylebox.tres")

func _ready() -> void:
	prepare_tooltip()

func _on_mouse_entered() -> void:
	component_view.self_modulate = Color(0.9, 0.9, 0.9)

func _on_mouse_exited() -> void:
	component_view.self_modulate = Color(1, 1, 1)

func prepare_tooltip() -> void:
	tooltip_text = lbl_name.text
