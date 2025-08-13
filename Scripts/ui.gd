extends CanvasLayer

@onready var score_label = $TexturaUI/ScoreLabel
@onready var score_label2 = $TexturaUI/ScoreLabel2
@onready var score_label3 = $TexturaUI/ScoreLabel3
@onready var progressbar = $TextureProgressBar

@onready var dash_outer_hud = $TexturaUI/DashBarOuter
@onready var dash_inner_hud: TextureProgressBar = $TexturaUI/DashBarOuter/DashBarInner
@onready var health_outer_hud = $TexturaUI/HealthBarOuter
@onready var health_inner_hud = $TexturaUI/HealthBarOuter/HealthBarInner

@onready var player = get_tree().get_first_node_in_group("player")
@onready var fireworks_scene = preload("res://Cenas/efeito_nivel.tscn")

func _ready() -> void:
	update_health_bar(player.health)
	update_dash_bar()
	EventBus.atualizar_score_eventbus.connect(update_score_display)
	EventBus.atualizar_ui_progressbar.connect(update_progressbar_display)
	EventBus.atualizar_ui_reset_progressbar.connect(reset_progressbar_display)
	
func reset_progressbar_display(cur_xp, next_level):
	progressbar.value = 0
	progressbar.max_value = next_level
	var fireworks = fireworks_scene.instantiate()
	fireworks.position = $Marker2D.global_position
	add_child(fireworks)
	fireworks.emitting = true
	await get_tree().create_timer(2.0).timeout
	fireworks.queue_free()

func update_health_bar(vida_atual):
	health_inner_hud.max_value = player.max_health
	health_inner_hud.value = vida_atual
func update_dash_bar():
	dash_inner_hud.max_value = player.max_dodge_charges
	var tween = create_tween()
	tween.tween_property(dash_inner_hud, "value", player.dodge_charges, 2)
	dash_inner_hud.value = player.dodge_charges
func update_progressbar_display(cur_xp, cur_lvl, next_level):
	progressbar.value = cur_xp
	score_label3.text = "%d" %cur_lvl
	pass

func update_score_display(score, _seguranca, mult):
	score_label.text = "%d" % score 
	score_label2.text = "%d" % _seguranca
	score_label.get_node("ScoreLabel").text = "Mult: %d" % mult

func update_score_out(score, _seguranca):
	EventBus.atualizar_score_out.connect(update_score_display)
	print(score)
