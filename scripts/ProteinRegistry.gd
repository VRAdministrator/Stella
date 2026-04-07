extends Node3D

@onready var protein_model = preload("res://scenes/potein_parts/protein.tscn")

#constants:
const ELEMENT_DEFAULT_COLORS: Array[Color] = [Color.CYAN, Color.CYAN, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.DIM_GRAY, Color.BLUE, Color.RED, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK, Color.GREEN]
const PROTEIN_LINEUP_DISTANCE: float = 1
const DIAGONAL_SHIFT: Vector3 = Vector3(-1, 0, 1) * PROTEIN_LINEUP_DISTANCE
const START_POINT: Vector3 = Vector3(0, 1, 0)

var proteins: Array[ProteinInfo] = []
var selected_proteins: Array[ProteinInfo] = []


func load_protien(full_path: String, file_name: String) -> void:
	var file = FileAccess.open(full_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var duplicates: int = 0
	for test_protein in proteins:
		if test_protein.pdb_name.begins_with(file_name):
			duplicates += 1
	if duplicates > 0:
		file_name += "(" + str(duplicates) + ")"
	var protein: ProteinInfo = protein_model.instantiate().set_pdb(content, file_name)
	add_child(protein)
	proteins.append(protein)


func reset_proteins() -> void:
	var diagonal_goal: int = 0
	var diagonal_pt: int = 0
	var current_pt = START_POINT
	for protein in ProteinRegistry.proteins:
		protein.virtual_scale = protein.DEFAULT_SCALE
		protein.model_base.scale = Vector3.ONE * protein.DEFAULT_SCALE
		protein.area.scale = Vector3.ONE * protein.DEFAULT_SCALE
		for index in range(protein.atoms.instance_count):
			var atom_color: Color = ELEMENT_DEFAULT_COLORS[protein.elements[index]]
			protein.atoms.set_instance_color(index, atom_color)
			protein.set_style(protein.Style.BALL_AND_STICK)
		protein.global_position = current_pt
		if diagonal_pt != diagonal_goal:
			current_pt += DIAGONAL_SHIFT
			diagonal_pt += 1
			continue
		diagonal_goal += 1
		diagonal_pt = 0
		current_pt.x = diagonal_goal
		current_pt.z = 0
