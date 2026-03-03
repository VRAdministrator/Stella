class_name ProteinInfo extends Node3D

#constants
const Default_Bonding_Radius:float=2.001
const Element_Index:Dictionary={'H': 0, 'D': 0, 'T': 0, 'HE': 2, 'LI': 3, 'BE': 4, 'B': 5, 'C': 6, 'N': 7, 'O': 8, 'F': 9, 'NE': 10, 'NA': 11, 'MG': 12, 'AL': 13, 'SI': 14, 'P': 15, 'S': 16, 'CL': 17, 'AR': 18, 'K': 19, 'CA': 20, 'SC': 21, 'TI': 22, 'V': 23, 'CR': 24, 'MN': 25, 'FE': 26, 'CO': 27, 'NI': 28, 'CU': 29, 'ZN': 30, 'GA': 31, 'GE': 32, 'AS': 33, 'SE': 34, 'BR': 35, 'KR': 36, 'RB': 37, 'SR': 38, 'Y': 39, 'ZR': 40, 'NB': 41, 'MO': 42, 'TC': 43, 'RU': 44, 'RH': 45, 'PD': 46, 'AG': 47, 'CD': 48, 'IN': 49, 'SN': 50, 'SB': 51, 'TE': 52, 'I': 53, 'XE': 54, 'CS': 55, 'BA': 56, 'LA': 57, 'CE': 58, 'PR': 59, 'ND': 60, 'PM': 61, 'SM': 62, 'EU': 63, 'GD': 64, 'TB': 65, 'DY': 66, 'HO': 67, 'ER': 68, 'TM': 69, 'YB': 70, 'LU': 71, 'HF': 72, 'TA': 73, 'W': 74, 'RE': 75, 'OS': 76, 'IR': 77, 'PT': 78, 'AU': 79, 'HG': 80, 'TL': 81, 'PB': 82, 'BI': 83, 'PO': 84, 'AT': 85, 'RN': 86, 'FR': 87, 'RA': 88, 'AC': 89, 'TH': 90, 'PA': 91, 'U': 92, 'NP': 93, 'PU': 94, 'AM': 95, 'CM': 96, 'BK': 97, 'CF': 98, 'ES': 99, 'FM': 100, 'MD': 101, 'NO': 102, 'LR': 103, 'RF': 104, 'DB': 105, 'SG': 106, 'BH': 107, 'HS': 108, 'MT': 109}
const Element_Bond_Thresholds:Dictionary={0:1.42, 1:1.42, 3:2.7, 4:2.7, 6:1.75, 7:1.6, 8:1.52, 11:2.7, 12:2.7, 13:2.7, 14:1.9, 15:1.9, 16:1.9, 17:1.8, 19:2.7, 20:2.7, 21:2.7, 22:2.7, 23:2.7, 24:2.7, 25:2.7, 26:2.7, 27:2.7, 28:2.7, 29:2.7, 30:2.7, 31:2.7, 33:2.68, 37:2.7, 38:2.7, 39:2.7, 40:2.7, 41:2.7, 42:2.7, 43:2.7, 44:2.7, 45:2.7, 46:2.7, 47:2.7, 48:2.7, 49:2.7, 50:2.7, 55:2.7, 56:2.7, 57:2.7, 58:2.7, 59:2.7, 60:2.7, 61:2.7, 62:2.7, 63:2.7, 64:2.7, 65:2.7, 66:2.7, 67:2.7, 68:2.7, 69:2.7, 70:2.7, 71:2.7, 72:2.7, 73:2.7, 74:2.7, 75:2.7, 76:2.7, 77:2.7, 78:2.7, 79:2.7, 80:2.7, 81:2.7, 82:2.7, 83:2.7, 87:2.7, 88:2.7, 89:2.7, 90:2.7, 91:2.7, 92:2.7, 93:2.7, 94:2.7, 95:2.7, 96:2.7, 97:2.7, 98:2.7, 99:2.7, 100:2.7, 101:2.7, 102:2.7, 103:2.7, 104:2.7, 105:2.7, 106:2.7, 107:2.7, 108:2.7, 109:2.88}
const Element_Pair_Thresholds:Dictionary={0:0.8, 20:1.31, 27:1.3, 35:1.3, 44:1.05, 54:1, 60:1.84, 72:1.88, 84:1.75, 85:1.56, 86:1.76, 98:1.6, 99:1.68, 100:1.63, 112:1.55, 113:1.59, 114:1.36, 129:1.45, 144:1.6, 170:1.4, 180:1.55, 202:2.4, 222:2.24, 224:1.91, 225:1.98, 243:2.02, 269:2, 293:1.9, 480:2.3, 512:2.3, 544:2.3, 612:2.1, 629:1.54, 665:1, 813:2.6, 854:2.27, 894:1.93, 896:2.1, 937:2.05, 938:2.06, 981:1.62, 1258:2.68, 1309:2.33, 1484:1, 1763:2.14, 1823:2.48, 1882:2.1, 1944:1.72, 2380:2.34, 3367:2.44, 3733:2.11, 3819:2.6, 3821:2.36, 4736:2.75, 5724:2.73, 5959:2.63, 6519:2.84, 6750:2.87, 8991:2.81}
#const MetalsSet:PackedStringArray=["LI", "NA", "K", "RB", "CS", "FR", "BE", "MG", "CA", "SR", "BA", "RA","AL", "GA", "IN", "SN", "TL", "PB", "BI", "SC", "TI", "V", "CR", "MN", "FE", "CO", "NI", "CU", "ZN", "Y", "ZR", "NB", "MO", "TC", "RU", "RH", "PD", "AG", "CD", "LA", "HF", "TA", "W", "RE", "OS", "IR", "PT", "AU", "HG", "AC", "RF", "DB", "SG", "BH", "HS", "MT", "CE", "PR", "ND", "PM", "SM", "EU", "GD", "TB", "DY", "HO", "ER", "TM", "YB", "LU", "TH", "PA", "U", "NP", "PU", "AM", "CM", "BK", "CF", "ES", "FM", "MD", "NO", "LR"]
const SPACEFILL_SCALE:float=0.01*2#converts picometers to angstrom and radius to diameter
const ATOMIC_RADII:PackedFloat32Array=[120,120,140,182,153,192,170,155,152,135,154,227,173,184,210,180,180,175,188,275,231,211,187,179,189,197,194,192,163,140,139,187,211,185,190,183,202,303,249,219,186,207,209,209,207,195,202,172,158,193,217,206,206,198,216,343,268,240,235,239,229,236,229,233,237,221,229,216,235,227,242,221,212,217,210,217,216,202,209,166,209,196,202,207,197,202,220,348,283,260,237,243,240,221,243,244,245,244,245,245]


const SHRINKWARP_SCALE:float=10000
const gr:float=SHRINKWARP_SCALE*(1+sqrt(5))/2
const icosahedron:PackedVector3Array=[
	Vector3(0,SHRINKWARP_SCALE,gr),Vector3(0,-SHRINKWARP_SCALE,gr),Vector3(0,SHRINKWARP_SCALE,-gr),
	Vector3(0,-SHRINKWARP_SCALE,-gr),Vector3(SHRINKWARP_SCALE,gr,0),Vector3(-SHRINKWARP_SCALE,gr,0),
	Vector3(SHRINKWARP_SCALE,-gr,0),Vector3(-SHRINKWARP_SCALE,-gr,0),Vector3(gr,0,SHRINKWARP_SCALE),
	Vector3(-gr,0,SHRINKWARP_SCALE),Vector3(gr,0,-SHRINKWARP_SCALE),Vector3(-gr,0,-SHRINKWARP_SCALE)]

const BACKBONE_CUTOFF:int=3
const HYDROGEN_BOND_DIST:float=1.15

#variables:

var pdb_name:String
var style:String="ball_n_stick"
var virtual_scale:float=0.01

@onready var collider:CollisionShape3D=$Area3D/CollisionShape3D
@onready var area:Area3D=$Area3D
@onready var model_base:Node3D=$model
@onready var atoms:MultiMesh=$model/atoms.multimesh
@onready var bonds:MultiMesh=$model/bonds.multimesh

var atom_positions:PackedVector3Array
var elements:PackedInt32Array
var atom_diameters:PackedFloat32Array



var selected_atoms:Array[bool]
var atom_position_type:Array[int]#0 for backbone,1 for side chain, 2 for otherstuff
var residue_styles:Array[String]#defalt:"ball_n_stick"
var hydrogens:Array[int]
var carbons:Array[int]
var nitrogens:Array[int]
var oxygens:Array[int]
var sulfurs:Array[int]
var atom_count:int

func change_style(old_style:String,new_style:String) -> void:
	match new_style:
		"ball_n_stick":
			match old_style:
				"spacefill":
					bonds.visible_instance_count=-1
					for i in range(atoms.instance_count):
						var temp_trans:Transform3D=atoms.get_instance_transform(i)
						var temp_ori:Vector3=temp_trans.origin
						temp_trans=temp_trans.scaled(Vector3.ONE/atom_diameters[i])
						temp_trans.origin=temp_ori
						atoms.set_instance_transform(i,temp_trans)
		"spacefill":
			match old_style:
				"ball_n_stick":
					bonds.visible_instance_count=0
					for i in range(atoms.instance_count):
						var temp_trans:Transform3D=atoms.get_instance_transform(i)
						var temp_ori:Vector3=temp_trans.origin
						temp_trans=temp_trans.scaled(atom_diameters[i]*Vector3.ONE)
						temp_trans.origin=temp_ori
						atoms.set_instance_transform(i,temp_trans)


func set_pdb(pdb_text:String,temp_name:String) -> ProteinInfo:
	pdb_name=temp_name
	var lines:PackedStringArray=pdb_text.split("\n")
	var center_pt:Vector3=Vector3.ZERO
	var amino_acid_index:int=0
	var amino_atom_index:int=0
	for line in lines:
		if line.substr(0,4)=="ATOM":
			var temp_pos=Vector3(line.substr(32).to_float(),line.substr(40).to_float(),line.substr(48).to_float())
			atom_positions.append(temp_pos)
			center_pt+=temp_pos
			var element:int=idx(line.substr(76, 2).strip_edges().to_upper())
			elements.append(element)
			match element:
				0:hydrogens.append(atom_count)
				6:carbons.append(atom_count)
				7:nitrogens.append(atom_count)
				8:oxygens.append(atom_count)
				16:sulfurs.append(atom_count)
			atom_diameters.append(SPACEFILL_SCALE*ATOMIC_RADII[element])
			atom_count+=1
			if line.substr(23,3).to_int()!=amino_acid_index:
				amino_acid_index+=1
				amino_atom_index=1
				atom_position_type.append(0)
				continue
			if BACKBONE_CUTOFF<amino_atom_index:
				atom_position_type.append(1)
			else:
				atom_position_type.append(0)
			amino_atom_index+=1
		#elif line.substr(0,5)=="HELIX":
			
		#elif line.substr(0,5)=="SHEET":
	center_pt/=atom_count
	selected_atoms.resize(atom_count)
	for i in range(atom_count):
		atom_positions[i]-=center_pt
	return self

func display_protein():
	atoms.instance_count=atom_count
	for i in range(atom_count):
		var temp_trans:Transform3D
		temp_trans.origin=atom_positions[i]
		atoms.set_instance_color(i,ProteinRegistry.Element_Default_Colors[elements[i]])
		atoms.set_instance_transform(i,temp_trans)
	var AnB_atoms:Array[PackedInt32Array]=compute_bonds()
	var A_atoms:PackedInt32Array=AnB_atoms[0]
	var B_atoms:PackedInt32Array=AnB_atoms[1]
	var bond_count:int=A_atoms.size()
	bonds.instance_count=bond_count
	for i in range(bond_count):
		var temp_trans:Transform3D
		var A_position:Vector3=atom_positions[A_atoms[i]]
		var bond_pos:Vector3=(A_position+atom_positions[B_atoms[i]])/2
		temp_trans.origin=bond_pos
		temp_trans=temp_trans.looking_at(A_position)
		temp_trans=temp_trans.rotated_local(Vector3.LEFT,PI/2)
		bonds.set_instance_transform(i,temp_trans)
	create_collider()

func query_3d(pos:Vector3,max_dis:float,start:int) -> Array:
	var atoms_indexs:PackedInt32Array
	var distances:PackedFloat32Array
	for i in range(start+1,atom_count):
		var temp_pos:Vector3=atom_positions[i]
		var dis:float=pos.distance_to(temp_pos)
		if max_dis<dis||dis==0:continue
		atoms_indexs.append(i)
		distances.append(dis)
	return [atoms_indexs,distances]

func idx(ele:String) -> int:
	if Element_Index.has(ele):
		return Element_Index[ele]
	return -1

func threshold(i:int) -> float:
	if i<0:return Default_Bonding_Radius
	var r:float=Element_Bond_Thresholds.get(i,0)
	if r==0:return Default_Bonding_Radius
	return r

func pair(a:int,b:int) -> int:
	@warning_ignore("integer_division")
	if a<b:return (a+b)*(a+b+1)/2+b
	@warning_ignore("integer_division")
	return (a+b)*(a+b+1)/2+a

func pair_threshold(i:int,j:int) -> float:
	if i<0||j<0:return -1
	var r:float=Element_Pair_Thresholds.get(pair(i,j),0)
	if r==0:return -1
	return r

func compute_bonds() -> Array[PackedInt32Array]:
	var A_atoms:PackedInt32Array
	var B_atoms:PackedInt32Array
	for ai in range(atom_count):
		var aei:int=elements[ai]
		var atom_infos=query_3d(atom_positions[ai],2,ai)
		var isHA:bool=aei==0
		var thresholdA:float=threshold(aei)
		for ni in range(atom_infos[0].size()):
			var bi:int=atom_infos[0][ni]
			var bei:int=elements[bi]
			var isHB:bool=bei==0
			if isHA&&isHA:continue
			if isHA||isHB:
				if atom_infos[1][ni]<HYDROGEN_BOND_DIST:
					A_atoms.append(ai)
					B_atoms.append(bi)
				continue
			var thresholdAB:float=pair_threshold(aei,bei)
			var pairing_threshold:float
			if thresholdAB>0:
				pairing_threshold=thresholdAB
			elif bei<0:
				pairing_threshold=thresholdA
			else:
				var thresholdB:float=threshold(bei)
				if thresholdA>thresholdB:
					pairing_threshold=thresholdA
				else:
					pairing_threshold=thresholdB
			if atom_infos[1][ni]<=pairing_threshold:
				A_atoms.append(ai)
				B_atoms.append(bi)
	return [A_atoms,B_atoms]

func create_collider() -> void:
	var shrinkwrap:PackedVector3Array
	shrinkwrap.resize(12)
	for i in range(12):
		var shortest_dis:float=100000
		var shortest_atom:Vector3
		for pos in atom_positions:
			var test_pos:float=icosahedron[i].distance_to(pos)
			if test_pos<shortest_dis:
				shortest_atom=pos
				shortest_dis=test_pos
		shrinkwrap[i]=shortest_atom
	collider.shape.points=shrinkwrap
	collider.disabled=false
