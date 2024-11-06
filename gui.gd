extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
@onready var full_path:Label3D=$full_path

@onready var text_entry1:Label3D=$entry1
@onready var text_entry2:Label3D=$entry2
@onready var text_entry3:Label3D=$entry3
@onready var text_entry4:Label3D=$entry4
@onready var text_entry5:Label3D=$entry5
@onready var text_entry6:Label3D=$entry6
@onready var text_entry7:Label3D=$entry7
@onready var text_entry8:Label3D=$entry8

@onready var text_entries:Array[Label3D]=[text_entry1,text_entry2,text_entry3,text_entry4,text_entry5,text_entry6,text_entry7,text_entry8]
@onready var entry_texts:PackedStringArray
var cwd:String
var dir_start_pt:int=0

func _ready() -> void:
	entry_texts.resize(8)
	cwd=OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).get_base_dir()
	refresh_dir()

var repeat_delay:float=0
const repeat_limit:float=0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	repeat_delay+=delta

func refresh_dir():
	full_path.text=cwd
	var dir_list=DirAccess.get_directories_at(cwd)
	dir_list.append_array(DirAccess.get_files_at(cwd))
	var temp_list=dir_list.slice(dir_start_pt,dir_start_pt+8)
	for i in range(temp_list.size()):
		var name:String=temp_list[i]
		var text_entry:Label3D=text_entries[i]
		entry_texts[i]=name
		text_entry.text=name
	for i in range(temp_list.size(),8):
		text_entries[i].text=""
		entry_texts[i]=""

signal load_protein(path:String)

func click_entry(num:int):
	var entry_text=entry_texts[num]
	if entry_text.is_empty():
		return
	if repeat_delay<repeat_limit:
		repeat_delay=0
		return
	repeat_delay=0
	var temp_cwd=cwd.path_join(entry_text)
	if FileAccess.file_exists(temp_cwd):
		if !entry_text.ends_with(".pdb"):
			return
		load_protein.emit(temp_cwd)
		return
	cwd=temp_cwd
	dir_start_pt=0
	refresh_dir()

func _on_entry1_exited(_none)->void:click_entry(0)
func _on_entry2_exited(_none)->void:click_entry(1)
func _on_entry3_exited(_none)->void:click_entry(2)
func _on_entry4_exited(_none)->void:click_entry(3)
func _on_entry5_exited(_none)->void:click_entry(4)
func _on_entry6_exited(_none)->void:click_entry(5)
func _on_entry7_exited(_none)->void:click_entry(6)
func _on_entry8_exited(_none)->void:click_entry(7)

func _on_dir_up(_none):
	if dir_start_pt==0:return
	dir_start_pt-=1
	refresh_dir()

func _on_dir_down(_none):
	dir_start_pt+=1
	refresh_dir()

func _on_dir_back(_none):
	cwd=cwd.get_base_dir()
	dir_start_pt=0
	refresh_dir()
