class_name WidgetRectDisplay
extends TextureRect

func _ready() -> void:
    material = material.duplicate() as ShaderMaterial

func assign(widget: Widget, double_width := false) -> void:
    var blocks := widget.blocks
    if double_width:
        material.set_shader_parameter("double_blocks", blocks)
    else:
        material.set_shader_parameter("blocks", blocks)
    material.set_shader_parameter("double_width", double_width)
