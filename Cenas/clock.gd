extends CanvasLayer

var total_seconds = 0

func _ready():
	$Timer.start()

func _on_timer_timeout() -> void:
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	total_seconds += 1
	$Label.text = "%02d:%02d" % [minutes, seconds]
