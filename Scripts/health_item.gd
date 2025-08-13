extends Area2D
var vida = 20

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		body.ganhar_vida(vida)
		queue_free()
		pass
