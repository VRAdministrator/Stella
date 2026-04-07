extends XRController3D

var trigger_held: bool = false
var grip_held: bool = false
var grabbed: bool = false
var object_in_hand: Node3D = null
var area_objects: Array[Area3D]


func get_held() -> bool:
	return trigger_held || grip_held


func handle_grab() -> void:
	var held: bool = get_held()
	if grabbed != held:
		if held:
			grab_object()
			return
		release_object()


func grab_object() -> void:
	if area_objects.size() == 0:
		return
	var object: Node3D
	var closest: float = INF
	for test_ar in area_objects:
		var test_dis: float = global_position.distance_to(test_ar.global_position)
		if test_dis > closest:
			continue
		closest = test_dis
		object = test_ar
	object = object.get_parent_node_3d()
	var pos: Vector3 = object.position
	var rot: Vector3 = object.rotation
	ProteinRegistry.remove_child(object)
	add_child(object)
	object.global_position = pos
	object.global_rotation = rot
	for protein in ProteinRegistry.proteins:
		if protein == object:
			ProteinRegistry.selected_proteins = [protein]
			break
	object_in_hand = object
	grabbed = true


func release_object() -> void:
	var pos: Vector3 = object_in_hand.global_position
	var rot: Vector3 = object_in_hand.global_rotation
	remove_child(object_in_hand)
	ProteinRegistry.add_child(object_in_hand)
	object_in_hand.position = pos
	object_in_hand.rotation = rot
	grabbed = false


const GRAB_THRESHOLD: float = 0.5


func _on_float_change(action: String, value: float) -> void:
	match action:
		"trigger":
			trigger_held = (value >= GRAB_THRESHOLD)
		"grip":
			grip_held = (value >= GRAB_THRESHOLD)


func _on_area_entered(area: Area3D) -> void:
	area_objects.append(area)


func _on_area_exited(area: Area3D) -> void:
	area_objects.erase(area)
