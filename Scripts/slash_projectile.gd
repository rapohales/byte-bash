extends Area2D

@export var speed = 100
@export var lifetime: float = 1.5

var direction = Vector2.RIGHT  
func _physics_process(delta):
	position += direction * speed * delta

func _on_visibility_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area) -> void:
	var player = get_tree().get_first_node_in_group("player")
	var espada = player.get_node("Espada")
	var dano = espada.damage
	if area.is_in_group("enemies"):
		area.tomarDano(dano)
	else:
		return

func _on_body_entered(body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player")
	var espada = player.get_node("Espada")
	var dano = espada.damage
	if body.is_in_group("bosses"):
		body.tomarDano(dano)
	else:
		return
