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

func _init() -> void:
    widget_groups = WidgetUtils.HIGHLIGHT_BLOCKS.duplicate()
    highlight_blocks = WidgetUtils.HIGHLIGHT_BLOCKS.duplicate()
