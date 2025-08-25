extends CanvasLayer

@onready var sprite = $AnimatedSprite2D

var upgrades_db = preload("res://Resources/upgrade_res.tres")
@onready var btn1 = $AnimatedSprite2D/Button
@onready var btn2 = $AnimatedSprite2D/Button2
@onready var btn3 = $AnimatedSprite2D/Button3
@onready var colRect = $ColorRect
@onready var player = get_tree().get_first_node_in_group("jogador")
var upgrades_usable = upgrades_db.upgrades.duplicate()
var pr_item_indice
var se_item_indice 
var te_item_indice

func random_item():
	pr_item_indice = randi() % upgrades_usable.size()
	se_item_indice = randi() % upgrades_usable.size()
	te_item_indice = randi() % upgrades_usable.size()
	btn1.text = upgrades_usable[pr_item_indice].nome
	btn2.text = upgrades_usable[se_item_indice].nome
	btn3.text = upgrades_usable[te_item_indice].nome

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var tween = create_tween()
	tween.tween_property(colRect, "modulate:a", 1.0, 0.3)
	random_item()
	sprite.play("go_down")
	get_tree().paused = true

func stop_displaying_bar():
	var tween = create_tween()
	tween.tween_property(colRect, "modulate:a", 0.0, 0.5)
	sprite.play("go_up")
	btn1.visible = false
	btn2.visible = false
	btn3.visible = false
	get_tree().paused = false

func _on_button_pressed() -> void:
	var _upgrade = upgrades_db.achar_id_funcao(upgrades_usable[pr_item_indice].id)
	if _upgrade:
		if upgrades_usable[pr_item_indice].arma != true:
			_upgrade.aplicar_funcao(player)
		else:
			print(upgrades_usable[pr_item_indice].preco)
			_upgrade.aplicar_funcao(player.get_node(upgrades_usable[pr_item_indice].alvo_nome))
	stop_displaying_bar()
func _on_button_2_pressed() -> void:
	var _upgrade = upgrades_db.achar_id_funcao(upgrades_usable[se_item_indice].id)
	if _upgrade:
		if upgrades_usable[se_item_indice].arma != true:
			_upgrade.aplicar_funcao(player)
		else:
			_upgrade.aplicar_funcao(player.get_node(upgrades_usable[se_item_indice].alvo_nome))
	stop_displaying_bar()

func _on_button_3_pressed() -> void:
	var _upgrade = upgrades_db.achar_id_funcao(upgrades_usable[te_item_indice].id)
	if _upgrade:
		if upgrades_usable[te_item_indice].arma != true:
			_upgrade.aplicar_funcao(player)
		else:
			_upgrade.aplicar_funcao(player.get_node(upgrades_usable[te_item_indice].alvo_nome))
	stop_displaying_bar()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "go_up":
		queue_free()
