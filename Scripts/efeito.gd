extends Node2D

@export var text1: String = ""
@export var text2: String = ""
@export var text3: String = ""
@export var rise_speed: float = 50.0
@export var fade_speed: float = 1.0
@export var lifetime: float = 1.5

func _ready():
	
	$Label.text = text1
	$Label2.text = text2
	$Label3.text = text3
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 50, lifetime)
	tween.tween_property($Label, "modulate:a", 0.0, lifetime)
	tween.tween_property($Label2, "modulate:a", 0.0, lifetime)
	tween.tween_property($Label3, "modulate:a", 0.0, lifetime)
	tween.chain().tween_callback(queue_free)
