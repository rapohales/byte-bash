extends CanvasLayer
@onready var btn1 = $TextureRect/Button
@onready var btn2 = $TextureRect/Button2
@onready var btn3 = $TextureRect/Button3
@onready var val1 = btn1.get_node("Valor")
@onready var val2 = btn2.get_node("Valor")
@onready var val3 = btn3.get_node("Valor")
@onready var player = get_node("../../Player")
var upgrades_db = preload("res://Resources/upgrade_res.tres")

@onready var currency = get_node("../../Currency")
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
	val1.text = "Preço: %d" %upgrades_usable[pr_item_indice].preco
	val2.text = "Preço: %d" %upgrades_usable[se_item_indice].preco
	val3.text = "Preço: %d" %upgrades_usable[te_item_indice].preco
func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_ALWAYS
	random_item()
	EventBus.loja_ui.connect(abrirLoja)
	pass

func _on_att_loja_timeout() -> void:
	random_item()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		random_item()
func abrirLoja():
	print("oi")
func _on_button_pressed() -> void:
	var _upgrade = upgrades_db.achar_id_funcao(upgrades_usable[pr_item_indice].id)
	if _upgrade:
		if currency.moedas >= upgrades_usable[pr_item_indice].preco:
			currency.moedas -= upgrades_usable[pr_item_indice].preco
			if upgrades_usable[pr_item_indice].arma != true:
				_upgrade.aplicar_funcao(player)
			else:
				print(upgrades_usable[pr_item_indice].preco)
				_upgrade.aplicar_funcao(player.get_node(upgrades_usable[pr_item_indice].alvo_nome))

func _on_button_2_pressed() -> void:
	var _upgrade = upgrades_db.achar_id_funcao(upgrades_usable[se_item_indice].id)
	if _upgrade:
		if currency.moedas >= upgrades_usable[se_item_indice].preco:
			currency.moedas -= upgrades_usable[se_item_indice].preco
			if upgrades_usable[se_item_indice].arma != true:
				_upgrade.aplicar_funcao(player)
			else:
				print(upgrades_usable[se_item_indice].preco)
				_upgrade.aplicar_funcao(player.get_node(upgrades_usable[se_item_indice].alvo_nome))

func _on_button_3_pressed() -> void:
	var _upgrade = upgrades_db.achar_id_funcao(upgrades_usable[te_item_indice].id)
	if _upgrade:
		if currency.moedas >= upgrades_usable[te_item_indice].preco:
			currency.moedas -= upgrades_usable[te_item_indice].preco
			print(upgrades_usable[te_item_indice].preco)
			if upgrades_usable[te_item_indice].arma != true:
				_upgrade.aplicar_funcao(player)
			else:
				print(upgrades_usable[te_item_indice].preco)
				_upgrade.aplicar_funcao(player.get_node(upgrades_usable[te_item_indice].alvo_nome))
			
