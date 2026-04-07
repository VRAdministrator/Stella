extends CanvasLayer

@onready var import_menu: Control = $Import_Menu
@onready var select_menu: Control = $Select_Menu
@onready var style_menu: Control = $Style_Menu
@onready var color_menu: Control = $Color_Menu

@onready var current_node: Node = import_menu


func _on_button_pressed(node_path: NodePath) -> void:
	var new_node: Node = get_node(node_path)
	if new_node == self:
		ProteinRegistry.reset_proteins()
		return
	if new_node == current_node:
		return
	MenuEntries.disable_menu(current_node)
	MenuEntries.enable_menu(new_node)
	current_node = new_node
