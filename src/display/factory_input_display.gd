class_name FactoryInputDisplay
extends Control

signal factory_input_pressed(widget: Widget)

var widget : Widget
var factory : Factory

@onready var label: Label = $VBoxContainer/Label
@onready var widget_display: WidgetRectDisplay = $VBoxContainer/Button/WidgetRectDisplay

func assign(w: Widget, f: Factory) -> void:
    widget = w
    factory = f
    widget_display.assign(widget)
    update_selected(factory.inputs.find(widget))

func update_selected(selected_idx : int) -> void:
    label.text = "" if selected_idx == -1 else str(selected_idx + 1)

func _on_button_pressed() -> void:
    factory_input_pressed.emit(widget)
