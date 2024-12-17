extends XROrigin3D

signal open_GUI
signal close_GUI
@onready var root:Node3D=$".."
@onready var left_hand:XRController3D=$left_hand
@onready var right_hand:XRController3D=$right_hand
@onready var GUI:MeshInstance3D=$"../GUI"
@onready var protien_model:Node3D=$"../protein"

var left_trigger_held:bool=false
var left_grip_held:bool=false
var right_trigger_held:bool=false
var right_grip_held:bool=false

var left_hand_grab:bool=false
var right_hand_grab:bool=false
var left_hand_object:Node3D
var right_hand_object:Node3D

var left_area_objects:Array[Node3D]
var right_area_objects:Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var protein_prescale:float=0.01
var controller_distance:float

func _physics_process(_delta: float) -> void:
	handle_protien_scale()
	handle_menu_open()
	handle_grab()

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

func handle_grab():
	if left_hand_grab:
		if !(left_grip_held||left_trigger_held):
			let_go_object(left_hand_object,left_hand)
			left_hand_grab=false
	else:
		if left_grip_held||left_trigger_held:
			var object:Node3D=grab_object(left_hand,left_area_objects)
			if object!=null:
				left_hand_grab=true
				left_hand_object=object
	if right_hand_grab:
		if !(right_grip_held||right_trigger_held):
			let_go_object(right_hand_object,right_hand)
			right_hand_grab=false
	else:
		if right_grip_held||right_trigger_held:
			var object:Node3D=grab_object(right_hand,right_area_objects)
			if object!=null:
				right_hand_grab=true
				right_hand_object=object
		
func grab_object(hand:XRController3D,objects:Array[Node3D])->Node3D:
	if objects.size()==0:return null
	var object:Node3D
	var hand_pos:Vector3=hand.global_position
	var closest:float=1000
	for test_ob in objects:
		var test_dis:float=hand_pos.distance_to(test_ob.global_position)
		if test_dis>closest:continue
		closest=test_dis
		object=test_ob
	object=object.get_parent_node_3d()
	var pos:Vector3=object.global_position
	var rot:Vector3=object.global_rotation
	root.remove_child(object)
	hand.add_child(object)
	object.global_position=pos
	object.global_rotation=rot
	return object

func let_go_object(object:Node3D,hand:XRController3D):
	var pos:Vector3=object.global_position
	var rot:Vector3=object.global_rotation
	hand.remove_child(object)
	root.add_child(object)
	object.global_position=pos
	object.global_rotation=rot

func _on_left_hand_button_pressed(action: String) -> void:
	if process_sym_input(action):return

func _on_right_hand_button_pressed(action: String) -> void:
	if process_sym_input(action):return

func _on_left_float_change(action: String,value: float)-> void:
	match action:
		"trigger":
			if value>=.5:left_trigger_held=true
			else:left_trigger_held=false
		"grip":
			if value>=.5:left_grip_held=true
			else:left_grip_held=false

func _on_right_float_change(action: String,value: float)-> void:
	match action:
		"trigger":
			if value>=.5:right_trigger_held=true
			else:right_trigger_held=false
		"grip":
			if value>=.5:right_grip_held=true
			else:right_grip_held=false

func _left_area_entered(area:Area3D):
	left_area_objects.append(area)

func _right_area_entered(area:Area3D):
	right_area_objects.append(area)

func _left_area_exited(area:Area3D):
	left_area_objects.erase(area)

func _right_area_exited(area:Area3D):
	right_area_objects.erase(area)

var menu_open:bool=true
var preclick_condition:bool=true

func process_sym_input(action:String)->bool:
	match action:
		"menu_button":
			menu_open=!menu_open
		_:return false
	return true
