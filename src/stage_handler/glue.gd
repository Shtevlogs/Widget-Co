class_name Glue
extends _StageHandler

func get_result_widget(widget: Widget, groups: Array[int]) -> _StageHandler.WidgetWithGroups:
    var result_widget := widget.duplicate(true)
    var wwg := _StageHandler.WidgetWithGroups.new(result_widget, groups)

    var a_idx := pos_to_idx(stage.location_a)
    var widget_group_a := stage.widget_groups[a_idx]
    var b_idx := pos_to_idx(stage.location_a)
    var widget_group_b := stage.widget_groups[b_idx]
    
    if widget_group_a > widget_group_b:
        var temp := widget_group_a
        widget_group_a = widget_group_b
        widget_group_b = temp
    
    for i: int in wwg.groups.size():
        if wwg.groups[i] == widget_group_b:
            wwg.groups[i] = widget_group_a

    # shifting all of the groups down to make up for the now missing group b
    while true:
        var changed_one := false
        widget_group_a = widget_group_b
        widget_group_b = widget_group_b + 1    
        
        for i: int in wwg.groups.size():
            if wwg.groups[i] == widget_group_b:
                wwg.groups[i] = widget_group_a
                changed_one = true
    
        if changed_one:
            break
    
    return wwg

func can_act() -> bool:
    if !stage.has_location_a || !stage.has_location_b :
        return false
    var location_a_idx := pos_to_idx(stage.location_a)
    var group_a := stage.widget_groups[location_a_idx]
    if group_a == NONE:
        return false
    var location_b_idx := pos_to_idx(stage.location_b)
    var group_b := stage.widget_groups[location_b_idx]
    if group_b == NONE:
        return false
    
    return _groups_are_congruent(group_a, group_b)

func on_click(pos_i: Vector2i) -> void:
    var idx := pos_i.x + pos_i.y * 20
    if !stage.has_location_a:
        var widget_group := stage.widget_groups[idx]
        if widget_group == NONE: return
        
        set_highlight_by_widget_group(widget_group, PRIMARY)
        stage.has_location_a = true
        stage.location_a = pos_i
    elif !stage.has_location_b:
        var a_idx := pos_to_idx(stage.location_a)
        var widget_group_a := stage.widget_groups[a_idx]
        var widget_group := stage.widget_groups[idx]
        if widget_group == NONE || widget_group == widget_group_a\
         || !_groups_are_congruent(widget_group, widget_group_a): return
        
        set_highlight_by_widget_group(widget_group, SECONDARY)
        stage.has_location_b = true
        stage.location_b = pos_i
        on_stop_edit()

func on_hover(pos_i : Vector2i) -> void:
    unhighlight_all()
    unhighlight_specific(CANCEL)
    
    var idx := pos_i.x + pos_i.y * 20
    if !stage.has_location_a:
        #TODO: convert me into shared function hover_widget_group
        var widget_group := stage.widget_groups[idx]
        if widget_group != NONE:
            set_highlight_by_widget_group(widget_group, HOVER)
        else:
            if stage.highlight_blocks[idx] == NONE:
                stage.highlight_blocks[idx] = HOVER
    elif !stage.has_location_b:
        #TODO: convert me into shared function hover_widget_group
        var a_idx := pos_to_idx(stage.location_a)
        var widget_group_a := stage.widget_groups[a_idx]
        var widget_group := stage.widget_groups[idx]
        if widget_group != NONE && widget_group != widget_group_a:
            var congruent := _groups_are_congruent(widget_group, widget_group_a)
            set_highlight_by_widget_group(widget_group, HOVER if congruent else CANCEL)
        else:
            if stage.highlight_blocks[idx] == NONE:
                stage.highlight_blocks[idx] = HOVER

#consider moving this into parent class
func _groups_are_congruent(wg_a: int, wg_b: int) -> bool:
    if wg_a == NONE || wg_b == NONE: return false
    
    var widget_a_points := get_widget_group_points(wg_a)
    var widget_b_points := get_widget_group_points(wg_b)
    
    for p_a : Vector2i in widget_a_points:
        for p_b : Vector2i in widget_b_points:
            if p_a == Vector2i(p_b.x + 1, p_b.y):
                return true
            if p_a == Vector2i(p_b.x - 1, p_b.y):
                return true
            if p_a == Vector2i(p_b.x, p_b.y + 1):
                return true
            if p_a == Vector2i(p_b.x, p_b.y - 1):
                return true
    
    return false
    
