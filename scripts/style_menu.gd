extends Control

#this menu will need to be updated to handle multiple protiens
func _on_ball_n_stick_pressed() -> void:
	ProteinInfos.proteins[0].style="ball_n_stick"#more multiprotein work needed 

func _on_spacefill_pressed() -> void:
	ProteinInfos.proteins[0].style="spacefil"
