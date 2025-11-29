class_name Factory
extends _DataModel

@export var level := 0
@export var inputs : Array[Widget]
@export var outputs : Array[Widget]
@export var stages : Array[Stage]

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_value(str(level))
    string_data.add_array(inputs)
    string_data.add_array(outputs)
    string_data.add_array(stages)
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    level = int(string_data.get_value())
    string_data.assign_array_of_models(inputs, Widget)
    string_data.assign_array_of_models(outputs, Widget)
    string_data.assign_array_of_models(stages, Stage)
    
