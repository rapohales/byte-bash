extends Control

@onready var map_preview = $MapPreview
@onready var preview_texture_rect = $TextureRect

func _ready() -> void:
	var viewport_texture = map_preview.sub_viewport.get_texture()
	preview_texture_rect.texture = viewport_texture
	var tween = create_tween()
	tween.tween_property($ColorRect2/Label, "modulate:a", 1.0, 2.5).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect2/Label, "modulate:a", 0.0, 2.5).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect2/Label2, "modulate:a", 1.0, 2.5).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect2/Label2, "modulate:a", 0.0, 2.5).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect2/Label3, "modulate:a", 1.0, 2.5).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect2/Label3, "modulate:a", 0.0, 2.5).set_ease(Tween.EASE_IN)
	tween.tween_property($ColorRect2, "visible", false, 1.0).set_ease(Tween.EASE_IN)
	tween.tween_property($AudioStreamPlayer2D, "playing", true, 0.0)
		
func _on_bot_play_pressed() -> void:
	var transition = get_tree().create_tween()
	transition.tween_property(self, "modulate:a", 0, 0.5)
	await transition.finished
	$AudioStreamPlayer2D.stop()
	get_tree().change_scene_to_file("res://Cenas/Mundo.tscn")
func _on_bot_opcoes_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/menu_opcoes.tscn")	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("passar_cutscene"):
		var tween = create_tween()
		tween.tween_property($ColorRect2, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_IN)
		tween.tween_property($ColorRect2, "visible", false, 1.0).set_ease(Tween.EASE_IN)
func _on_bot_exit_pressed() -> void:
	get_tree().quit()
