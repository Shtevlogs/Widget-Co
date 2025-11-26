class_name Nudge
extends _StageHandler

var selected_widget_group_points: Array[Vector2i]

func get_result_widget(widget: Widget) -> Widget:
    var result_widget := widget.duplicate(true)
    
    return result_widget

func on_begin_edit() -> void:
    super.on_begin_edit()
    selected_widget_group_points.clear()

func on_click(pos_i: Vector2i) -> void:
    var idx := pos_i.x + pos_i.y * 20
    if !stage.has_location_a:
        var widget_group := stage.widget_groups[idx]
        if widget_group == NONE: return
        
        set_highlight_by_widget_group(widget_group, PRIMARY)
        stage.has_location_a = true
        stage.location_a = pos_i
        selected_widget_group_points = get_widget_group_points(widget_group)
    elif !stage.has_location_b:
        var move_points := _create_move_points(pos_i)
        set_highlight_by_points(move_points, SECONDARY)
        stage.has_location_b = true
        stage.location_b = pos_i
        on_stop_edit()

func on_hover(pos_i : Vector2i) -> void:
    unhighlight_all()
    
    var idx := pos_i.x + pos_i.y * 20
    if !stage.has_location_a:
        var widget_group := stage.widget_groups[idx]
        if widget_group != NONE:
            set_highlight_by_widget_group(widget_group, HOVER)
        else:
            if stage.highlight_blocks[idx] == NONE:
                stage.highlight_blocks[idx] = HOVER
    elif !stage.has_location_b:
        var move_points := _create_move_points(pos_i)
        set_highlight_by_points(move_points)

func _create_move_points(pos_i: Vector2i) -> Array[Vector2i]:
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
