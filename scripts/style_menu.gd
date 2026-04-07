extends Control

func _on_ball_n_stick_pressed() -> void:
	for protein in ProteinRegistry.selected_proteins:
		protein.set_style(ProteinInfo.Style.BALL_AND_STICK)


func _on_spacefill_pressed() -> void:
	for protein in ProteinRegistry.selected_proteins:
		protein.set_style(ProteinInfo.Style.SPACEFILL)
