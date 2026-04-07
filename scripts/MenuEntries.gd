class_name MenuEntries

var button_entries: Array[Button]
var item_list: PackedStringArray
var number_entries: int
var list_start_pt: int = 0


func _init(root: Node, _on_entry_pressed: Callable, start_point: int, num_entries: int) -> void:
	number_entries = num_entries
	button_entries.resize(number_entries)
	for i in range(number_entries):
		var button_entry: Button = root.get_child(start_point + i)
		button_entries[i] = button_entry
		button_entry.connect("pressed", _on_entry_pressed, CONNECT_APPEND_SOURCE_OBJECT)
	root.get_child(start_point - 2).connect("pressed", _on_list_up) #should be the up button
	root.get_child(start_point - 1).connect("pressed", _on_list_down) #should be the down button


func refresh_entries() -> void:
	var temp_list: PackedStringArray = item_list.slice(list_start_pt, list_start_pt + number_entries)
	var temp_size: int = temp_list.size()
	for i in range(temp_size):
		button_entries[i].text = temp_list[i]
	for i in range(temp_size, number_entries):
		button_entries[i].text = ""


func _on_list_up() -> void:
	if list_start_pt == 0:
		return
	list_start_pt -= 1
	refresh_entries()


func _on_list_down() -> void:
	if list_start_pt + number_entries >= item_list.size():
		return
	list_start_pt += 1
	refresh_entries()


static func disable_menu(menu: Node):
	menu.visible = false
	menu.process_mode = Node.PROCESS_MODE_DISABLED


static func enable_menu(menu: Node):
	menu.visible = true
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	if menu.has_method("activate_menu"):
		menu.call("activate_menu")
