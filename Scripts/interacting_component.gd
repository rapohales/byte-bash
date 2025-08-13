extends Node2D

@onready var interact_label: Label = $InteractLabel
var current_interations:= []
var can_interact := true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and can_interact:
		if current_interations:
			can_interact = false
			interact_label.hide()
			await current_interations[0].interact.call()
			EventBus.emitir_ui("emitir_ui", current_interations[0].get_parent().name)
			can_interact = true
func _process(_delta: float) -> void:
	if current_interations and can_interact:
		current_interations.sort_custom(_sort_by_nearest)
		if current_interations[0].is_interactable:
			interact_label.text = "E para interagir"
			interact_label.visible = true
		else:
			interact_label.visible = false
		return
			
func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist
		
func _on_interacting_range_area_entered(area: Area2D) -> void:
	current_interations.push_back(area)
	pass 


func _on_interacting_range_area_exited(area: Area2D) -> void:
	current_interations.erase(area)
	interact_label.visible = false
	pass 
