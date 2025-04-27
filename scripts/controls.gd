extends XROrigin3D

@onready var proteins_root:Node3D=$"../proteins"
@onready var left_hand:XRController3D=$left_hand
@onready var right_hand:XRController3D=$right_hand
@onready var GUI:Node3D=$"../Viewport2Din3D"
@onready var right_pointer:XRToolsFunctionPointer=$right_hand/FunctionPointer
@onready var left_pointer:XRToolsFunctionPointer=$left_hand/FunctionPointer

var left_trigger_held:bool=false
var left_grip_held:bool=false
var right_trigger_held:bool=false
var right_grip_held:bool=false

var left_hand_grab:bool=false
var right_hand_grab:bool=false
var left_hand_object:Node3D
var right_hand_object:Node3D

var pointer_position_right:bool=true

var left_area_objects:Array[Node3D]
var right_area_objects:Array[Node3D]

var protein_prescale:float=0.01
var controller_distance:float

var selected_protein:protein_info
var num_proteins:int=0

func _physics_process(_delta: float) -> void:
	handle_pointer_position()
	handle_menu_open()
	match ProteinInfos.proteins.size():
		0:return
		var new_size when num_proteins<new_size:
			var protein:protein_info=ProteinInfos.proteins[new_size-1]
			if protein.bonds==null||protein.bonds.instance_count==0:return
			selected_protein=protein
			num_proteins=new_size
	handle_grab()
	handle_protien_scale()
	

func handle_protien_scale()->void:
	if (left_trigger_held||left_grip_held)&&(right_trigger_held||right_grip_held):
		if controller_distance==-1:
			controller_distance=left_hand.position.distance_to(right_hand.position)
			return
		var current_distance:float=left_hand.position.distance_to(right_hand.position)
		protein_prescale*=current_distance/controller_distance
		controller_distance=current_distance
		var protein_scale:Vector3=Vector3.ONE*protein_prescale#emplament global scale option
		selected_protein.model_base.scale=protein_scale
		selected_protein.area.scale=protein_scale
		return
	controller_distance=-1
	
func handle_menu_open()->void:#fix this
	if menu_open==preclick_condition:return
	preclick_condition=menu_open
	if menu_open:
		GUI.visible=true
		GUI.process_mode=Node.PROCESS_MODE_INHERIT
	else:
		GUI.visible=false
		GUI.process_mode=Node.PROCESS_MODE_DISABLED

func handle_grab():#could be a lot better
	if left_hand_grab:
		if !(left_grip_held||left_trigger_held):
			release_object(left_hand_object,left_hand)
			left_hand_grab=false
	else:
		if left_grip_held||left_trigger_held:
			var object:Node3D=grab_object(left_hand,left_area_objects)
			if object!=null:
				left_hand_grab=true
				left_hand_object=object
	if right_hand_grab:
		if !(right_grip_held||right_trigger_held):
			release_object(right_hand_object,right_hand)
			right_hand_grab=false
	else:
		if right_grip_held||right_trigger_held:
			var object:Node3D=grab_object(right_hand,right_area_objects)
			if object!=null:
				right_hand_grab=true
				right_hand_object=object

func handle_pointer_position():
	if (left_trigger_held!=right_trigger_held)&&(pointer_position_right!=right_trigger_held):
		if left_trigger_held:
			right_pointer.process_mode=Node.PROCESS_MODE_DISABLED
			right_pointer.visible=false
			left_pointer.process_mode=Node.PROCESS_MODE_INHERIT
			left_pointer.visible=true
			pointer_position_right=false
			return
		else:
			left_pointer.process_mode=Node.PROCESS_MODE_DISABLED
			left_pointer.visible=false
			right_pointer.process_mode=Node.PROCESS_MODE_INHERIT
			right_pointer.visible=true
			pointer_position_right=true
			return

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
	var pos:Vector3=object.position
	var rot:Vector3=object.rotation
	proteins_root.remove_child(object)
	hand.add_child(object)
	object.global_position=pos
	object.global_rotation=rot
	return object

func release_object(object:Node3D,hand:XRController3D):
	var pos:Vector3=object.global_position
	var rot:Vector3=object.global_rotation
	hand.remove_child(object)
	proteins_root.add_child(object)
	object.position=pos
	object.rotation=rot

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
