extends Control

var list_entries:PackedStringArray=["[ ]backbone","[ ]sidechains"]
var selected_entries:Array[bool]
var list_start_pt:int=0
var entry_texts:PackedStringArray

@onready var entry1:Button=$entry1
@onready var entry2:Button=$entry2
@onready var entry3:Button=$entry3
@onready var entry4:Button=$entry4
@onready var entry5:Button=$entry5
@onready var entry6:Button=$entry6
@onready var entry7:Button=$entry7
@onready var entry8:Button=$entry8
@onready var entry9:Button=$entry9

@onready var entries:Array[Button]=[entry1,entry2,entry3,entry4,entry5,entry6,entry7,entry8,entry9]

func _ready() -> void:
	entry_texts.resize(9)
	list_entries.append_array(get_element_list())
	selected_entries.resize(list_entries.size())
	refresh_entries()

func refresh_entries():
	var temp_list=list_entries.slice(list_start_pt,list_start_pt+9)
	for i in range(temp_list.size()):
		var entry_name:String=temp_list[i]
		var entry:Button=entries[i]
		entry_texts[i]=entry_name
		entry.text=entry_name
	for i in range(temp_list.size(),9):
		entries[i].text=""
		entry_texts[i]=""

func click_entry(num:int):
	var entry_text=entry_texts[num]
	if entry_text.is_empty():
		return
	var entry_pt:int=list_start_pt+num
	var enabled:bool=!selected_entries[entry_pt]
	selected_entries[entry_pt]=enabled
	if enabled:
		entry_text[1]="*"
		if entry_pt<2:
			var alt:int=1>>entry_pt
			selected_entries[alt]=false
			list_entries[alt][1]=" "#maybe make switch instead
			if list_start_pt==0:
				entries[alt].text[1]=" "
	else:entry_text[1]=" "
	entries[num].text=entry_text
	refresh_selected()

func str_to_atom_list(entry:String,protein:protein_info)->Array[int]:
	var index_list:Array[int]
	match entry.substr(3):
		"hydrogens":index_list=protein.hydrogens
		"carbons":index_list=protein.carbons
		"nitrogens":index_list=protein.nitrogens
		"oxygen":index_list=protein.oxygens
		"sulphur":index_list=protein.sulfurs
	return index_list

func refresh_selected():
	for protein in ProteinInfos.selected_proteins:
		for i in range(protein.selected_atoms.size()):protein.selected_atoms[i]=false
	var no_elements:bool=true
	if !(selected_entries[0]||selected_entries[1]):
		for i in range(2,selected_entries.size()):
			if !selected_entries[i]:continue
			no_elements=false
			for protein in ProteinInfos.selected_proteins:
				for index in str_to_atom_list(list_entries[i],protein):protein.selected_atoms[index]=true
		if no_elements:
			for protein in ProteinInfos.selected_proteins:
				for index in range(protein.atom_position_type.size()):protein.selected_atoms[index]=true
	elif selected_entries[0]:
		for i in range(2,selected_entries.size()):
			if !selected_entries[i]:continue
			no_elements=false
			for protein in ProteinInfos.selected_proteins:
				for index in str_to_atom_list(list_entries[i],protein):
					if protein.atom_position_type[index]!=0:continue
					protein.selected_atoms[index]=true
		if no_elements:
			for protein in ProteinInfos.selected_proteins:
				for index in range(protein.atom_position_type.size()):
					if protein.atom_position_type[index]!=0:continue
					protein.selected_atoms[index]=true
	else:
		for i in range(2,selected_entries.size()):
			if !selected_entries[i]:continue
			no_elements=false
			for protein in ProteinInfos.selected_proteins:
				for index in str_to_atom_list(list_entries[i],protein):
					if protein.atom_position_type[index]!=1:continue
					protein.selected_atoms[index]=true
		if no_elements:
			for protein in ProteinInfos.selected_proteins:
				for index in range(protein.atom_position_type.size()):
					if protein.atom_position_type[index]!=1:continue
					protein.selected_atoms[index]=true

func _on_entry1_pressed():click_entry(0)
func _on_entry2_pressed():click_entry(1)
func _on_entry3_pressed():click_entry(2)
func _on_entry4_pressed():click_entry(3)
func _on_entry5_pressed():click_entry(4)
func _on_entry6_pressed():click_entry(5)
func _on_entry7_pressed():click_entry(6)
func _on_entry8_pressed():click_entry(7)
func _on_entry9_pressed():click_entry(8)

func _on_list_up():
	if list_start_pt==0:return
	list_start_pt-=1
	refresh_entries()

func _on_list_down():
	list_start_pt+=1
	refresh_entries()

func get_element_list()->Array[String]:
	var elements:Array[int]
	for protein in ProteinInfos.selected_proteins:
		for ele in protein.elements:
			if ele in elements:continue
			elements.append(ele)
	var occurence:Array[int]
	var str_elements:Array[String]
	str_elements.resize(elements.size())
	occurence.resize(elements.size())
	for protein in ProteinInfos.selected_proteins:
		for i in range(elements.size()):occurence[i]+=protein.elements.count(elements[i])
	var occ_copy:Array[int]=occurence
	occurence.sort()
	for i in range(elements.size()):
		var index:int=occurence.bsearch(occ_copy[i],false)
		index-=1
		while str_elements[index]!="":index-=1
		str_elements[index]=ele_to_str[elements[i]]
	return str_elements

var ele_to_str:Dictionary={0:"[ ]hydrogens",6:"[ ]carbons",7:"[ ]nitrogens",8:"[ ]oxygen",16:"[ ]sulphur"}
