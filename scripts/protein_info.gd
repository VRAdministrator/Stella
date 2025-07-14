class_name protein_info

var file_path:String
var style:String="ball_n_stick"
var scale:float=0.01

var root:Node3D
var collider:CollisionShape3D
var area:Area3D
var model_base:Node3D

var atom_positions:PackedVector3Array
var elements:PackedInt32Array
var atom_diameters:PackedFloat32Array
var atoms:MultiMesh
var bonds:MultiMesh


var selected_atoms:Array[bool]
var atom_position_type:Array[int]#0 for backbone,1 for side chain, 2 for otherstuff
var hydrogens:Array[int]
var carbons:Array[int]
var nitrogens:Array[int]
var oxygens:Array[int]
var sulfurs:Array[int]
