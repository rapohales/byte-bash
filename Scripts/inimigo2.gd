extends CharacterBody2D

@onready var area2d = $Hurtbox
var min_speed = 70
var max_speed = 100
@export var speed: int = randi() % ((max_speed) - (min_speed)) + (min_speed)
@onready var efeito = preload("res://Cenas/efeito.tscn")
@export var player: Node2D  
@export var max_health: int = 80
@export var health: int = 100
@export var dano: int = 10
@export var xp_amount = 30
@export var dano_dado: float = 1
var pode_causar_dano = true
var intervalo_de_dano = 0.5
@onready var cd = $Cooldown
var jogador = null
signal morreu;
var valor = 10
@onready var sprite = $AnimatedSprite2D
var current_frame := 0
var animation_speed = 0.2
var timer = 0.0

func _ready():
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	print(speed)

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		animate_run(delta, direction)

func animate_run(delta: float, direction: Vector2):
	timer += delta
	if velocity.length() > 0:
		sprite.flip_h = direction.x < 0
		if timer >= animation_speed:
			timer = 0.0
			current_frame = (current_frame + 1) % 4
			sprite.frame = current_frame
	else:
		sprite.frame = 0 

func tomarDano(_dano):
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
	emit_signal('morreu', valor)
	var xp = player.get_node("Xp2")
	xp.add_xp(20)
	queue_free()
	
func _on_questions_temp_dano_inimigo(_dano: Variant) -> void:
	print("dando o seguinte dano: %d", dano)
	health -= _dano
	tomarDano(_dano)
	$VidaDisplay.update_healthbar(health)

func _on_body_entered(body):
	if body.is_in_group("jogador"):
		jogador = body
		causar_dano()
		$Timer.start()

func _on_body_exited(body):
	if body == jogador:
		jogador = null
		$Timer.stop()

func causar_dano():
	if pode_causar_dano and jogador != null:
		if jogador.has_method("tomar_dano"):
			jogador.tomar_dano(dano_dado)
			pode_causar_dano = false
			cd.start()


func _on_cooldown_timeout() -> void:
	pode_causar_dano = true


func _on_timer_timeout() -> void:
	if jogador != null:
		causar_dano()
