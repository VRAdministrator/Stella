extends XROrigin3D

signal open_GUI
signal close_GUI

@onready var left_hand:XRController3D=$left_hand
@onready var right_hand:XRController3D=$right_hand
@onready var GUI:MeshInstance3D=$"../GUI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if menu_open==preclick_condition:return
	preclick_condition=menu_open
	if menu_open:
		GUI.visible=true
		open_GUI.emit()
	else:
		GUI.visible=false
		close_GUI.emit()


func _on_left_hand_button_released(name: String) -> void:
	if process_sym_input(name):return


func _on_right_hand_button_released(name: String) -> void:
	if process_sym_input(name):return

var menu_open:bool=true
var preclick_condition:bool=true

func process_sym_input(name:String)->bool:
	match name:
		"menu_button":
			menu_open=!menu_open
		_:return false
	return true
