@abstract
class_name _StageHandler
extends RefCounted

const NONE := 0
const HOVER := 1
const PRIMARY := 2
const SECONDARY := 3
const CANCEL := 4

var stage : Stage

func assign(s: Stage) -> void:
   stage = s 

@abstract
func get_result_widget(widget: Widget) -> Widget

func click(point: Vector2) -> void:
    if point.x < 0 || point.x > 1.0 || point.y < 0 || point.y > 1.0:
        on_stop_edit()
    var pos_i := get_pos_i(point)
    on_click(pos_i)
    
@abstract
func on_click(pos_i: Vector2i) -> void

func hover(point: Vector2) -> void:
    var pos_i := get_pos_i(point)
    on_hover(pos_i)

@abstract
func on_hover(pos_i: Vector2i) -> void

func on_begin_edit() -> void:
    stage.has_location_a = false
    stage.has_location_b = false
    unhighlight_all(CANCEL)
    
func on_stop_edit() -> void:
    stage.is_editing = false
    unhighlight_all()

func get_pos_i(point: Vector2) -> Vector2i:
    var pos := point * 20.0 - Vector2.ONE * 0.5
    pos.x = clampf(pos.x, 0, 19)
    pos.y = clampf(pos.y, 0, 19)
    return Vector2i(roundi(pos.x), roundi(pos.y))

func unhighlight_all(level : int = HOVER) -> void:
    for i in 400:
        if stage.highlight_blocks[i] <= level:
            stage.highlight_blocks[i] = NONE

func set_highlight_by_widget_group(widget_group: int, highlight_type: int = HOVER) -> void:
    for i in 400:
        if stage.widget_groups[i] == widget_group && stage.highlight_blocks[i] < PRIMARY:
            stage.highlight_blocks[i] = highlight_type

func get_widget_group_points(widget_group: int) -> Array[Vector2i]:
    var points : Array[Vector2i] = []
    
    for i in 400:
        if stage.widget_groups[i] == widget_group:
            @warning_ignore("integer_division")
            points.append(Vector2i(i % 20, i / 20))
    
    return points
    
func get_points_center(points: Array[Vector2i]) -> Vector2:
    if points.size() == 0:
        return Vector2.ZERO
        
    var sum := Vector2i.ZERO
    var count := 0.0
    
    for point: Vector2i in points:
        count += 1.0
        sum += point
    
    return Vector2(sum) / count

func set_highlight_by_points(points: Array[Vector2i], highlight_type: int = HOVER) -> void:
    for point: Vector2i in points:
        if point.x < 0 || point.x >= 20 || point.y < 0 || point.y >= 20: continue
        var i := point.x + point.y * 20
        if stage.highlight_blocks[i] < PRIMARY:
            stage.highlight_blocks[i] = highlight_type
