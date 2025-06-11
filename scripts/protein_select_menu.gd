extends Control

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

var list_start_pt:int=0
var list_entries:PackedStringArray
var entry_texts:PackedStringArray

func _ready():
	entry_texts.resize(9)
	refresh_entries()

func refresh_entries():
	var temp_list=ProteinInfos.protein_names.slice(list_start_pt,list_start_pt+9)
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
	var pt:int=ProteinInfos.protein_names.find(entry_text)
	ProteinInfos.selected_protein=ProteinInfos.proteins[pt]


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
