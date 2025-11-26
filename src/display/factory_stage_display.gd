class_name FactoryStageDisplay
extends Control

signal on_delete(stage: Stage)
signal on_edit(stage: Stage)

@onready var option_button: OptionButton = $Data/VBoxContainer/OptionButton
@onready var widget_rect_display: WidgetRectDisplay = $WidgetRectDisplay
@onready var stage_info_display: StageInfoDisplay = $StageInfoDisplay
@onready var widget_group_display: WidgetGroupDisplay = $WidgetGroupDisplay

var stage: Stage
var stage_handler : _StageHandler

func _ready() -> void:
    for e : Enums.StageAction in Enums.StageAction.values():
        option_button.add_item(Enums.stage_action_string(e), int(e))
    stage_info_display.on_click.connect(_on_stage_info_click)
    stage_info_display.on_hover.connect(_on_stage_info_hover)

func assign(w: Widget, s: Stage) -> void:
    stage = s
    stage_handler = StageUtils.get_stage_handler(stage.action)
    stage_handler.assign(s)
    widget_rect_display.assign(w, true)
    option_button.select(option_button.get_item_index(int(s.action)))
    widget_group_display.assign(stage.widget_groups)
    stage_info_display.assign(s)

func _on_stage_info_click(point: Vector2) -> void:
    stage_handler.click(point)
    
func _on_stage_info_hover(point: Vector2) -> void:
    stage_handler.hover(point)

func get_result_widget(widget: Widget) -> Widget:
    return stage_handler.get_result_widget(widget)

func _on_edit_pressed() -> void:
    on_edit.emit(stage)
    stage.is_editing = true
    stage_handler.on_begin_edit()

func _on_delete_pressed() -> void:
    on_delete.emit(stage)

func _on_option_button_item_selected(index: int) -> void:
    stage.action = option_button.get_item_id(index) as Enums.StageAction
    stage_info_display.assign(stage)
    stage_handler = StageUtils.get_stage_handler(stage.action)
    stage_handler.assign(stage)
