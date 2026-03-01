extends XROrigin3D

@onready var left_controller:XRController3D=$left_hand
@onready var right_controller:XRController3D=$right_hand
@onready var GUI:Node3D=$"../Viewport2Din3D"
@onready var right_pointer:XRToolsFunctionPointer=$right_hand/FunctionPointer
@onready var left_pointer:XRToolsFunctionPointer=$left_hand/FunctionPointer


var pointer_position_right:bool=true

var controller_distance:float

var num_proteins:int=0

func _physics_process(_delta: float) -> void:
	handle_pointer_position()
	handle_menu_state()
	handle_new_prteins()
	left_controller.handle_grab()
	right_controller.handle_grab()
	handle_protien_scale()

func handle_new_prteins() -> void:
	match ProteinInfos.proteins.size():
		0:return
		var new_size when num_proteins<new_size:
			var protein:protein_info=ProteinInfos.proteins[new_size-1]
			if protein.bonds==null||protein.bonds.instance_count==0:
				return
			ProteinInfos.selected_proteins=[protein]
			num_proteins=new_size

func handle_protien_scale() -> void:
	if left_controller.get_held()&&right_controller.get_held():
		var current_distance:float=left_controller.position.distance_to(right_controller.position)
		if controller_distance==-1:
			controller_distance=current_distance
			return
		var distance_scale:float=current_distance/controller_distance
		controller_distance=current_distance
		for protein in ProteinInfos.selected_proteins:
			protein.scale*=distance_scale
			var protein_scale:Vector3=Vector3.ONE*protein.scale
			protein.model_base.scale=protein_scale
			protein.area.scale=protein_scale
		return
	controller_distance=-1

func handle_pointer_position() -> void:
	if (left_controller.trigger_held==right_controller.trigger_held)||(pointer_position_right==right_controller.trigger_held):
		return
	if left_controller.trigger_held:
		right_pointer.process_mode=Node.PROCESS_MODE_DISABLED
		right_pointer.visible=false
		left_pointer.process_mode=Node.PROCESS_MODE_INHERIT
		left_pointer.visible=true
		pointer_position_right=false
		return
	left_pointer.process_mode=Node.PROCESS_MODE_DISABLED
	left_pointer.visible=false
	right_pointer.process_mode=Node.PROCESS_MODE_INHERIT
	right_pointer.visible=true
	pointer_position_right=true


func _on_left_hand_button_pressed(action: String) -> void:
	if process_sym_input(action):return

func _on_right_hand_button_pressed(action: String) -> void:
	if process_sym_input(action):return

var menu_open:bool=true
var preclick_condition:bool=true

func process_sym_input(action:String)->bool:
	match action:
		"menu_button":
			menu_open=!menu_open
		"secondary_click":
			ProteinInfos.reset_proteins()
		_:return false
	return true

func handle_menu_state()->void:#fix this
	if menu_open==preclick_condition:return
	preclick_condition=menu_open
	if menu_open:
		GUI.visible=true
		GUI.process_mode=Node.PROCESS_MODE_INHERIT
	else:
		GUI.visible=false
		GUI.process_mode=Node.PROCESS_MODE_DISABLED
