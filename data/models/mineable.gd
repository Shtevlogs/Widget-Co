class_name Mineable
extends _DataModel

@export var element: Element
@export var pattern: Array[bool] = [
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false
]

func to_blocks() -> Array[int]:
    var to_return : Array[int] = []
    
    for i in 100:
        var val := element.id if pattern[i] else -1
        to_return.append(val)
    
    return to_return
       

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_model(element)
    string_data.add_array(pattern)
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    element = Element.new(string_data.get_model())
    pattern = string_data.get_array_b()
