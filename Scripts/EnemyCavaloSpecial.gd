extends State
class_name EnemyCavaloSpecial

var spawn_marker = preload("res://Cenas/Cenas_inimigos/CavaloSpawn.tscn")

@export var enemy: CharacterBody2D
var special_duration: Timer
@export var time_in_sec_special = 10

var dash_target_pos: Vector2 = Vector2.ZERO
var move_direction: Vector2
var player: CharacterBody2D

func stop():
	if enemy:
		var animated_sprite = enemy.get_node("AnimatedSprite2D")
		animated_sprite.play("special")
		enemy.velocity = Vector2.ZERO
		spawn_enemies()
		
func spawn_enemies():
	var spawn_obj = spawn_marker.instantiate()
	spawn_obj.global_position = enemy.global_position
	get_parent().add_child(spawn_obj)
	
func finish():
	transitioned.emit(self, "Follow")

func Enter():
	special_duration = enemy.get_node("SpecialDuration")
	special_duration.start(time_in_sec_special)
	player = get_tree().get_first_node_in_group("jogador")
	stop()

func _on_special_duration_timeout() -> void:
	finish()
