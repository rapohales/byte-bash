extends CanvasLayer

@export var perguntas: Array[Pergunta] = []

@onready var op1: TextureButton = $Button
@onready var op2: TextureButton = $Button2

signal onbotao1down(moedas, segurança, mult)
signal onbotao2down(moedas, segurança, mult)

var is_open: bool = false

@onready var key1 = $TextureButton
@onready var key2 = $TextureButton2
@onready var box = $HBoxContainer
@onready var boxText = $Label
@onready var sprite = $Sprite2D
@onready var but1 = $Button
@onready var but2 = $Button2
@onready var text1 = $Button/Label
@onready var text2 = $Button2/Label
@onready var colRect = $ColorRect
@onready var limitprogressBar = $LimitTimeBar

@onready var right_ans = preload("res://Sons de Hits/good.wav")
@onready var wrong_ans = preload("res://Sons de Hits/hurt.wav")

var ativo = false
var pergunta_escolhida 
var pergunta_selecionada

@onready var efeito_recompensa = preload("res://Cenas/efeito.tscn") 

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	print(perguntas[0].texto)
	EventBus.event_triggered.connect(_on_event)

func choose_questions_rand():
	pergunta_escolhida = randi() % perguntas.size()
	pergunta_selecionada = perguntas[pergunta_escolhida]
	boxText.text = pergunta_selecionada.texto
	text1.text = pergunta_selecionada.respostas[0]
	text2.text = pergunta_selecionada.respostas[1]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("botao2") and ativo == true:
		_on_button_button_down()
		
	if event.is_action_pressed("botao1") and ativo == true:
		_on_button_2_button_down()

func more_opacity():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(Engine, "time_scale", 0.1, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(box, "modulate:a", 1.0, 0.3)
	tween.tween_property(boxText, "modulate:a", 1.0, 0.3)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.3)
	tween.tween_property(but1, "modulate:a", 1.0, 0.3)
	tween.tween_property(but2, "modulate:a", 1.0, 0.3)
	tween.tween_property(key1, "modulate:a", 1.0, 0.3)
	tween.tween_property(key2, "modulate:a", 1.0, 0.3)
	tween.tween_property(limitprogressBar, "modulate:a", 1.0, 0.3)
	tween.tween_property(colRect, "modulate:a", 1.0, 0.3)
	tween.finished.connect(setAtivo)
	ativo = true


func setAtivo():
	get_tree().paused = true
	descerProgressBar()

func descerProgressBar():
	$Limit.start()
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.tween_property(limitprogressBar, "value", 100, $Limit.wait_time * 0.1)



func reset():
	visible = true
	limitprogressBar.value = 0
	$Limit.stop()
	but1.get_node("AnimatedSprite2D2").visible = false
	but1.get_node("AnimatedSprite2D").visible = false
	but2.get_node("AnimatedSprite2D2").visible = false
	but2.get_node("AnimatedSprite2D").visible = false

func less_opacity():
	get_tree().paused = false
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(Engine, "time_scale", 1, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(box, "modulate:a", 0.0, 0.5)
	tween.tween_property(boxText, "modulate:a", 0.0, 0.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.tween_property(but1, "modulate:a", 0.0, 0.5)
	tween.tween_property(but2, "modulate:a", 0.0, 0.5)
	tween.tween_property(key1, "modulate:a", 0.0, 0.5)
	tween.tween_property(key2, "modulate:a", 0.0, 0.5)
	tween.tween_property(colRect, "modulate:a", 0.0, 0.5)
	tween.tween_property(limitprogressBar, "modulate:a", 0.0, 0.5)
	tween.tween_property(self, "visible", false, 0.9)
	tween.tween_property(self, "ativo", false, 1.5)
	
func _on_event(event_name: String, _data: Variant):
	if event_name == "emitir_ui" and _data.contains("Chest") and ativo == false:
		reset()
		choose_questions_rand()
		more_opacity()
		get_canvas()

func _on_button_button_down() -> void:
	if ativo == true and get_tree().paused == true:
		onbotao1down.emit(pergunta_selecionada.r1_dinheiro, pergunta_selecionada.r1_seguranca, pergunta_selecionada.r1_mult)
		var efeito_clicou = efeito_recompensa.instantiate()
		efeito_clicou.text1 = "Dinheiro: %d" % pergunta_selecionada.r1_dinheiro
		efeito_clicou.text2 = "Seguranca: %d" % pergunta_selecionada.r1_seguranca
		efeito_clicou.text3 = "Multiplicador %d" % pergunta_selecionada.r1_mult
		efeito_clicou.position = but1.position + Vector2(60, -40)
		add_child(efeito_clicou)
		if pergunta_selecionada.certo1 == true:
			$SomAcerto.play()
			but1.get_node("AnimatedSprite2D").visible = true
			but1.get_node("AnimatedSprite2D").play("right")
			but1.get_node("CPUParticles2D").color = "00ff00"
			but1.get_node("CPUParticles2D").emitting = true
		else:
			$SomErro.play()
			but1.get_node("AnimatedSprite2D2").visible = true
			but1.get_node("AnimatedSprite2D2").play("wrong")
			but1.get_node("CPUParticles2D").color = "ff0000"
			but1.get_node("CPUParticles2D").emitting = true
		less_opacity()
func _on_button_2_button_down() -> void:
	if ativo == true and get_tree().paused == true:
		onbotao2down.emit(pergunta_selecionada.r2_dinheiro, pergunta_selecionada.r2_seguranca, pergunta_selecionada.r2_mult)
		var efeito_clicou = efeito_recompensa.instantiate()
		efeito_clicou.text1 = "Dinheiro: %d" % pergunta_selecionada.r2_dinheiro
		efeito_clicou.text2 = "Seguranca: %d" % pergunta_selecionada.r2_seguranca
		efeito_clicou.text3 = "Multiplicador %d" % pergunta_selecionada.r2_mult
		efeito_clicou.position = but2.position + Vector2(60, -40)
		add_child(efeito_clicou)
		if pergunta_selecionada.certo2 == true:
			$SomAcerto.play()
			but2.get_node("AnimatedSprite2D").visible = true
			but2.get_node("AnimatedSprite2D").play("right")
			but2.get_node("CPUParticles2D").color = "00ff00"
			but2.get_node("CPUParticles2D").emitting = true
		else:
			$SomErro.play()
			but2.get_node("AnimatedSprite2D2").visible = true
			but2.get_node("AnimatedSprite2D2").play("wrong")
			but2.get_node("CPUParticles2D").color = "ff0000"
			but2.get_node("CPUParticles2D").emitting = true
			pass
		less_opacity()

func _on_limit_timeout() -> void:
	less_opacity()
