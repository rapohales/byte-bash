extends Node

@export var vulnerabilidade_ativa: float = 1.0

var seguranca_att: float = 0.0
var perguntas: PerguntasCadastradas = preload("res://Resources/todas_perguntas.tres")

func comecarMusica():
	$AudioStreamPlayer2D.playing = true
func att_vulnerabilidade(seguranca):
	seguranca_att = seguranca 
	var _vulnerabilidade_atual = vulnerabilidade_ativa - seguranca_att
	
func vul_por_nivel(nivel):
	vulnerabilidade_ativa = ((nivel / 0.7) + vulnerabilidade_ativa - (vulnerabilidade_ativa * 0.2))
pass
func evento_ocorre():
	EventBus.evento_ocorreu()

func _ready() -> void:
	randomize()

func _on_button_pressed() -> void:
	pass # Replace with function body.
