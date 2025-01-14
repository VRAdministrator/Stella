extends CanvasLayer

var import_scene:PackedScene=preload("res://import_menu.tscn")
var style_scene:PackedScene=preload("res://style_menu.tscn")

var current_scene:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene=import_scene.instantiate()
	add_child(current_scene)

func _on_import_button_pressed() -> void:
	current_scene.free()
	current_scene=import_scene.instantiate()
	add_child(current_scene)

func _on_style_button_pressed() -> void:
	current_scene.free()
	current_scene=style_scene.instantiate()
	add_child(current_scene)

func _on_color_button_pressed() -> void:
	pass # Replace with function body.

func _on_reset_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.
