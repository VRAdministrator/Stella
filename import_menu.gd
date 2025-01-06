extends Control

@onready var full_path:Label=$full_path

@onready var entry1:Button=$entry1
@onready var entry2:Button=$entry2
@onready var entry3:Button=$entry3
@onready var entry4:Button=$entry4
@onready var entry5:Button=$entry5
@onready var entry6:Button=$entry6
@onready var entry7:Button=$entry7
@onready var entry8:Button=$entry8

@onready var entries:Array[Button]=[entry1,entry2,entry3,entry4,entry5,entry6,entry7,entry8]

var entry_texts:PackedStringArray
var cwd:String
var dir_start_pt:int=0

func _ready() -> void:
	entry_texts.resize(8)
	cwd=OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).get_base_dir()
	refresh_dir()

func add_protein(path:String):
	var protein:protein_info=protein_info.new()
	protein.file_path=path
	ProteinInfos.proteins.append(protein)

func refresh_dir():
	full_path.text=cwd
	var dir_list=DirAccess.get_directories_at(cwd)
	dir_list.append_array(DirAccess.get_files_at(cwd))
	var temp_list=dir_list.slice(dir_start_pt,dir_start_pt+8)
	for i in range(temp_list.size()):
		var entry_name:String=temp_list[i]
		var entry:Button=entries[i]
		entry_texts[i]=entry_name
		entry.text=entry_name
	for i in range(temp_list.size(),8):
		entries[i].text=""
		entry_texts[i]=""

func click_entry(num:int):
	var entry_text=entry_texts[num]
	if entry_text.is_empty():
		return
	#if repeat_delay<repeat_limit:
		#repeat_delay=0
		#return
	#repeat_delay=0
	var temp_cwd=cwd.path_join(entry_text)
	if FileAccess.file_exists(temp_cwd):
		if !entry_text.ends_with(".pdb"):
			return
		add_protein(temp_cwd)
		return
	cwd=temp_cwd
	dir_start_pt=0
	refresh_dir()

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
	refresh_dir()

func _on_dir_down():
	dir_start_pt+=1
	refresh_dir()

func _on_dir_back():
	cwd=cwd.get_base_dir()
	dir_start_pt=0
	refresh_dir()
