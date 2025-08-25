extends Node

@export var enemy_scene: PackedScene
@export var max_enemies := 10
@export var spawn_interval := 3.0
@export var spawn_margin := 2  # Margem fora da tela

var enemies_alive := 0
var spawn_timer := 0.0
var camera: Camera2D

func _ready():
	camera = get_viewport().get_camera_2d()
	if not camera:
		push_warning("Nenhuma câmera encontrada para o spawner de inimigos")

func _process(delta):
	if enemies_alive < max_enemies and camera:
		
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			print("oi")
			spawn_timer = 0.0
			spawn_enemy()
	else:
		print("nao achouSS")

func spawn_enemy():
	if not enemy_scene or not camera:
		print("nao achousa")
		return
	
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemies_alive += 1
	enemy.tree_exiting.connect(_on_enemy_died)
	
	# Define a posição fora da visão da câmera
	enemy.global_position = get_spawn_position_outside_camera()
	print(enemy.global_position)

func get_spawn_position_outside_camera() -> Vector2:
	var viewport_rect = camera.get_viewport_rect()
	var camera_rect = Rect2(
		camera.get_screen_center_position() - viewport_rect.size * 0.5,
		viewport_rect.size
	)
	var spawn_rect = camera_rect.grow(spawn_margin)
	var side = randi() % 2
	var spawn_pos = Vector2.ZERO
	
	match side:
		0: # Topo
			spawn_pos = Vector2(
				randf_range(spawn_rect.position.x, spawn_rect.end.x),
				spawn_rect.position.y - randf_range(10, spawn_margin)
			)
		1: # Direita
			spawn_pos = Vector2(
				spawn_rect.end.x + randf_range(10, spawn_margin),
				randf_range(spawn_rect.position.y, spawn_rect.end.y)
			)
		2: # Base
			spawn_pos = Vector2(
				randf_range(spawn_rect.position.x, spawn_rect.end.x),
				spawn_rect.end.y + randf_range(10, spawn_margin)
			)
		3: # Esquerda
			spawn_pos = Vector2(
				spawn_rect.position.x - randf_range(10, spawn_margin),
				randf_range(spawn_rect.position.y, spawn_rect.end.y)
			)
	
	return spawn_pos

func _on_enemy_died():
	enemies_alive -= 1
