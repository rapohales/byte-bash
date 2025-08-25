extends Marker2D

@export var enemy_scenes: Array[PackedScene] = []
@export var max_enemies := 1500
@export var min_delay = 1
@export var max_delay = 2
var spawn_delay: float = randf_range(max_delay, min_delay)
@export var spawn_radius: float = 10.0

var bar_red = preload("res://Assets/Vida_bar/healthbar4.png")
var bar_blue = preload("res://Assets/Vida_bar/healthbar1.png")
var bar_yellow = preload("res://Assets/Vida_bar/healthbar2.png")

var _timer := 0.0

func _ready():
	if enemy_scenes.is_empty():
		load_default_enemies()

func _process(delta):
	if enemy_scenes.is_empty():
		return
	
	_timer += delta
	if _timer >= spawn_delay and get_child_count() < max_enemies:
		_timer = 0.0
		spawn_random_enemy()

func load_default_enemies():
	var default_enemies = [
		"res://Cenas/inimigo.tscn",
		"res://Cenas/inimigo2.tscn",
		"res://Cenas/inimigo3.tscn"
	]
	
	for path in default_enemies:
		var enemy = load(path)
		if enemy:
			enemy_scenes.append(enemy)

func spawn_random_enemy():
	var selected_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var new_enemy = selected_scene.instantiate()
	var main_node = get_tree().root.get_node("Mundo")  
	main_node.add_child(new_enemy)
	var spawn_pos = global_position
	if spawn_radius > 0:
		var angle = randf() * TAU
		spawn_pos += Vector2(cos(angle), sin(angle)) * randf() * spawn_radius
		new_enemy.global_position = spawn_pos
		setup_enemy_healthbar(new_enemy)


func setup_enemy_healthbar(enemy):
	if enemy.has_node("HealthBar"):
		var healthbar = enemy.get_node("HealthBar")
		if enemy.has_signal("health_changed"):
			enemy.connect("health_changed", Callable(self, "_on_enemy_health_changed").bind(healthbar))
		if enemy.has_method("get_max_health"):
			healthbar.max_value = enemy.get_max_health()
			healthbar.value = healthbar.max_value
			healthbar.texture_progress = bar_blue
		add_healthbar_script(healthbar)

func add_healthbar_script(healthbar):
	healthbar.set_script(preload("res://Scripts/vida_display.gd"))
	healthbar.bar_red = bar_red
	healthbar.bar_blue = bar_blue
	healthbar.bar_yellow = bar_yellow

func _on_enemy_health_changed(new_health, healthbar):
	healthbar.value = new_health
	
	if new_health < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	elif new_health < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	else:
		healthbar.texture_progress = bar_blue
