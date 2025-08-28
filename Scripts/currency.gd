extends Node
signal evento_ocorreu
signal get_seguranca(seg)

@export var moedas: float = 0
@export var seguranca: int = 0
@export var mult: float = 1.00
@onready var UI_node = $"../Ui"

func _ready() -> void:
	EventBus.get_mult.connect(pegar_mult)
	EventBus.get_seg.connect(pegar_seguranca)
	EventBus.get_din.connect(pegar_dinheiro)
	
func pegar_mult():
	return mult
func pegar_seguranca():
	return seguranca
func pegar_dinheiro():
	return moedas

func _on_coin_timer_timeout() -> void:
	moedas += 1 * mult;
	UI_node.update_score_display(moedas, seguranca, mult)

func update_score_ui(score, _seguranca, _mult):
	EventBus.atualizar_score(score, _seguranca, _mult)

func _on_questions_onbotao_1_down(_moedas: Variant, _seguranca: Variant, _mult) -> void:
	moedas += _moedas
	seguranca += _seguranca
	mult += _mult 
	update_score_ui(_moedas, _seguranca, mult)
	Main.att_vulnerabilidade(seguranca)
func _on_questions_onbotao_2_down(_moedas: Variant, _seguranca: Variant, _mult) -> void:
	moedas += _moedas
	seguranca += _seguranca
	mult += _mult 
	update_score_ui(_moedas, _seguranca, mult)
	Main.att_vulnerabilidade(seguranca)
	

func chance_event_happen():
	if randf_range(0, 100) <= Main.vulnerabilidade_ativa * 0.1:
		evento_ocorreu.emit()
		Main.evento_ocorre()
		var tween = create_tween()
		tween.tween_property(Engine, "time_scale", 0.2, 0.7).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Engine, "time_scale", 1.0, 1.0)
		print("passou ein", Main.vulnerabilidade_ativa * 0.1)
	pass

func _on_chance_event_timeout() -> void:
	print("done")
	chance_event_happen()
