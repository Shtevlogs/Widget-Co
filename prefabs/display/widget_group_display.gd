class_name WidgetGroupDisplay
extends TextureRect

var highlight_blocks :Array[int] = []

func _ready() -> void:
    material = material.duplicate() as ShaderMaterial

func assign(h_b: Array[int]) -> void:
    highlight_blocks = h_b
    material.set_shader_parameter("blocks", highlight_blocks)
