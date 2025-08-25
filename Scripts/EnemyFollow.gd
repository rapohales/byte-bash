extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D
@export var move_speed := 60
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("jogador")

func PhysicsUpdate(_delta: float):
	var direction = player.global_position - enemy.global_position
	if enemy.velocity.x > 0:
		enemy.get_node("AnimatedSprite2D").flip_h = false
	elif enemy.velocity.x < 0:
		enemy.get_node("AnimatedSprite2D").flip_h = true
	if direction.length() > 10:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2();
	if direction.length() > 200:
		transitioned.emit(self, "Dash")

func _on_special_chance_timeout() -> void:
	print("Aloo")
	if randi_range(0, 3) == 3:
		print("viado")
		transitioned.emit(self, "Special")
