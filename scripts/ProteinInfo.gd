class_name ProteinInfo
extends Node3D

const BALL_AND_STICK_SCALE: float = 0.25 #one quarter of space fill size
const SPACEFILL_SCALE: float = 0.01 * 2 #converts picometers to angstrom and radius to diameter
const BACKBONE_CUTOFF: int = 3
const PDB_X_START: int = 32
const PDB_Y_START: int = 40
const PDB_Z_START: int = 48
const PDB_ELEMENT_START: int = 76

const SHRINKWARP_SCALE: float = 10000
const GR: float = SHRINKWARP_SCALE * (1 + sqrt(5)) / 2
const ICOSAHEDRON:PackedVector3Array=[
	Vector3(0,SHRINKWARP_SCALE,GR),Vector3(0,-SHRINKWARP_SCALE,GR),Vector3(0,SHRINKWARP_SCALE,-GR),
	Vector3(0,-SHRINKWARP_SCALE,-GR),Vector3(SHRINKWARP_SCALE,GR,0),Vector3(-SHRINKWARP_SCALE,GR,0),
	Vector3(SHRINKWARP_SCALE,-GR,0),Vector3(-SHRINKWARP_SCALE,-GR,0),Vector3(GR,0,SHRINKWARP_SCALE),
	Vector3(-GR,0,SHRINKWARP_SCALE),Vector3(GR,0,-SHRINKWARP_SCALE),Vector3(-GR,0,-SHRINKWARP_SCALE),]
const CUBE_SEARCH:PackedVector3Array=[
	Vector3(1,1,1),Vector3(1,1,0),Vector3(1,1,-1),Vector3(1,0,1),Vector3(1,0,0),Vector3(1,0,-1),Vector3(1,-1,1),Vector3(1,-1,0),Vector3(1,-1,-1),
	Vector3(0,1,1),Vector3(0,1,0),Vector3(0,1,-1),Vector3(0,0,1),Vector3(0,0,0),Vector3(0,0,-1),Vector3(0,-1,1),Vector3(0,-1,0),Vector3(0,-1,-1),
	Vector3(-1,1,1),Vector3(-1,1,0),Vector3(-1,1,-1),Vector3(-1,0,1),Vector3(-1,0,0),Vector3(-1,0,-1),Vector3(-1,-1,1),Vector3(-1,-1,0),Vector3(-1,-1,-1),]
enum Style { UNSET, SPACEFILL, BALL_AND_STICK }
enum AtomType { BACKBONE, SIDE_CHAIN }
const DEFAULT_SCALE: float = 0.01

var pdb_name: String
var current_style: Style = Style.UNSET
var virtual_scale: float = DEFAULT_SCALE

@onready var collider: CollisionShape3D = $Area3D/CollisionShape3D
@onready var area: Area3D = $Area3D
@onready var model_base: Node3D = $model
@onready var atoms_instance: MultiMeshInstance3D = $model/atoms #change this
@onready var bonds_instance: MultiMeshInstance3D = $model/bonds

var atoms: MultiMesh
var bonds: MultiMesh

var atom_count: int
var atom_positions: PackedVector3Array
var elements: PackedInt32Array
var element_lists: Dictionary[int, PackedInt32Array]
var atom_diameters: PackedFloat32Array

var selected_atoms: Array[bool]
var atom_position_type: Array[AtomType]


func set_style(new_style: Style) -> void:
	if new_style == current_style:
		return
	match new_style:
		Style.BALL_AND_STICK:
			bonds.visible_instance_count = -1
			for i in range(atom_count):
				var temp_trans: Transform3D = atoms.get_instance_transform(i)
				temp_trans.basis = Basis.from_scale(Vector3.ONE * BALL_AND_STICK_SCALE * atom_diameters[i])
				atoms.set_instance_transform(i, temp_trans)
		Style.SPACEFILL:
			bonds.visible_instance_count = 0
			for i in range(atom_count):
				var temp_trans: Transform3D = atoms.get_instance_transform(i)
				temp_trans.basis = Basis.from_scale(atom_diameters[i] * Vector3.ONE)
				atoms.set_instance_transform(i, temp_trans)
	current_style = new_style


func set_pdb(pdb_text: String, temp_name: String) -> ProteinInfo:
	pdb_name = temp_name
	var lines: PackedStringArray = pdb_text.split("\n")
	var center_pt: Vector3 = Vector3.ZERO
	var amino_acid_index: int = 0
	var amino_atom_index: int = 0
	for line in lines:
		if line.begins_with("ATOM"):
			var temp_pos = Vector3(line.substr(PDB_X_START).to_float(), line.substr(PDB_Y_START).to_float(), line.substr(PDB_Z_START).to_float())
			var element: int = idx(line.substr(PDB_ELEMENT_START, 2).strip_edges().to_upper())
			if element == -1:
				print("error unknown element: " + line.substr(PDB_ELEMENT_START, 2).strip_edges().to_upper())
				continue
			atom_positions.append(temp_pos)
			center_pt += temp_pos
			elements.append(element)
			var element_list: PackedInt32Array = element_lists.get(element, [])
			element_list.append(atom_count)
			if len(element_list) == 1:
				element_lists[element] = element_list
			atom_diameters.append(SPACEFILL_SCALE * EmpiricalConstants.ATOMIC_RADII[element])
			atom_count += 1
			if line.substr(22, 4).strip_edges().to_int() != amino_acid_index:
				amino_acid_index += 1
				amino_atom_index = 1
				atom_position_type.append(AtomType.BACKBONE)
				continue
			if BACKBONE_CUTOFF < amino_atom_index:
				atom_position_type.append(AtomType.SIDE_CHAIN)
			else:
				atom_position_type.append(AtomType.BACKBONE)
			amino_atom_index += 1
		#elif line.begins_with("HETATM"):

		#elif line.begins_with("TER"):

		#elif line.begins_with("HELIX"):

		#elif line.begins_with("SHEET"):

		#elif line.begins_with("SSBOND"):
	if atom_count == 0:
		print("could not load pbd, no atoms found")
		return null
	center_pt /= atom_count
	selected_atoms.resize(atom_count)
	for i in range(atom_count):
		atom_positions[i] -= center_pt
	return self


func _ready() -> void:
	display_protein()
	create_collider()


func display_protein() -> void:
	atoms = atoms_instance.multimesh.duplicate()
	atoms_instance.multimesh = atoms
	bonds = bonds_instance.multimesh.duplicate()
	bonds_instance.multimesh = bonds
	atoms.instance_count = atom_count
	for i in range(atom_count):
		var temp_trans: Transform3D
		temp_trans.origin = atom_positions[i]
		atoms.set_instance_color(i, ProteinRegistry.ELEMENT_DEFAULT_COLORS[elements[i]])
		atoms.set_instance_transform(i, temp_trans)
	var AnB_atoms: Array[PackedInt32Array] = compute_bonds()
	var A_atoms: PackedInt32Array = AnB_atoms[0]
	var B_atoms: PackedInt32Array = AnB_atoms[1]
	var bond_count: int = A_atoms.size()
	bonds.instance_count = bond_count
	for i in range(bond_count):
		var temp_trans: Transform3D
		var A_position: Vector3 = atom_positions[A_atoms[i]]
		var B_potition: Vector3 = atom_positions[B_atoms[i]]
		var bond_pos: Vector3 = (A_position + B_potition) / 2
		temp_trans.origin = bond_pos
		temp_trans = temp_trans.looking_at(A_position)
		temp_trans = temp_trans.rotated_local(Vector3.LEFT, PI / 2)
		bonds.set_instance_transform(i, temp_trans)
	set_style(Style.BALL_AND_STICK)
	ProteinRegistry.selected_proteins.append(self)


func spatial_hash(pt: Vector3) -> Vector3:
	return (pt / EmpiricalConstants.LARGEST_BONDING_THRESHOLD).floor()


func gen_spatial_hash_table() -> Dictionary[Vector3, PackedInt32Array]:
	var hash_dict: Dictionary[Vector3, PackedInt32Array]
	for i in range(atom_count):
		var hash_value: Vector3 = spatial_hash(atom_positions[i])
		var collision_array: PackedInt32Array = hash_dict.get(hash_value, [])
		collision_array.append(i)
		if collision_array.size() == 1:
			hash_dict[hash_value] = collision_array
	return hash_dict


func query_3d(atom_pt: int, hash_dict: Dictionary[Vector3, PackedInt32Array]) -> Array:
	var atom_indices: PackedInt32Array
	var distances: PackedFloat32Array
	var atom_position: Vector3 = atom_positions[atom_pt]
	var hash_value: Vector3 = spatial_hash(atom_position)
	for search in CUBE_SEARCH:
		var search_value = (hash_value - search)
		var atom_pts: PackedInt32Array = hash_dict.get(search_value, [])
		if atom_pts.is_empty():
			continue
		for pt in atom_pts:
			if atom_pt >= pt:
				continue
			var distance: float = (atom_position - atom_positions[pt]).length()
			if distance > EmpiricalConstants.LARGEST_BONDING_THRESHOLD || distance == 0:
				continue
			atom_indices.append(pt)
			distances.append(distance)
	return [atom_indices, distances]


func idx(ele: String) -> int:
	return EmpiricalConstants.ELEMENT_INDEX.get(ele, -1)


func threshold(i: int) -> float:
	return EmpiricalConstants.ELEMENT_BOND_THRESHOLDS.get(i, EmpiricalConstants.DEFAULT_BONDING_RADIUS)


func pair(a: int, b: int) -> int:
	if a < b:
		@warning_ignore("integer_division")
		return (a + b) * (a + b + 1) / 2 + b
	@warning_ignore("integer_division")
	return (a + b) * (a + b + 1) / 2 + a


func pair_threshold(i: int, j: int) -> float:
	if i < 0 || j < 0:
		return -1
	var r: float = EmpiricalConstants.ELEMENT_PAIR_THRESHOLDS.get(pair(i, j), -1)
	return r


func compute_bonds() -> Array[PackedInt32Array]:
	var A_atoms: PackedInt32Array
	var B_atoms: PackedInt32Array
	var hash_dict: Dictionary[Vector3, PackedInt32Array] = gen_spatial_hash_table()
	for ai in range(atom_count):
		var aei: int = elements[ai]
		var local_atoms = query_3d(ai, hash_dict)
		var isHA: bool = aei == 1
		var thresholdA: float = threshold(aei)
		for ni in range(local_atoms[0].size()):
			var bi: int = local_atoms[0][ni]
			var bei: int = elements[bi]
			var isHB: bool = bei == 1
			if isHA && isHB:
				continue
			if isHA || isHB:
				if local_atoms[1][ni] < EmpiricalConstants.HYDROGEN_BOND_DIST:
					A_atoms.append(ai)
					B_atoms.append(bi)
				continue
			var thresholdAB: float = pair_threshold(aei, bei)
			var pairing_threshold: float
			if thresholdAB > 0:
				pairing_threshold = thresholdAB
			elif bei < 0:
				pairing_threshold = thresholdA
			else:
				var thresholdB: float = threshold(bei)
				if thresholdA > thresholdB:
					pairing_threshold = thresholdA
				else:
					pairing_threshold = thresholdB
			if local_atoms[1][ni] <= pairing_threshold:
				A_atoms.append(ai)
				B_atoms.append(bi)
	return [A_atoms, B_atoms]


func create_collider() -> void:
	var shrinkwrap: PackedVector3Array
	shrinkwrap.resize(12)
	for i in range(12):
		var shortest_dist: float = INF
		var shortest_atom: Vector3
		for pos in atom_positions:
			var test_dist: float = ICOSAHEDRON[i].distance_to(pos)
			if test_dist < shortest_dist:
				shortest_atom = pos
				shortest_dist = test_dist
		shrinkwrap[i] = shortest_atom
	collider.shape.points = shrinkwrap
	collider.disabled = false
