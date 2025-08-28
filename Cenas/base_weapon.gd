extends Node2D

@export var is_auto_locked: bool
@export var is_equipped: bool
@export var range: float = 400
@export var fire_rate: float = 1.0
@export var damage: float = 0.0
@export var projectile_scene: PackedScene

var wielder: Node2D = null

@onready var targetting_area = $TargetingArea/CollisionShape2D
@onready var shoot_timer = $ShootTimer

func _ready() -> void:
	targetting_area.shape.radius = range
	shoot_timer.wait_time = 1.0 / fire_rate

func _on_shoot_timer_timeout() -> void:	
	var target = find_nearest_enemy_in_range()
	print(target)
	if target and is_equipped:
		shoot_at_target(target)
	
func find_nearest_enemy_in_range() -> Node2D:
	var nearest_enemy: Node2D = null
	var min_distance = INF
	
	var enemies_in_range = $TargetingArea.get_overlapping_bodies() + $TargetingArea.get_overlapping_areas()
	if enemies_in_range.is_empty():
		return null
				
	for enemy in enemies_in_range:
		
		var distance = wielder.global_position.distance_to(enemy.global_position)
		if distance < min_distance:
			nearest_enemy = enemy
			min_distance = distance
		
	return nearest_enemy
	
func shoot_at_target(target: Node2D):
	if not projectile_scene: return
	var projectile = projectile_scene.instantiate()
	
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = $Origin.global_position
	projectile.look_at(target.global_position)
	
