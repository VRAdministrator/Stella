class_name protein_info

var file_path:String
var style:String="ball_n_stick"

var root:Node3D
var collider:CollisionShape3D
var area:Area3D
var model_base:Node3D

var atom_positions:PackedVector3Array
var elements:PackedStringArray
var atom_diameters:PackedFloat32Array
var atoms:Array[Node3D]
var bonds:Array[Node3D]

#var hydrogens:Array[Node3D]
var carbons:Array[Node3D]
var nitrogens:Array[Node3D]
var oxygens:Array[Node3D]
var sulfurs:Array[Node3D]
