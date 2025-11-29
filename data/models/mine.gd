class_name Mine
extends _DataModel

@export var id := 0
@export var mineable : Mineable
@export var level := 1

func get_rate() -> float:
    return float(2 ** (level - 1))

func get_upgrade_cost() -> float:
    return float(2 ** (level - 1)) * 100.0

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_value(str(id))
    string_data.add_value(str(level))
    string_data.add_model(mineable)
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    id = int(string_data.get_value())
    level = int(string_data.get_value())
    mineable = Mineable.new(string_data.get_model())
