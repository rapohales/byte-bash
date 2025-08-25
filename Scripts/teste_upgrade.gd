extends Button

var upgrade_tab_scene = preload("res://Cenas/upgrade_tab.tscn")



func show_upgrade_tab():
	var upgrade_tab_obj = upgrade_tab_scene.instantiate()
	add_child(upgrade_tab_obj)

func _on_pressed() -> void:
	show_upgrade_tab()
