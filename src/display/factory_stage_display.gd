class_name FactoryStageDisplay
extends Control

signal on_delete(stage: Stage)
signal on_edit(stage: Stage)

@onready var widget_rect_display: WidgetRectDisplay = $WidgetRectDisplay

var stage: Stage

func assign(w: Widget, s: Stage) -> void:
    stage = s
    widget_rect_display.assign(w, true)

func _on_edit_pressed() -> void:
    on_edit.emit(stage)

func _on_delete_pressed() -> void:
    on_delete.emit(stage)
