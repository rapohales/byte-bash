extends Node

signal event_triggered(event_name: String, data: Variant)
signal atualizar_score_eventbus(score: int, seguranca: int)
signal atualizar_score_out(score: int, seguranca: int)
signal atualizar_ui_progressbar(cur_xp, cur_lvl)
signal darDanoPlayer(dano, nomeSinal)
signal acontecer_evento()
signal atualizar_ui_reset_progressbar(cur_xp, next_level)
signal atualizar_esquivas(current_charges, max_charges)
signal get_mult(cur_mult)
signal get_seg(cur_seg)
signal get_din(cur_din)
signal loja_ui

func _atualizar_ui_reset_progressbar(cur_xp, next_level):
	atualizar_ui_reset_progressbar.emit(cur_xp, next_level)

func _atualizar_ui_progressbar(cur_xp, cur_lvl, next_level):
	atualizar_ui_progressbar.emit(cur_xp, cur_lvl, next_level)
	print("oie")
	pass

func _darDanoPlayer(dano, nomeSinal):
	darDanoPlayer.emit(dano, nomeSinal)

func evento_ocorreu():
	acontecer_evento.emit()

func pegar_seg(seguranca):
	get_seg.emit(seguranca)
func pegar_mult(mult):
	get_mult.emit(mult)
func pegar_din(dinheiro):
	get_din.emit(dinheiro)

func emitir_ui(event_name: String, data = null) -> void:
	event_triggered.emit(event_name, data)

func abrir_loja():
	loja_ui.emit()

func emit_sigmal(cur_charges, max_charges):
	atualizar_esquivas.emit(cur_charges, max_charges)

func atualizar_score(score :int, seguranca, mult) -> void:
	atualizar_score_out.emit(score, seguranca, mult)
	



	
