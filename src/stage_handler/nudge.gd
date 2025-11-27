class_name Nudge
extends _StageHandler

func get_result_widget(widget: Widget, groups: Array[int]) -> _StageHandler.WidgetWithGroups:
    var result_widget := widget.duplicate(true)
    var wwg := _StageHandler.WidgetWithGroups.new(result_widget, groups)
    
    var location_a_idx := pos_to_idx(stage.location_a)
    var widget_group := stage.widget_groups[location_a_idx]
    var location_a_parts := get_widget_group_points(widget_group)
    var location_b_parts := _create_move_points(stage.location_b, location_a_parts)
    
    shift_widget(wwg, location_a_parts, location_b_parts)
    
    return wwg

func can_act() -> bool:
    if !stage.has_location_a || !stage.has_location_b :
        return false
        
    var location_a_idx := pos_to_idx(stage.location_a)
    var widget_group := stage.widget_groups[location_a_idx]
    var location_a_parts := get_widget_group_points(widget_group)
    var location_b_parts := _create_move_points(stage.location_b, location_a_parts)
    
    return _can_nudge(location_a_parts, location_b_parts)

func on_begin_edit() -> void:
    super.on_begin_edit()
    
func on_click(pos_i: Vector2i) -> void:
    var idx := pos_i.x + pos_i.y * 20
    if !stage.has_location_a:
        var widget_group := stage.widget_groups[idx]
        if widget_group == NONE: return
        
        set_highlight_by_widget_group(widget_group, PRIMARY)
        stage.has_location_a = true
        stage.location_a = pos_i
    elif !stage.has_location_b:
        var location_a_idx := pos_to_idx(stage.location_a)
        var widget_group := stage.widget_groups[location_a_idx]
        var location_a_parts := get_widget_group_points(widget_group)
        var move_points := _create_move_points(pos_i, location_a_parts)
        set_highlight_by_points(move_points, SECONDARY)
        stage.has_location_b = true
        stage.location_b = pos_i
        on_stop_edit()

func on_hover(pos_i : Vector2i) -> void:
    unhighlight_all()
    unhighlight_specific(CANCEL)
    
    var idx := pos_i.x + pos_i.y * 20
    if !stage.has_location_a:
        var widget_group := stage.widget_groups[idx]
        if widget_group != NONE:
            set_highlight_by_widget_group(widget_group, HOVER)
        else:
            if stage.highlight_blocks[idx] == NONE:
                stage.highlight_blocks[idx] = HOVER
    elif !stage.has_location_b:
        var location_a_idx := pos_to_idx(stage.location_a)
        var widget_group := stage.widget_groups[location_a_idx]
        var location_a_parts := get_widget_group_points(widget_group)
        var move_points := _create_move_points(pos_i, location_a_parts)
        var can_nudge := _can_nudge(location_a_parts, move_points)
        set_highlight_by_points(move_points, HOVER if can_nudge else CANCEL)

func _can_nudge(location_a_parts: Array[Vector2i], location_b_parts: Array[Vector2i] ) -> bool:
    for point : Vector2i in location_b_parts:
        if location_a_parts.any(func(p: Vector2i) -> bool: return p == point):
            continue
        var idx := pos_to_idx(point)
        
        if idx >= 0 && stage.widget_groups[idx] != NONE:
            return false
        
    return true

func _create_move_points(pos_i: Vector2i, selected_widget_group_points: Array[Vector2i]) -> Array[Vector2i]:
        var selected_center := get_points_center(selected_widget_group_points)
        var diff = Vector2(pos_i) - selected_center
        var highlight_offset := Vector2i.ZERO
        if absf(diff.x) > absf(diff.y): #more x diff than y
            if diff.x > 0:
                highlight_offset += Vector2i.RIGHT
            else:
                highlight_offset += Vector2i.LEFT
        else:
            if diff.y > 0:
                highlight_offset += Vector2i.DOWN
            else:
                highlight_offset += Vector2i.UP
        
        var move_points : Array[Vector2i] = []
        for pt: Vector2i in selected_widget_group_points:
            move_points.append(pt + highlight_offset)
        return move_points
