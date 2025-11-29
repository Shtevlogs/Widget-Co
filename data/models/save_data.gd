class_name SaveData
extends _DataModel

@export var monies := 1000.0
@export var mines : Array[Mine] = []
@export var elements : Array[Element] = []
@export var widgets : Array[Widget] = []
@export var factories : Array[Factory] = []

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_value(str(monies))
    string_data.add_array(mines)
    string_data.add_array(elements)
    string_data.add_array(widgets)
    string_data.add_array(factories)
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    monies = float(string_data.get_value())
    string_data.assign_array_of_models(mines, Mine)
    string_data.assign_array_of_models(elements, Element)
    string_data.assign_array_of_models(widgets, Widget)
    string_data.assign_array_of_models(factories, Factory)
