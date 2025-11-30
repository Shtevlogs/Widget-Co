class_name Stage
extends _DataModel

@export var is_editing : bool
@export var action : Enums.StageAction
@export var has_location_a : bool
@export var location_a : Vector2i
@export var has_location_b : bool
@export var location_b : Vector2i
@export var widget_groups : Array[int]
@export var highlight_blocks : Array[int]
@export var highlight_grid_x : int = -1
@export var highlight_grid_y : int = -1
@export var highlight_grid_color : int = 1

func _init(data: String = "") -> void:
    widget_groups = WidgetUtils.HIGHLIGHT_BLOCKS.duplicate()
    highlight_blocks = WidgetUtils.HIGHLIGHT_BLOCKS.duplicate()
    super._init(data)

func stringify() -> String:
    var string_data := StringData.new()
    string_data.add_value(str(is_editing))
    string_data.add_value(str(int(action)))
    string_data.add_value(str(has_location_a))
    string_data.add_value(str(location_a.x))
    string_data.add_value(str(location_a.y))
    string_data.add_value(str(has_location_b))
    string_data.add_value(str(location_b.x))
    string_data.add_value(str(location_b.y))
    string_data.add_array(widget_groups)
    string_data.add_array(highlight_blocks)
    string_data.add_value(str(highlight_grid_x))
    string_data.add_value(str(highlight_grid_y))
    string_data.add_value(str(highlight_grid_color))
    return string_data.data

func load_from_string(data: String) -> void:
    var string_data := StringData.new(data)
    is_editing = string_data.get_value() == "true"
    action = int(string_data.get_value()) as Enums.StageAction
    has_location_a = string_data.get_value() == "true"
    location_a.x = int(string_data.get_value())
    location_a.y = int(string_data.get_value())
    has_location_b = string_data.get_value() == "true"
    location_b.x = int(string_data.get_value())
    location_b.y = int(string_data.get_value())
    widget_groups = string_data.get_array_i()
    highlight_blocks = string_data.get_array_i()
    highlight_grid_x = int(string_data.get_value())
    highlight_grid_y = int(string_data.get_value())
    highlight_grid_color = int(string_data.get_value())
