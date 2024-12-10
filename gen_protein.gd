extends Node3D

#var atom_model=preload("res://models/ATOM.tscn")


@onready var atom_model=preload("res://models/ATOM.tscn")
@onready var bond_model=preload("res://models/BOND.tscn")

@onready var carbon_color=preload("res://colors/carbon_color.tres")
@onready var nitrogen_color=preload("res://colors/nitrogen_color.tres")
@onready var oxygen_color=preload("res://colors/oxygen_color.tres")
@onready var sulfur_color=preload("res://colors/sulfur_color.tres")
@onready var bond_color=preload("res://colors/bond_color.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	_external_pdb_load("/home/havenj/Downloads/1mbo.pdb")

func _external_pdb_load(path:String):
	var file=FileAccess.open(path,FileAccess.READ)
	var content=file.get_as_text()
	file.close()
	var lines:PackedStringArray=content.split("\n")
	load_pdb(lines)

func disable_ball_n_stick():
	bond_color.albedo_color=Color.TRANSPARENT

func enable_ball_n_stick(atoms:Array[Node3D]):
	#bond_color.albedo_color=Color.WHITE
	for atom in atoms:
		atom.scale=Vector3(1,1,1)

func load_pdb(lines:PackedStringArray):
	var atom_positions:PackedVector3Array
	var elements:PackedStringArray
	var atom_diameters:PackedFloat32Array
	
	
	var atoms:Array[Node3D]
	var bonds:Array[Node3D]
	var hydrogens:Array[Node3D]
	var carbons:Array[Node3D]
	var nitrogens:Array[Node3D]
	var oxygens:Array[Node3D]
	var sulfurs:Array[Node3D]
	
	var center_pt:Vector3=Vector3.ZERO
	for line in lines:
		if line.substr(0,4)=="ATOM":
			var temp_atom:MeshInstance3D=atom_model.instantiate()
			var temp_pos=Vector3(line.substr(32).to_float(),line.substr(40).to_float(),line.substr(48).to_float())
			atom_positions.append(temp_pos)
			center_pt+=temp_pos
			var element=line.substr(77,1)
			elements.append(element)
			atoms.append(temp_atom)
			var atom_ei:int=idx(element)
			match atom_ei:
				1:pass#why are there no hydrogens
				6:
					carbons.append(temp_atom)
					temp_atom.material_override=carbon_color
				7:
					nitrogens.append(temp_atom)
					temp_atom.material_override=nitrogen_color
				8:
					oxygens.append(temp_atom)
					temp_atom.material_override=oxygen_color
				16:
					sulfurs.append(temp_atom)
					temp_atom.material_override=sulfur_color
			var scaling_factor:float=spacefil_scale*atomic_radii[atom_ei]
			atom_diameters.append(scaling_factor)
			temp_atom.scale=Vector3.ONE*scaling_factor
			add_child(temp_atom)
		#elif line.substr(0,5)=="HELIX":
			
		#elif line.substr(0,5)=="SHEET":
	center_pt/=atom_positions.size()
	for i in range(atom_positions.size()):
		atom_positions[i]-=center_pt
		atoms[i].position=atom_positions[i]
	var AnB_atoms:Array[PackedInt32Array]=compute_bonds(elements,atom_positions)#maybe return distance as well
	var A_atoms:PackedInt32Array=AnB_atoms[0]
	var B_atoms:PackedInt32Array=AnB_atoms[1]
	var num_bonds:int=A_atoms.size()
	bonds.resize(num_bonds)
	for i in range(num_bonds):
		var temp_bond:Node3D=bond_model.instantiate()
		var A_position:Vector3=atom_positions[A_atoms[i]]
		var bond_pos:Vector3=(A_position+atom_positions[B_atoms[i]])/2
		temp_bond.look_at_from_position(bond_pos,A_position)
		add_child(temp_bond)
		bonds[i]=temp_bond
	print(bonds[0].rotation_degrees)
	enable_ball_n_stick(atoms)




const spacefil_scale:float=0.01*2#convert picometers to angstrom and radius to diameter 

const atomic_radii:PackedFloat32Array=[120,120,140,182,153,192,170,155,152,135,154,227,173,184,210,180,180,175,188,275,231,211,187,179,189,197,194,192,163,140,139,187,211,185,190,183,202,303,249,219,186,207,209,209,207,195,202,172,158,193,217,206,206,198,216,343,268,240,235,239,229,236,229,233,237,221,229,216,235,227,242,221,212,217,210,217,216,202,209,166,209,196,202,207,197,202,220,348,283,260,237,243,240,221,243,244,245,244,245,245]

#bond calculation code
const Default_Bonding_Radius:float=2.001
var Element_Index:Dictionary={"H":0,"h":0,"D":0,"d":0,"T":0,"t":0,"He":2,"HE":2,"he":2,"Li":3,"LI":3,"li":3,"Be":4,"BE":4,"be":4,"B":5,"b":5,"C":6,"c":6,"N":7,"n":7,"O":8,"o":8,"F":9,"f":9,"Ne":10,"NE":10,"ne":10,"Na":11,"NA":11,"na":11,"Mg":12,"MG":12,"mg":12,"Al":13,"AL":13,"al":13,"Si":14,"SI":14,"si":14,"P":15,"p":15,"S":16,"s":16,"Cl":17,"CL":17,"cl":17,"Ar":18,"AR":18,"ar":18,"K":19,"k":19,"Ca":20,"CA":20,"ca":20,"Sc":21,"SC":21,"sc":21,"Ti":22,"TI":22,"ti":22,"V":23,"v":23,"Cr":24,"CR":24,"cr":24,"Mn":25,"MN":25,"mn":25,"Fe":26,"FE":26,"fe":26,"Co":27,"CO":27,"co":27,"Ni":28,"NI":28,"ni":28,"Cu":29,"CU":29,"cu":29,"Zn":30,"ZN":30,"zn":30,"Ga":31,"GA":31,"ga":31,"Ge":32,"GE":32,"ge":32,"As":33,"AS":33,"as":33,"Se":34,"SE":34,"se":34,"Br":35,"BR":35,"br":35,"Kr":36,"KR":36,"kr":36,"Rb":37,"RB":37,"rb":37,"Sr":38,"SR":38,"sr":38,"Y":39,"y":39,"Zr":40,"ZR":40,"zr":40,"Nb":41,"NB":41,"nb":41,"Mo":42,"MO":42,"mo":42,"Tc":43,"TC":43,"tc":43,"Ru":44,"RU":44,"ru":44,"Rh":45,"RH":45,"rh":45,"Pd":46,"PD":46,"pd":46,"Ag":47,"AG":47,"ag":47,"Cd":48,"CD":48,"cd":48,"In":49,"IN":49,"in":49,"Sn":50,"SN":50,"sn":50,"Sb":51,"SB":51,"sb":51,"Te":52,"TE":52,"te":52,"I":53,"i":53,"Xe":54,"XE":54,"xe":54,"Cs":55,"CS":55,"cs":55,"Ba":56,"BA":56,"ba":56,"La":57,"LA":57,"la":57,"Ce":58,"CE":58,"ce":58,"Pr":59,"PR":59,"pr":59,"Nd":60,"ND":60,"nd":60,"Pm":61,"PM":61,"pm":61,"Sm":62,"SM":62,"sm":62,"Eu":63,"EU":63,"eu":63,"Gd":64,"GD":64,"gd":64,"Tb":65,"TB":65,"tb":65,"Dy":66,"DY":66,"dy":66,"Ho":67,"HO":67,"ho":67,"Er":68,"ER":68,"er":68,"Tm":69,"TM":69,"tm":69,"Yb":70,"YB":70,"yb":70,"Lu":71,"LU":71,"lu":71,"Hf":72,"HF":72,"hf":72,"Ta":73,"TA":73,"ta":73,"W":74,"w":74,"Re":75,"RE":75,"re":75,"Os":76,"OS":76,"os":76,"Ir":77,"IR":77,"ir":77,"Pt":78,"PT":78,"pt":78,"Au":79,"AU":79,"au":79,"Hg":80,"HG":80,"hg":80,"Tl":81,"TL":81,"tl":81,"Pb":82,"PB":82,"pb":82,"Bi":83,"BI":83,"bi":83,"Po":84,"PO":84,"po":84,"At":85,"AT":85,"at":85,"Rn":86,"RN":86,"rn":86,"Fr":87,"FR":87,"fr":87,"Ra":88,"RA":88,"ra":88,"Ac":89,"AC":89,"ac":89,"Th":90,"TH":90,"th":90,"Pa":91,"PA":91,"pa":91,"U":92,"u":92,"Np":93,"NP":93,"np":93,"Pu":94,"PU":94,"pu":94,"Am":95,"AM":95,"am":95,"Cm":96,"CM":96,"cm":96,"Bk":97,"BK":97,"bk":97,"Cf":98,"CF":98,"cf":98,"Es":99,"ES":99,"es":99,"Fm":100,"FM":100,"fm":100,"Md":101,"MD":101,"md":101,"No":102,"NO":102,"no":102,"Lr":103,"LR":103,"lr":103,"Rf":104,"RF":104,"rf":104,"Db":105,"DB":105,"db":105,"Sg":106,"SG":106,"sg":106,"Bh":107,"BH":107,"bh":107,"Hs":108,"HS":108,"hs":108,"Mt":109,"MT":109,"mt":109};
var Element_Bond_Thresholds:Dictionary={0:1.42, 1:1.42, 3:2.7, 4:2.7, 6:1.75, 7:1.6, 8:1.52, 11:2.7, 12:2.7, 13:2.7, 14:1.9, 15:1.9, 16:1.9, 17:1.8, 19:2.7, 20:2.7, 21:2.7, 22:2.7, 23:2.7, 24:2.7, 25:2.7, 26:2.7, 27:2.7, 28:2.7, 29:2.7, 30:2.7, 31:2.7, 33:2.68, 37:2.7, 38:2.7, 39:2.7, 40:2.7, 41:2.7, 42:2.7, 43:2.7, 44:2.7, 45:2.7, 46:2.7, 47:2.7, 48:2.7, 49:2.7, 50:2.7, 55:2.7, 56:2.7, 57:2.7, 58:2.7, 59:2.7, 60:2.7, 61:2.7, 62:2.7, 63:2.7, 64:2.7, 65:2.7, 66:2.7, 67:2.7, 68:2.7, 69:2.7, 70:2.7, 71:2.7, 72:2.7, 73:2.7, 74:2.7, 75:2.7, 76:2.7, 77:2.7, 78:2.7, 79:2.7, 80:2.7, 81:2.7, 82:2.7, 83:2.7, 87:2.7, 88:2.7, 89:2.7, 90:2.7, 91:2.7, 92:2.7, 93:2.7, 94:2.7, 95:2.7, 96:2.7, 97:2.7, 98:2.7, 99:2.7, 100:2.7, 101:2.7, 102:2.7, 103:2.7, 104:2.7, 105:2.7, 106:2.7, 107:2.7, 108:2.7, 109:2.88}
var Element_Pair_Thresholds:Dictionary={0:0.8, 20:1.31, 27:1.3, 35:1.3, 44:1.05, 54:1, 60:1.84, 72:1.88, 84:1.75, 85:1.56, 86:1.76, 98:1.6, 99:1.68, 100:1.63, 112:1.55, 113:1.59, 114:1.36, 129:1.45, 144:1.6, 170:1.4, 180:1.55, 202:2.4, 222:2.24, 224:1.91, 225:1.98, 243:2.02, 269:2, 293:1.9, 480:2.3, 512:2.3, 544:2.3, 612:2.1, 629:1.54, 665:1, 813:2.6, 854:2.27, 894:1.93, 896:2.1, 937:2.05, 938:2.06, 981:1.62, 1258:2.68, 1309:2.33, 1484:1, 1763:2.14, 1823:2.48, 1882:2.1, 1944:1.72, 2380:2.34, 3367:2.44, 3733:2.11, 3819:2.6, 3821:2.36, 4736:2.75, 5724:2.73, 5959:2.63, 6519:2.84, 6750:2.87, 8991:2.81}
const MetalsSet:PackedStringArray=["LI", "NA", "K", "RB", "CS", "FR", "BE", "MG", "CA", "SR", "BA", "RA","AL", "GA", "IN", "SN", "TL", "PB", "BI", "SC", "TI", "V", "CR", "MN", "FE", "CO", "NI", "CU", "ZN", "Y", "ZR", "NB", "MO", "TC", "RU", "RH", "PD", "AG", "CD", "LA", "HF", "TA", "W", "RE", "OS", "IR", "PT", "AU", "HG", "AC", "RF", "DB", "SG", "BH", "HS", "MT", "CE", "PR", "ND", "PM", "SM", "EU", "GD", "TB", "DY", "HO", "ER", "TM", "YB", "LU", "TH", "PA", "U", "NP", "PU", "AM", "CM", "BK", "CF", "ES", "FM", "MD", "NO", "LR"]

func quary_3d(pos:Vector3,positions:PackedVector3Array,max_dis:float,start:int)->Array:
	var atoms:PackedInt32Array
	var distances:PackedFloat32Array
	for i in range(start+1,positions.size()):
		var temp_pos:Vector3=positions[i]
		var dis:float=pos.distance_to(temp_pos)
		if max_dis<dis||dis==0:continue
		atoms.append(i)
		distances.append(dis)
	return [atoms,distances]

func idx(ele:String)->int:
	var i:int=Element_Index[ele]
	if i==0:return -1
	return i

func is_hydrogen(index:int)->bool:#inline this please
	if index==0:return true
	return false

func threshold(i:int)->float:
	if i<0:return Default_Bonding_Radius
	var r:float=Element_Bond_Thresholds.get(i,0)#may not work if not in list?
	if r==0:return Default_Bonding_Radius
	return r

func pair(a:int,b:int)->int:
	if a<b:return (a+b)*(a+b+1)/2+b
	return (a+b)*(a+b+1)/2+a

func pair_threshold(i:int,j:int)->float:
	if i<0||j<0:return -1
	var r:float=Element_Pair_Thresholds.get(pair(i,j),0)
	if r==0:return -1
	return r

func compute_bonds(eles:PackedStringArray,positions:PackedVector3Array)->Array[PackedInt32Array]:
	var total_atoms:int=eles.size()
	var A_atoms:PackedInt32Array
	var B_atoms:PackedInt32Array
	for ai in range(total_atoms):
		var aei:int=idx(eles[ai])
		var atom_infos=quary_3d(positions[ai],positions,2,ai)
		var isHA:bool=is_hydrogen(aei)
		var thresholdA:float=threshold(aei)
		var metalA:bool=MetalsSet.has(eles[ai])
		for ni in range(atom_infos[0].size()):
			var bi:int=atom_infos[0][ni]
			var bei:int=idx(eles[bi])
			var isHB:bool=is_hydrogen(bei)
			if isHA&&isHA:continue
			if isHA||isHB:
				if atom_infos[1][ni]<1.15:
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
			var metalB:bool=MetalsSet.has(eles[bi])
			if atom_infos[1][ni]<=pairing_threshold:
				A_atoms.append(ai)
				B_atoms.append(bi)
	return [A_atoms,B_atoms]
