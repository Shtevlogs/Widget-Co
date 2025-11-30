class_name StageInfoDisplay
extends TextureRect

signal on_click(point: Vector2)
signal on_hover(point: Vector2)

var stage : Stage

func _ready() -> void:
    material = material.duplicate()

func assign(s : Stage) -> void:
    stage = s

#TODO: if this proves to be bad for performance, do it with events instead
# it's probably fine though
func _process(_d: float) -> void:
    if !stage: return
    mouse_filter = Control.MOUSE_FILTER_PASS if stage.is_editing else Control.MOUSE_FILTER_IGNORE
    material.set_shader_parameter("blocks", stage.highlight_blocks)
    material.set_shader_parameter("highlight_gridline_x", stage.highlight_grid_x)
    material.set_shader_parameter("highlight_gridline_y", stage.highlight_grid_y)
    material.set_shader_parameter("grid_highlight_color", stage.highlight_grid_color)

func _input(event: InputEvent) -> void:
    if !stage || !stage.is_editing: return
    var mouse_event := event as InputEventMouse
    var is_mouse_button := event is InputEventMouseButton
    if is_mouse_button && !mouse_event.pressed:
        return
    var rect := get_global_rect()
        
    var point := mouse_event.global_position - rect.position
    point /= rect.size.x
    
    if is_mouse_button:
        on_click.emit(point)
    else:
        on_hover.emit(point)
