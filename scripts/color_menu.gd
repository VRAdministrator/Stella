extends Control

@onready var Color_display: ColorRect = $ColorRect
@onready var pointer: TextureRect = $Button/TextureRect
@onready var transparent_button: Button = $transparent

const PICKER_CENTER: Vector2 = Vector2(200.0, 200.0)
const PICKER_RADIUS: float = 200.0
const POINTER_OFFSET: Vector2 = Vector2(5.0, 5.0)

var pressed: bool
var current_color: Color = Color.WHITE


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed = true
		else:
			pressed = false
	elif event is InputEventMouseMotion:
		if !pressed:
			return
		var pt: Vector2 = event.position
		pointer.position = pt - POINTER_OFFSET
		pt -= PICKER_CENTER
		var saturation: float = pt.length() / PICKER_RADIUS
		if saturation > 1:
			return
		var hue: float = (pt.angle() + PI) / (2 * PI)
		current_color = Color.from_hsv(hue, saturation, 1)
		Color_display.color = current_color


func _on_apply_pressed() -> void:
	for protein in ProteinRegistry.selected_proteins:
		for i in range(protein.atoms.instance_count):
			if !protein.selected_atoms[i]:
				continue
			protein.atoms.set_instance_color(i, current_color)
