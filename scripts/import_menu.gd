extends Control

@onready var full_path:Label=$full_path

var button_entries:Array[Button]
var dir_list:PackedStringArray
var cwd:String
var dir_start_pt:int=0

const START_ENTRY_POINT:int=4
const NUMBER_ENTRIES:int=8

func _ready() -> void:
	button_entries.resize(NUMBER_ENTRIES)
	for i in range(NUMBER_ENTRIES):
		button_entries[i]=get_child(START_ENTRY_POINT+i)
	cwd=OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).get_base_dir()
	refresh_dir()
	refresh_entries()

func refresh_entries():
	var temp_list=dir_list.slice(dir_start_pt,dir_start_pt+8)
	for i in range(temp_list.size()):
		var entry_name:String=temp_list[i]
		var button_entry:Button=button_entries[i]
		button_entry.text=entry_name
	for i in range(temp_list.size(),8):
		button_entries[i].text=""

func refresh_dir():
	full_path.text=cwd
	dir_list=DirAccess.get_directories_at(cwd)
	dir_list.append_array(DirAccess.get_files_at(cwd))

func click_entry(num:int):
	var entry_text=button_entries[num].text
	if entry_text.is_empty():
		return
	var temp_cwd=cwd.path_join(entry_text)
	if FileAccess.file_exists(temp_cwd):
		if !entry_text.ends_with(".pdb"):
			return
		ProteinRegistry.load_protien(temp_cwd,entry_text)
		return
	cwd=temp_cwd
	dir_start_pt=0
	refresh_dir()
	refresh_entries()

func _on_entry1_pressed():click_entry(0)
func _on_entry2_pressed():click_entry(1)
func _on_entry3_pressed():click_entry(2)
func _on_entry4_pressed():click_entry(3)
func _on_entry5_pressed():click_entry(4)
func _on_entry6_pressed():click_entry(5)
func _on_entry7_pressed():click_entry(6)
func _on_entry8_pressed():click_entry(7)

func _on_dir_up():
	if dir_start_pt==0:return
	dir_start_pt-=1
	refresh_entries()

func _on_dir_down():
	if dir_start_pt+NUMBER_ENTRIES>=len(dir_list):
		return
	dir_start_pt+=1
	refresh_entries()

func _on_dir_back():
	cwd=cwd.get_base_dir()
	dir_start_pt=0
	refresh_dir()
	refresh_entries()
