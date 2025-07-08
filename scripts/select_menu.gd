extends Control
var protein_select_scene:PackedScene=preload("res://scenes/GUI/protein_select_menu.tscn")
var parts_select_scene:PackedScene=preload("res://scenes/GUI/parts_select_menu.tscn")

var current_submenu:Node
var protein_menu_enabled:bool=true

func _ready() -> void:
	current_submenu=protein_select_scene.instantiate()
	add_child(current_submenu)
	


func _on_protein_button_pressed() -> void:
	if protein_menu_enabled:return
	current_submenu.free()
	current_submenu=protein_select_scene.instantiate()
	add_child(current_submenu)
	protein_menu_enabled=true
	

func _on_parts_button_pressed() -> void:
	if !protein_menu_enabled:return
	current_submenu.free()
	current_submenu=parts_select_scene.instantiate()
	add_child(current_submenu)
	protein_menu_enabled=false
