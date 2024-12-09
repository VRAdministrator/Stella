extends XROrigin3D

signal open_GUI
signal close_GUI

@onready var left_hand:XRController3D=$left_hand
@onready var right_hand:XRController3D=$right_hand
@onready var GUI:MeshInstance3D=$"../GUI"
@onready var protien_model:Node3D=$"../protein"

var left_trigger_held:bool=false
var left_grip_held:bool=false
var right_trigger_held:bool=false
var right_grip_held:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var protein_prescale:float=0.01
var controller_distance:float

func _physics_process(delta: float) -> void:
	handle_protien_scale()
	handle_menu_open()

func handle_protien_scale()->void:
	if (left_trigger_held||left_grip_held)&&(right_trigger_held||right_grip_held):
		if controller_distance==-1:
			controller_distance=left_hand.position.distance_to(right_hand.position)
			return
		var current_distance:float=left_hand.position.distance_to(right_hand.position)
		protein_prescale*=current_distance/controller_distance
		controller_distance=current_distance
		protien_model.scale=Vector3.ONE*protein_prescale
		return
	controller_distance=-1
	
func handle_menu_open()->void:
	if menu_open==preclick_condition:return
	preclick_condition=menu_open
	if menu_open:
		GUI.visible=true
		open_GUI.emit()
	else:
		GUI.visible=false
		close_GUI.emit()


func _on_left_hand_button_pressed(name: String) -> void:
	if process_sym_input(name):return

func _on_right_hand_button_pressed(name: String) -> void:
	if process_sym_input(name):return

func _on_left_float_change(name: String,value: float)-> void:
	match name:
		"trigger":
			if value>=.5:left_trigger_held=true
			else:left_trigger_held=false
		"grip":
			if value>=.5:left_grip_held=true
			else:left_grip_held=false

func _on_right_float_change(name: String,value: float)-> void:
	match name:
		"trigger":
			if value>=.5:right_trigger_held=true
			else:right_trigger_held=false
		"grip":
			if value>=.5:right_grip_held=true
			else:right_grip_held=false
		

var menu_open:bool=true
var preclick_condition:bool=true

func process_sym_input(name:String)->bool:
	match name:
		"menu_button":
			menu_open=!menu_open
		_:return false
	return true
