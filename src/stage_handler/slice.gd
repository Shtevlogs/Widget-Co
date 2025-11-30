class_name Slice
extends _StageHandler

func on_click(_pos_i: Vector2i) -> void:
    pass #this handler only cares about the actual v2
func on_hover(_pos_i : Vector2i) -> void:
    pass #this handler only cares about the actual v2

func get_result_widget(widget: Widget, groups: Array[int]) -> _StageHandler.WidgetWithGroups:
    var result_widget := widget.duplicate(true)
    var wwg := _StageHandler.WidgetWithGroups.new(result_widget, groups)
    
    var line_intersect := LineIntersect.from_loc(stage.location_a)
    var intersect_groups := _line_intersects_groups(line_intersect)
    
    var ungrouped := -100
    
    for group: int in intersect_groups:
        var group_points := get_widget_group_points(group)
        for gp : Vector2i in group_points:
            var gp_i := gp.x if line_intersect.is_x else gp.y
            if gp_i >= line_intersect.index:
                wwg.groups[pos_to_idx(gp)] = ungrouped
    
    var next_widget_group := get_last_widget_group() + 1
    var ungrouped_points := get_widget_group_points(ungrouped, wwg.groups)
    while !ungrouped_points.is_empty():
        var congruent_points := _get_congruent_group_points(ungrouped_points[0], ungrouped, wwg.groups)
        for p: Vector2i in congruent_points:
            var p_i := ungrouped_points.find(p)
            ungrouped_points.remove_at(p_i)
            wwg.groups[pos_to_idx(p)] = next_widget_group
        next_widget_group += 1
    
    return wwg

func _get_congruent_group_points(point: Vector2i, group: int, widget_groups: Array[int]) -> Array[Vector2i]:
    var congruent_points : Array[Vector2i] = [point]
    var crawl_idx := 0
    while crawl_idx < congruent_points.size():
        var crawl_point := congruent_points[crawl_idx]
        var dir := crawl_point + Vector2i.LEFT
        if _is_point_in_group(dir, group, widget_groups) && !congruent_points.has(dir):
            congruent_points.append(dir)
        dir = crawl_point + Vector2i.RIGHT
        if _is_point_in_group(dir, group, widget_groups) && !congruent_points.has(dir):
            congruent_points.append(dir)
        dir = crawl_point + Vector2i.UP
        if _is_point_in_group(dir, group, widget_groups) && !congruent_points.has(dir):
            congruent_points.append(dir)
        dir = crawl_point + Vector2i.DOWN
        if _is_point_in_group(dir, group, widget_groups) && !congruent_points.has(dir):
            congruent_points.append(dir)
        crawl_idx += 1
    return congruent_points

func _is_point_in_group(point: Vector2i, group: int, widget_groups: Array[int]) -> bool:
    var idx := pos_to_idx(point)
    return idx != -1 && widget_groups[idx] == group

func can_act() -> bool:
    if !stage.has_location_a :
        return false
    
    var line_intersect := LineIntersect.from_loc(stage.location_a)
    return !_line_intersects_groups(line_intersect).is_empty()

func click(point: Vector2) -> void:
    super.click(point)
    
    var line_intersect := _get_line_intersect(point)
    if !stage.has_location_a:
        var intersect_groups := _line_intersects_groups(line_intersect)
        if intersect_groups.size() == 0: return
        
        for group: int in intersect_groups:
            var group_points := get_widget_group_points(group)
            for gp : Vector2i in group_points:
                var gp_i := gp.x if line_intersect.is_x else gp.y
                if gp_i >= line_intersect.index:
                    stage.highlight_blocks[pos_to_idx(gp)] = PRIMARY
                else:
                    stage.highlight_blocks[pos_to_idx(gp)] = SECONDARY
        stage.has_location_a = true
        stage.location_a = line_intersect.to_loc()
        on_stop_edit()

func hover(point: Vector2) -> void:
    super.hover(point)
    unhighlight_all()
    unhighlight_specific(CANCEL)
    
    var line_intersect := _get_line_intersect(point)
    if line_intersect && !stage.has_location_a:
        if line_intersect.is_x:
            stage.highlight_grid_x = line_intersect.index
            stage.highlight_grid_y = -1
        else:
            stage.highlight_grid_x = -1
            stage.highlight_grid_y = line_intersect.index
        if _line_intersects_groups(line_intersect).size() > 0:
            stage.highlight_grid_color = HOVER
        else:
            stage.highlight_grid_color = CANCEL

func _line_intersects_groups(line_intersect: LineIntersect) -> Array[int]:
    if line_intersect.index <= 0 || line_intersect.index >= 19:
        return []
    
    var side_1_groups : Array[int] = []
    var side_2_groups : Array[int] = []
    
    for i : int in 20:
        var check_pos := Vector2i(i, line_intersect.index) if !line_intersect.is_x\
         else Vector2i(line_intersect.index, i)
        var check_pos_2 := check_pos + (Vector2i.UP if !line_intersect.is_x\
         else Vector2i.LEFT) 
        
        var check_idx := pos_to_idx(check_pos)
        var check_idx_2 := pos_to_idx(check_pos_2)
        
        var group_1 := stage.widget_groups[check_idx]
        if group_1 != NONE && !side_1_groups.has(group_1):
            side_1_groups.append(group_1)
        var group_2 := stage.widget_groups[check_idx_2]
        if group_2 != NONE && !side_2_groups.has(group_2):
            side_2_groups.append(group_2)
    
    var to_return : Array[int] = []
    
    for group: int in side_1_groups:
        if side_2_groups.has(group):
            to_return.append(group)
        
    return to_return

# TODO: maybe move this to base class
func _get_line_intersect(point: Vector2) -> LineIntersect:
    var pos := point * 20.0 - Vector2.ONE * 0.5
    
    var x_grid : int = roundi(pos.x)
    var y_grid : int = roundi(pos.y)
    
    var x_fucked := x_grid < 0 || x_grid > 20
    var y_fucked := y_grid < 0 || y_grid > 20
    
    if x_fucked && y_fucked:
        return null
    elif x_fucked:
        return LineIntersect.new(false, y_grid)
    elif y_fucked:
        return LineIntersect.new(true, x_grid)
    
    var x_remain : float = absf(pos.x - x_grid)
    var y_remain : float = absf(pos.y - y_grid)
    
    if x_remain > y_remain:
        return LineIntersect.new(false, y_grid)
    else:
        return LineIntersect.new(true, x_grid)

class LineIntersect:
    var is_x: bool
    var index: int
    func _init(x: bool, i: int) -> void:
        is_x = x
        index = i
    
    func to_loc() -> Vector2i:
        return Vector2i(1 if is_x else 0, index)
    
    static func from_loc(xy: Vector2i) -> LineIntersect:
        return LineIntersect.new(xy.x == 1, xy.y)
