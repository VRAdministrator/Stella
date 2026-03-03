extends Control

@onready var Color_display:ColorRect=$ColorRect
@onready var pointer:TextureRect=$Button/TextureRect
@onready var transparent_button:Button=$transparent

var pressed:bool
var current_color:Color=Color.WHITE
var transparent:bool

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pressed=true
		else:pressed=false
	elif event is InputEventMouseMotion:
			if !pressed:return
			var pt:Vector2=event.position
			var saturation:float=pt.distance_to(Vector2(200,200))/200
			if saturation>1:return
			pointer.position=pt-Vector2(5,5)
			var hue:float=asin((pt.x-200.0)/200.0/saturation)/(4*PI)
			if hue<0:
				hue+=1
				if pt.y>200:hue-=0.25
			else:
				if pt.y>200:hue+=0.25
			current_color=Color.from_hsv(hue,saturation,1)
			Color_display.color=current_color

#func toggle_transparent():
	#if transparent_button.button_pressed:current_color.a=0
	#else:current_color.a=1
	#Color_display.color=current_color

func _on_apply_pressed() -> void:
	for protein in ProteinRegistry.selected_proteins:
		for i in range(protein.atoms.instance_count):
			if !protein.selected_atoms[i]:continue
			protein.atoms.set_instance_color(i,current_color)
	
