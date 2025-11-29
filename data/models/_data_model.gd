@abstract
class_name _DataModel
extends Resource

func _init(data: String = "") -> void:
    if data == "":
        return
    load_from_string(data)

@abstract
func stringify() -> String

@abstract
func load_from_string(data: String) -> void
