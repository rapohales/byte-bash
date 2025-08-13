extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		abrir_menu()
	
func abrir_menu() -> void:
	print("lslaldsad")
	if $CanvasLayer.visible == false:
		get_tree().paused = true
		$CanvasLayer.visible = true
	else: 
		fechar_menu()
		

func fechar_menu():
	get_tree().paused = false
	$CanvasLayer.visible = false
