@abstract
class_name _StageHandler
extends RefCounted

const NONE := 0
const HOVER := 1
const PRIMARY := 2
const SECONDARY := 3
const CANCEL := 4

const STAGE_ACTION_BUS : StageActionBus = preload("uid://b1226272pebie")

var stage : Stage

func assign(s: Stage) -> void:
   stage = s 

@abstract
func get_result_widget(widget: Widget, groups: Array[int]) -> WidgetWithGroups

@abstract
func can_act() -> bool

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
    STAGE_ACTION_BUS.on_stage_edit_end.emit()

func get_pos_i(point: Vector2) -> Vector2i:
    var pos := point * 20.0 - Vector2.ONE * 0.5
    pos.x = clampf(pos.x, 0, 19)
    pos.y = clampf(pos.y, 0, 19)
    return Vector2i(roundi(pos.x), roundi(pos.y))

func unhighlight_all(level : int = HOVER) -> void:
    for i in 400:
        if stage.highlight_blocks[i] <= level:
            stage.highlight_blocks[i] = NONE
    stage.highlight_grid_x = -1
    stage.highlight_grid_y = -1
    stage.highlight_grid_color = HOVER

func unhighlight_specific(level: int) -> void:
    for i in 400:
        if stage.highlight_blocks[i] == level:
            stage.highlight_blocks[i] = NONE

func pos_to_idx(pos: Vector2i) -> int:
    if pos.x < 0 || pos.x >= 20 || pos.y < 0 || pos.y >= 20:
        return -1
    return pos.x + pos.y * 20

func idx_to_pos(idx: int) -> Vector2i:
    @warning_ignore("integer_division")
    return Vector2i(idx % 20, idx / 20)

func set_highlight_by_widget_group(widget_group: int, highlight_type: int = HOVER) -> void:
    for i in 400:
        if stage.widget_groups[i] == widget_group && stage.highlight_blocks[i] < PRIMARY:
            stage.highlight_blocks[i] = highlight_type

func get_widget_group_points(widget_group: int, widget_groups: Array[int] = []) -> Array[Vector2i]:
    var points : Array[Vector2i] = []
    
    if widget_groups.is_empty():
        widget_groups = stage.widget_groups
    
    for i in 400:
        if widget_groups[i] == widget_group:
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
        var i := pos_to_idx(point)
        if i < 0: continue
        if stage.highlight_blocks[i] < PRIMARY:
            stage.highlight_blocks[i] = highlight_type

func shift_widget(widget_w_groups : WidgetWithGroups, location_a_parts : Array[Vector2i], location_b_parts : Array[Vector2i]) -> void:
    var blocks : Array[int] = []
    var groups : Array[int] = []
    for point: Vector2i in location_a_parts:
        var idx := pos_to_idx(point)
        blocks.append(widget_w_groups.widget.blocks[idx])
        groups.append(widget_w_groups.groups[idx])
        widget_w_groups.widget.blocks[idx] = -1
        widget_w_groups.groups[idx] = 0
    for i: int in location_b_parts.size():
        var point := location_b_parts[i]
        var idx := pos_to_idx(point)
        if idx < 0:
            continue
        widget_w_groups.widget.blocks[idx] = blocks[i]
        widget_w_groups.groups[idx] = groups[i]

func get_last_widget_group() -> int:
    var highest := 0
    for g: int in stage.widget_groups:
        if g > highest:
            highest = g
    return highest

class WidgetWithGroups:
    var widget: Widget
    var groups: Array[int]
    func _init(w: Widget, g: Array[int]) -> void:
        widget = w
        groups = g
