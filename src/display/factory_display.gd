class_name FactoryDisplay
extends Control

var factory_id := 0

@onready var input_texture_rects : Array[TextureRect] = [
    $Button/VBoxContainer/TextureRect,
    $Button/VBoxContainer/TextureRect2,
    $Button/VBoxContainer/TextureRect3,
    $Button/VBoxContainer/TextureRect4
]
@onready var output_texture_rects : Array[TextureRect] = [
    $Button/VBoxContainer2/TextureRect,
    $Button/VBoxContainer2/TextureRect2,
    $Button/VBoxContainer2/TextureRect3,
    $Button/VBoxContainer2/TextureRect4
]

func _on_button_pressed() -> void:
    FactoryScreen.open(factory_id)
