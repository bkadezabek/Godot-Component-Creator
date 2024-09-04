@tool
extends Control

@onready var grid_container = $GridContainer

@export var componen_view: PackedScene

var test = preload("res://addons/godot-component-generator/ComponentView/component_vew.tscn")

func _ready() -> void:
	pass

func load_all() -> void:
	print("LOAD")
	grid_container.add_child(test.instantiate())
	grid_container.add_child(test.instantiate())
	grid_container.add_child(test.instantiate())
	grid_container.add_child(test.instantiate())
	
	grid_container.add_child(test.instantiate())
	grid_container.add_child(test.instantiate())
	grid_container.add_child(test.instantiate())
	grid_container.add_child(test.instantiate())
	
	grid_container.add_child(test.instantiate())
