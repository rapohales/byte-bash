extends CharacterBody2D
@export var speed = 200.0
@export var health_regen: float = 1.0
@export var health = 100
@export var max_health = 100
@onready var animation_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var sprite = $Sprite
var can_take_damage := true
var invulnerability_time := 1
@onready var stats_ui = get_node("/root/Mundo/Ui")
@onready var tela_morte = preload("res://Cenas/morte.tscn")

var dodge_speed = 400
var dodge_duration = 0.15
var dodge_cooldown = 10.0
@export var max_dodge_charges = 3
var dodge_charges: float = 3.0
var is_dodging = false
var dodge_recharge_timer = Timer.new()

@export var cena_espada : PackedScene
@export var cena_pistola : PackedScene

@onready var state_machine = anim_tree.get("parameters/playback")

var input_direction = null
var dekt = null
@export var start_direction : Vector2 = Vector2(0, 1)

func _ready() -> void:
	equipar_armas()
	add_child(dodge_recharge_timer)
	dodge_recharge_timer.wait_time = dodge_cooldown
	dodge_recharge_timer.timeout.connect(_replenish_dodge)
	update_animation(start_direction)
	$AudioStreamPlayer2D.process_mode = Node.PROCESS_MODE_ALWAYS

func _update_dodge_ui():
	stats_ui.update_dash_bar()
	
func _replenish_dodge():
	if dodge_charges < max_dodge_charges:
		dodge_charges += 1
		_update_dodge_ui()
		if dodge_charges < max_dodge_charges:
			dodge_recharge_timer.start()

func tomar_dano(dano):
	if not can_take_damage or is_dodging:
		return
	health -= dano
	update_all_health_bars_ui(health)
	flash()
	if health <=0:
		morrer()

func ganhar_vida(vida):
	health += vida
	update_all_health_bars_ui(health)

func update_all_health_bars_ui(health):
	stats_ui.update_health_bar(health)

func morrer():
	print("Morreu")
	get_tree().change_scene_to_file("res://Cenas/morte.tscn")
	self.queue_free()
	
func pegar_input():
	if is_dodging:
		return
		
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction.normalized() * speed
	
	if Input.is_action_just_pressed("dodge") and dodge_charges > 0 and not is_dodging:
		start_dodge()
func start_dodge():
	dodge_charges -= 1
	_update_dodge_ui()
	is_dodging = true
	can_take_damage = false
	if dodge_charges < max_dodge_charges and not dodge_recharge_timer.is_stopped():
		dodge_recharge_timer.start()
	if input_direction != Vector2.ZERO:
		velocity = input_direction.normalized() * dodge_speed
	else:
		velocity = Vector2.DOWN * dodge_speed
	sprite.scale = Vector2(0.8, 0.8)
	await get_tree().create_timer(dodge_duration).timeout
	is_dodging = false
	can_take_damage = true
	sprite.scale = Vector2(1, 1)
	velocity = input_direction.normalized() * speed

func _physics_process(_delta: float) -> void:
	pegar_input()
	move_and_slide() 
	update_animation(input_direction)
	estado_animacao()

func flash():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(2, 0.5, 0.5), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.3)

func update_animation(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		anim_tree.set("parameters/idle/blend_position", move_input)
		anim_tree.set("parameters/walk/blend_position", move_input)
		

		
func estado_animacao():
	if is_dodging:
		state_machine.travel("walk")
	elif(velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func _on_vul_timer_timeout() -> void:
	can_take_damage = true
func _on_health_regen_timeout() -> void:
	if health <= max_health:
		print("vida")
		ganhar_vida(health_regen)

func aumentar_vida():
	max_health += 5

func aumentar_velocidade():
	speed += 5

func equipar_armas():
	if cena_pistola:
		var pistola = cena_pistola.instantiate()
		pistola.wielder = self
		add_child(pistola)
		pistola.is_equipped = true
		
func _on_dodge_timer_timeout() -> void:
	if dodge_charges <= max_dodge_charges:
		_replenish_dodge()
