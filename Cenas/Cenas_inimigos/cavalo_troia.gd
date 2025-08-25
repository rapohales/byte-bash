extends CharacterBody2D

@export var health = 1000
@export var dano = 2
var pode_causar_dano = true
@export var dano_dado: float = 1
@onready var cd = $Cooldown
@onready var efeito = preload("res://Cenas/efeito.tscn")
@onready var player = get_tree().get_first_node_in_group("jogador")

func _physics_process(delta: float) -> void:
	move_and_slide()

func tomarDano(_dano):
	print("tomou")
	health -= _dano
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(2, 0.5, 0.5), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.3)
	var efeito_dano = efeito.instantiate()
	efeito_dano.text1 = "%d" % _dano
	efeito_dano.position = $AnimatedSprite2D.position
	add_child(efeito_dano)
	
	if health <= 0:
		morrer()
func morrer():
	call_deferred("queue_free")

func causar_dano():
	if pode_causar_dano and player != null:
		if player.has_method("tomar_dano"):
			player.tomar_dano(dano_dado)
			pode_causar_dano = false
			cd.start()

func _on_cooldown_timeout() -> void:
	pode_causar_dano = true


func _on_timer_timeout() -> void:
	if player != null:
		causar_dano()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		player = body
		causar_dano()
		$Timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		$Timer.stop()
