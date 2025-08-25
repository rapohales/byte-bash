extends Node2D

@onready var hitbox = $HitboxRange/CollisionShape2D
@export var xp_amount = 1
@onready var player_node = get_tree().get_first_node_in_group("jogador")

var collection_distance = 3
var homing_speed = 200
var is_gathered = false
var gathering = false		
		
func adicionarXP():
	player_node.get_node("Xp2").add_xp(xp_amount)
	queue_free()

func _physics_process(delta: float) -> void:
	if not gathering or not is_instance_valid(player_node):
		return
	
	var direction = global_position.direction_to(player_node.global_position)
	global_position += direction * homing_speed * delta
	print(direction)
	if global_position.distance_to(player_node.global_position) < collection_distance:
		adicionarXP()
	

func _on_hitbox_range_body_entered(body: Node2D) -> void:
	if gathering or not body.is_in_group("jogador"):
		return
	gathering = true
	player_node = body
	
	
