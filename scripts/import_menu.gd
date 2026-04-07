extends Control

const START_ENTRY_POINT: int = 4
const NUMBER_ENTRIES: int = 9

@onready var full_path: Label = $full_path
@onready var menu_entries: MenuEntries = MenuEntries.new(self, click_entry, START_ENTRY_POINT, NUMBER_ENTRIES)

var cwd: String


func _ready() -> void:
	cwd = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).get_base_dir()
	refresh_dir()
	menu_entries.refresh_entries()


func refresh_dir() -> void:
	full_path.text = cwd
	menu_entries.item_list = DirAccess.get_directories_at(cwd) + DirAccess.get_files_at(cwd)


func click_entry(button: Button) -> void:
	var entry_text = button.text
	if entry_text.is_empty():
		return
	var temp_cwd = cwd.path_join(entry_text)
	if FileAccess.file_exists(temp_cwd):
		if !entry_text.ends_with(".pdb"):
			return
		ProteinRegistry.load_protien(temp_cwd, entry_text)
		return
	cwd = temp_cwd
	refresh_dir()
	menu_entries.list_start_pt = 0
	menu_entries.refresh_entries()


func _on_dir_back() -> void:
	cwd = cwd.get_base_dir()
	menu_entries.list_start_pt = 0
	refresh_dir()
	menu_entries.refresh_entries()
