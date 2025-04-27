class_name protein_info

var file_path:String
var style:String="ball_n_stick"

var root:Node3D
var collider:CollisionShape3D
var area:Area3D
var model_base:Node3D

var atom_positions:PackedVector3Array
var elements:PackedInt32Array
var atom_diameters:PackedFloat32Array
var atoms:MultiMesh
var bonds:MultiMesh

#var hydrogens:Array[int]
var carbons:Array[int]
var nitrogens:Array[int]
var oxygens:Array[int]
var sulfurs:Array[int]
