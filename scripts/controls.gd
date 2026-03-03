extends XROrigin3D

@onready var left_controller:XRController3D=$left_hand
@onready var right_controller:XRController3D=$right_hand
@onready var GUI:Node3D=$"../Viewport2Din3D"
@onready var right_pointer:XRToolsFunctionPointer=$right_hand/FunctionPointer
@onready var left_pointer:XRToolsFunctionPointer=$left_hand/FunctionPointer

var xr_interface: XRInterface

func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		
		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")

func _physics_process(_delta: float) -> void:
	left_controller.handle_grab()
	right_controller.handle_grab()
	handle_protein_scale()

func _process(_delta: float) -> void:
	handle_pointer_position()
	handle_menu_state()

var controller_distance:float

const INACTIVE_NUMBER:int=-1

func handle_protein_scale() -> void:
	if left_controller.get_held()&&right_controller.get_held():
		var current_distance:float=left_controller.position.distance_to(right_controller.position)
		if controller_distance==INACTIVE_NUMBER:
			controller_distance=current_distance
			return
		if current_distance==0:
			return
		var distance_scale:float=current_distance/controller_distance
		controller_distance=current_distance
		for protein in ProteinRegistry.selected_proteins:
			if protein==null:
				continue
			protein.virtual_scale*=distance_scale
			var protein_scale:Vector3=Vector3.ONE*protein.virtual_scale
			protein.model_base.scale=protein_scale
			protein.area.scale=protein_scale
		return
	controller_distance=INACTIVE_NUMBER

var pointer_position_right:bool=true

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
	if process_sym_input(action):
		return

func _on_right_hand_button_pressed(action: String) -> void:
	if process_sym_input(action):
		return

var menu_open:bool=true
var previous_menu_state:bool=true

func process_sym_input(action:String)->bool:
	match action:
		"menu_button":
			menu_open=!menu_open
		"secondary_click":
			ProteinRegistry.reset_proteins()
		_:return false
	return true

func handle_menu_state()->void:#fix this
	if menu_open==previous_menu_state:
		return
	previous_menu_state=menu_open
	GUI.visible=menu_open
	if menu_open:
		GUI.visible=true
		GUI.process_mode=Node.PROCESS_MODE_INHERIT
	else:
		GUI.visible=false
		GUI.process_mode=Node.PROCESS_MODE_DISABLED
