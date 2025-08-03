extends Control

@onready var sub_viewport = $SubViewport
@onready var camera = $SubViewport/Camera2D
@onready var map_instance = $SubViewport/Mundo

func _ready():
	setup_camera()
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
func setup_camera():
	# Define onde a câmera deve focar (coordenadas do mundo)
	var focus_position = Vector2(159.0, 49.0)  # Ajuste conforme necessário
	camera.global_position = focus_position
	
	# Define o zoom da câmera
	camera.zoom = Vector2(5.0, 5.0)  # Ajuste conforme necessário
	
func load_map():
	if map_instance:
		map_instance.queue_free()
	var map_scene = preload("res://Cenas/Camera_menu.tscn")  # Ajuste o caminho
	map_instance = map_scene.instantiate()
	
	# Adiciona ao SubViewport
	sub_viewport.add_child(map_instance)
	
	# Remove elementos desnecessários para a prévia (como HUD, controles do jogador, etc.)
	cleanup_map_for_preview()

func cleanup_map_for_preview():
	
	var ui = map_instance.get_node_or_null("UI")
	if ui:
		ui.queue_free()
