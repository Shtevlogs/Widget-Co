class_name BoolArrayInspectorPlugin
extends EditorInspectorPlugin

const BOOL_ARRAY_CONTROL = preload("uid://dg3s8aba0qrrr")

func _can_handle(object):
    return object is _DataModel

func _parse_property(object : Object, type : Variant.Type, path : String, hint : PropertyHint, hint_text : String, usage : int, wide : bool) -> bool:
    
    if type == TYPE_ARRAY:
        var val = object.get(path)
        if val.get_typed_builtin() == TYPE_BOOL && val.size() == 100:
            add_property_editor(path, MyEditorProperty.new(), true)
            return true  
        else:
            return false
    else:
        return false

func _create_custom_control(object, val: Array[bool], path: String) -> Control:
    var custom_control := BOOL_ARRAY_CONTROL.instantiate() as Control
    
    var label : Label = custom_control.get_node("VBoxContainer/Label")
    label.text = " " + path.to_pascal_case()
    
    var checkbox_root : HFlowContainer = custom_control.get_node("VBoxContainer/HFlowContainer")
    
    for i : int in 100:
        var value : bool = val[i]
        var checkbox : CheckBox = checkbox_root.get_child(i)
        checkbox.button_pressed = value

    return custom_control
