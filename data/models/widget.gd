class_name Widget
extends _DataModel

@export var blocks: Array[int] = []

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_array(blocks)
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    blocks = string_data.get_array_i()
