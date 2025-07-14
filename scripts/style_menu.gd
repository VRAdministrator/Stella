extends Control

func _on_ball_n_stick_pressed() -> void:
	for protein in ProteinInfos.selected_proteins:
		protein.style="ball_n_stick"

func _on_spacefill_pressed() -> void:
	for protein in ProteinInfos.selected_proteins:
		protein.style="spacefil"
