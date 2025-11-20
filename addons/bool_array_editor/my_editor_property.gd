class_name MyEditorProperty
extends EditorProperty

const BOOL_ARRAY_CONTROL = preload("uid://dg3s8aba0qrrr")
var control : Control
var first_update := true

func _init():
    label = "Bool Array"
    
    control = BOOL_ARRAY_CONTROL.instantiate()
    add_child(control)
    

func _toggled(on: bool, idx: int) -> void:
    var obj = get_edited_object()
    var prop = get_edited_property()
    
    var obj_array : Array[bool] = obj.get(prop)
    var arr : Array[bool] = []
    arr.append_array(obj_array)
    
    arr[idx] = on
    
    emit_changed(prop, arr)

func _update_property() -> void:
    if first_update:
        first_update = false
        var obj = get_edited_object()
        var prop = get_edited_property()
        
        var arr : Array[bool] = obj.get(prop)
        var checkbox_root : HFlowContainer = control.get_node("HFlowContainer")
        
        for i : int in 100:
            var checkbox : CheckBox = checkbox_root.get_child(i)
            checkbox.button_pressed = arr[i]
            checkbox.toggled.connect(_toggled.bind(i))
    
