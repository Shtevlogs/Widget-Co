class_name Element
extends _DataModel

@export var id := 0
@export var value := 0.1

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_value(str(id))
    string_data.add_value(str(value))
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    id = int(string_data.get_value())
    value = float(string_data.get_value())
