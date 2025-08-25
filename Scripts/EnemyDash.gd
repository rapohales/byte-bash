extends State
class_name EnemyDash

@export var enemy: CharacterBody2D
@export var move_speed = 10
@export var dash_range = 990
@export var dash_speed = 500
@export var dash_duration = 1.0

var dash_target_pos: Vector2 = Vector2.ZERO
var move_direction: Vector2
var player: CharacterBody2D

func dash_movement():
	if enemy:
		var animated_sprite = enemy.get_node("AnimatedSprite2D")
		dash_target_pos = player.global_position
		animated_sprite.play("dash")
		var tween = create_tween()
		tween.tween_property(enemy, "global_position", dash_target_pos, dash_duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(finish_dash)


func finish_dash():
	transitioned.emit(self, "Follow")

func Enter():
	player = get_tree().get_first_node_in_group("jogador")
	dash_movement()

func PhysicsUpdate(_delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
	var direction = player.global_position - enemy.global_position
	if direction.length() < 200:
		transitioned.emit(self, "Follow")
