class_name FactoryScreen
extends Panel

static var _i : FactoryScreen

const FACTORY_INPUT_DISPLAY := preload("uid://8lpxwb26b5y4")
const FACTORY_STAGE_DISPLAY = preload("uid://dujc424ijvxk7")
const WIDGET_RECT_DISPLAY = preload("uid://ds3276snotx7m")
const ADD_STAGE_BUTTON = preload("uid://cfr4y7cmrmagj")

@onready var input_container: VBoxContainer = $HSplitContainer/Data/Contents/VBoxContainer
@onready var stages_container: HBoxContainer = $HSplitContainer/ScrollContainer/MarginContainer/HBoxContainer

var factory_input_display_pool : Array[FactoryInputDisplay] = []
var factory_stage_display_pool : Array[FactoryStageDisplay] = []
var factory_result_display : WidgetRectDisplay
var add_stage_button : Button
var active_factory : Factory

func _ready() -> void:
    _i = self
    for i in 50:
        var new_factory_input_display := FACTORY_INPUT_DISPLAY.instantiate() as FactoryInputDisplay
        input_container.add_child(new_factory_input_display)
        new_factory_input_display.visible = false
        factory_input_display_pool.append(new_factory_input_display)
        new_factory_input_display.factory_input_pressed.connect(_on_input_pressed)

    for i in 50:
        var new_factory_stage_display := FACTORY_STAGE_DISPLAY.instantiate() as FactoryStageDisplay
        stages_container.add_child(new_factory_stage_display)
        new_factory_stage_display.visible = false
        factory_stage_display_pool.append(new_factory_stage_display)
        new_factory_stage_display.on_delete.connect(_on_delete_stage)
    
    add_stage_button = ADD_STAGE_BUTTON.instantiate() as Button
    add_stage_button.pressed.connect(_on_add_stage)
    stages_container.add_child(add_stage_button)
    
    factory_result_display = WIDGET_RECT_DISPLAY.instantiate() as WidgetRectDisplay
    stages_container.add_child(factory_result_display)
    

static func open(factory_id : int) -> void:
    _i.visible = true
    _i.assign(factory_id)

func assign(factory_id: int) -> void:
    active_factory = Game.save_data.factories[factory_id]
    var available_widgets := Game.save_data.widgets
    for i in 50:
        if available_widgets.size() > i:
            factory_input_display_pool[i].visible = true
            factory_input_display_pool[i].assign(available_widgets[i], active_factory)
        else:
            factory_input_display_pool[i].visible = false
    _flow_stages()
            
func _flow_stages() -> void:
    var working_widget := Widget.new()
    var working_groups : Array[int]
    
    for i in 20:
        for j in 20:
            @warning_ignore("integer_division")
            var quadrant_idx := (i / 10) * 2 + j / 10
            var input_widget_idx := -1 if active_factory.inputs.size() <= quadrant_idx else quadrant_idx
            if input_widget_idx == -1:
                working_widget.blocks.append(-1)
                working_groups.append(0)
            else:
                var input_widget := active_factory.inputs[input_widget_idx]
                var sub_widget_idx := (i % 10) * 10 + (j % 10)
                var input_element := input_widget.blocks[sub_widget_idx]
                working_widget.blocks.append(input_element)
                if input_element == -1:
                    working_groups.append(0)
                else:
                    working_groups.append(quadrant_idx + 1)
    
    for i in 50:
        if active_factory.stages.size() > i:
            factory_stage_display_pool[i].visible = true
            var working_stage := active_factory.stages[i]
            working_stage.widget_groups = working_groups.duplicate()
            factory_stage_display_pool[i].assign(working_widget, working_stage)
            working_widget = factory_stage_display_pool[i].get_result_widget(working_widget)
        else:
            factory_stage_display_pool[i].visible = false

func _on_x_pressed() -> void:
    visible = false

func _on_add_stage() -> void:
    var to_add := Stage.new()
    active_factory.stages.append(to_add)
    _flow_stages()

func _on_delete_stage(stage: Stage) -> void:
    var stage_idx := active_factory.stages.find(stage)
    active_factory.stages.remove_at(stage_idx)
    _flow_stages()

func _on_input_pressed(widget: Widget) -> void:
    _toggle_input(widget)
    _flow_inputs()
    _flow_stages()

func _toggle_input(widget: Widget) -> void:
    var idx := active_factory.inputs.find(widget)
    
    if idx == -1:
        active_factory.inputs.append(widget)
    else:
        active_factory.inputs.remove_at(idx)
    
func _flow_inputs() -> void:
    for input : FactoryInputDisplay in factory_input_display_pool:
        if !input.visible: continue
        var idx := active_factory.inputs.find(input.widget)
        input.update_selected(idx)
