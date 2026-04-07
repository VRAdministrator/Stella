extends Control

const START_ENTRY_POINT: int = 4
const NUMBER_ENTRIES: int = 9
const SELECT_BOX_LENGTH: int = 3
const SELECTED_BOX: String = "[*]"
const UNSELECTED_BOX: String = "[ ]"

@onready var menu_entries: MenuEntries = MenuEntries.new(self, click_entry, START_ENTRY_POINT, NUMBER_ENTRIES)

var current_submenu_protein_select: bool = true
var selected_entries: Array[bool]
var element_numbers: PackedInt32Array


func _ready() -> void:
	refresh_and_set_protein_state()


func refresh_and_set_protein_state() -> void:
	current_submenu_protein_select = true
	var temp_list: PackedStringArray
	var num_proteins: int = ProteinRegistry.proteins.size()
	selected_entries.resize(num_proteins)
	for i in range(num_proteins):
		var protein: ProteinInfo = ProteinRegistry.proteins[i]
		var protein_selected: bool = protein in ProteinRegistry.selected_proteins
		selected_entries[i] = protein_selected
		if protein_selected:
			temp_list.append(SELECTED_BOX + protein.pdb_name)
			continue
		temp_list.append(UNSELECTED_BOX + protein.pdb_name)
	menu_entries.item_list = temp_list
	menu_entries.list_start_pt = 0
	menu_entries.refresh_entries()


func refresh_and_set_parts_state() -> void:
	current_submenu_protein_select = false
	set_element_list()
	selected_entries.resize(menu_entries.item_list.size())
	selected_entries.fill(false)
	menu_entries.list_start_pt = 0
	menu_entries.refresh_entries()


func activate_menu() -> void:
	refresh_and_set_protein_state()


func click_protein_entry(button: Button, entry_text: String) -> void:
	var protein_pt: int = menu_entries.item_list.find(entry_text)
	var protein: ProteinInfo = ProteinRegistry.proteins[protein_pt]
	var core_text: String = entry_text.substr(SELECT_BOX_LENGTH)
	if selected_entries[protein_pt]:
		ProteinRegistry.selected_proteins.erase(protein)
		button.text = UNSELECTED_BOX + core_text
	else:
		ProteinRegistry.selected_proteins.append(protein)
		button.text = SELECTED_BOX + core_text
	selected_entries[protein_pt] = !selected_entries[protein_pt]


func click_parts_entry(button: Button, entry_text: String) -> void:
	var num: int = menu_entries.button_entries.find(button)
	if entry_text.is_empty():
		return
	var entry_pt: int = menu_entries.list_start_pt + num
	selected_entries[entry_pt] = !selected_entries[entry_pt]
	if selected_entries[entry_pt]:
		button.text = SELECTED_BOX + entry_text.substr(SELECT_BOX_LENGTH)
		if entry_pt < 2:
			var alt: int = 1 - entry_pt
			selected_entries[alt] = false
			if menu_entries.list_start_pt == 0:
				var alt_button: Button = menu_entries.button_entries[alt]
				alt_button.text = UNSELECTED_BOX + alt_button.text.substr(SELECT_BOX_LENGTH)
	else:
		button.text = UNSELECTED_BOX + entry_text.substr(SELECT_BOX_LENGTH)
	refresh_selected()


func click_entry(button: Button) -> void:
	var entry_text = button.text
	if entry_text.is_empty():
		return
	if current_submenu_protein_select:
		click_protein_entry(button, entry_text)
		return
	click_parts_entry(button, entry_text)


func _on_selection_press(button: Button) -> void:
	match button.text:
		"Protein":
			if !current_submenu_protein_select:
				refresh_and_set_protein_state()
		"Parts":
			if current_submenu_protein_select:
				refresh_and_set_parts_state()
		_:
			print_debug("unknown button press entry text")


func set_element_list() -> void:
	var elements: Array[int]
	for protein in ProteinRegistry.selected_proteins:
		for ele in protein.elements:
			if ele in elements:
				continue
			elements.append(ele)
	var occurrence: Array[int]
	var list_entries: Array[String]
	var elements_size: int = elements.size()
	list_entries.resize(elements_size + 2)
	element_numbers.resize(elements_size)
	list_entries[0] = "[ ]backbone"
	list_entries[1] = "[ ]sidechains"
	occurrence.resize(elements_size)
	for protein in ProteinRegistry.selected_proteins:
		for i in range(elements_size):
			occurrence[i] += protein.elements.count(elements[i])
	var occ_copy: Array[int] = occurrence
	occurrence.sort()
	for i in range(elements_size):
		var index: int = occurrence.bsearch(occ_copy[i])
		while !list_entries[index + 2].is_empty():
			index += 1
		var ele: int = elements[i]
		element_numbers[index] = ele
		list_entries[index + 2] = UNSELECTED_BOX + EmpiricalConstants.ELEMENT_NAMES[ele]
	menu_entries.item_list = list_entries


func reset_selected_atoms() -> void:
	for protein in ProteinRegistry.selected_proteins:
		for i in range(protein.selected_atoms.size()):
			protein.selected_atoms[i] = false


func null_test(_atom_type: ProteinInfo.AtomType) -> bool:
	return true


func backbone_test(atom_type: ProteinInfo.AtomType) -> bool:
	return atom_type == ProteinInfo.AtomType.BACKBONE


func sidechain_test(atom_type: ProteinInfo.AtomType) -> bool:
	return atom_type == ProteinInfo.AtomType.SIDE_CHAIN


func set_selected_atoms(test_func: Callable) -> void:
	var no_elements: bool = true
	for i in range(2, selected_entries.size()):
		if !selected_entries[i]:
			continue
		no_elements = false
		for protein in ProteinRegistry.selected_proteins:
			for index in protein.element_lists[element_numbers[i - 2]]:
				protein.selected_atoms[index] = test_func.call(protein.atom_position_type[index])
	if no_elements:
		for protein in ProteinRegistry.selected_proteins:
			for index in range(protein.atom_position_type.size()):
				protein.selected_atoms[index] = test_func.call(protein.atom_position_type[index])


func refresh_selected() -> void:
	reset_selected_atoms()
	if !(selected_entries[0] || selected_entries[1]):
		set_selected_atoms(null_test)
	elif selected_entries[0]:
		set_selected_atoms(backbone_test)
	else:
		set_selected_atoms(sidechain_test)
