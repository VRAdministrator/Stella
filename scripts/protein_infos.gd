extends Node#maybe not needed
var proteins:Array[protein_info]=[]
var protein_names:PackedStringArray
var selected_proteins:Array[protein_info]=[]

func reset_proteins():
	var diagonal_goal=0
	var diaganal_pt=0
	var current_pt=Vector3(0,1,0)
	for protein in ProteinInfos.proteins:
		protein.scale=0.01
		protein.model_base.scale=Vector3.ONE*0.01
		protein.area.scale=Vector3.ONE*0.01
		for index in range(protein.atoms.instance_count):
			var atom_color:Color=Element_Default_Colors[protein.elements[index]]
			protein.atoms.set_instance_color(index,atom_color)
		protein.root.global_position=current_pt
		if diaganal_pt!=diagonal_goal:
			current_pt+=Vector3(-1,0,1)
			diaganal_pt+=1
			continue
		diagonal_goal+=1
		diaganal_pt=0
		current_pt.x=diagonal_goal
		current_pt.z=0

var Element_Default_Colors:Array[Color]=[Color.CYAN,Color.CYAN,Color.BLACK,Color.BLACK,Color.BLACK,Color.BLACK,Color.DIM_GRAY,Color.BLUE,Color.RED,Color.BLACK,Color.BLACK,Color.BLACK,Color.BLACK,Color.BLACK,Color.BLACK,Color.BLACK,Color.GREEN]
