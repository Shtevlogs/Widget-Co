class_name WidgetRectDisplay
extends TextureRect

func _ready() -> void:
    material = material.duplicate() as ShaderMaterial

func assign(widget: Widget, double_width := false) -> void:
    var blocks := widget.blocks
    var center := WidgetUtils.get_center_d(blocks) if double_width else WidgetUtils.get_center(blocks)
    if double_width:
        material.set_shader_parameter("double_blocks", blocks)
    else:
        material.set_shader_parameter("blocks", blocks)
    material.set_shader_parameter("double_width", double_width)
    
    var width := custom_minimum_size.x
    var offset := 0.3 if double_width else 0.4
    position = Vector2.ONE * width * offset - center * width / 100
