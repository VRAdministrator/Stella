extends Control

@onready var Color_display:ColorRect=$ColorRect
@onready var pointer:TextureRect=$Button/TextureRect

#var color_wheel:Image=preload("res://assets/Color_circle_(RGB).svg").get_image()
var pressed:bool
var current_color:Color=Color.WHITE
var hue:float
var saturation:float


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed=true
		else:pressed=false
	elif event is InputEventMouseMotion:
			if !pressed:return
			var position:Vector2=event.position
			var saturation:float=position.distance_to(Vector2(200,200))/200
			if saturation>1:return
			pointer.position=position-Vector2(5,5)
			var hue:float=asin((position.x-200.0)/200.0/saturation)/(4*PI)
			if hue<0:
				hue+=1
				if position.y>200:hue-=0.25#trash find better way
			else:
				if position.y>200:hue+=0.25
			current_color=Color.from_hsv(hue,saturation,1)
			Color_display.color=current_color


func _on_apply_pressed() -> void:
	var protein:protein_info=ProteinInfos.selected_protein
	if protein==null:return
	for i in range(protein.atoms.instance_count):
		if !protein.selected_atoms[i]:continue
		protein.atoms.set_instance_color(i,current_color)
