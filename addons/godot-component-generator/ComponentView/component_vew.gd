@tool
extends PanelContainer

@onready var lbl_name = $MarginContainer/VBoxContainer/LblName

func _ready() -> void:
	prepare_tooltip()

func _process(delta) -> void:
	pass

func _on_mouse_entered() -> void:
	print("SEE")


func _on_mouse_exited():
	print("NO SEE")


func prepare_tooltip() -> void:
	tooltip_text = lbl_name.text
