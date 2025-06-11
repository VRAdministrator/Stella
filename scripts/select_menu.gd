extends Control
var protein_select_scene:PackedScene=preload("res://scenes/GUI/protein_select_menu.tscn")

var current_submenu:Node

func _ready() -> void:
	current_submenu=protein_select_scene.instantiate()
	add_child(current_submenu)



func _on_protein_button_pressed() -> void:
	pass # Replace with function body.

func _on_parts_button_pressed() -> void:
	pass # Replace with function body.
