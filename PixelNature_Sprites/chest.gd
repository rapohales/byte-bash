extends Area2D


@onready var interactable: Area2D = $Interactables
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if sprite_2d.frame == 0 and interactable.is_interactable == true:
		sprite_2d.play('abrir')
		interactable.is_interactable = false
		
