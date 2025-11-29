class_name SaveLoadManager
extends Node

const DATA_UPDATE_BUS : DataUpdateBus = preload("uid://fqqk6etp0pv8")
const LOG_BUS : LogBus = preload("uid://cjmm2v4ioa0li")

const DEBUG_ALWAYS_NEW_SAVE : bool = true

const _0 : Mineable = preload("uid://bnt02aamem8fg")
const _1 : Mineable = preload("uid://ilfmxi5boy6y")
const _2 : Mineable = preload("uid://lxc6jytmc1nr")

const _element_0 : Element = preload("uid://dk6v71aqysral")
const _element_1 : Element = preload("uid://c0c5n37gwofe3")
const _element_2 : Element = preload("uid://dak4ln80qdwl0")

@onready var mineable_display: MineableDisplay = $"../MarginContainer/HBoxContainer/MineableDisplay"
@onready var mineable_display_2: MineableDisplay = $"../MarginContainer/HBoxContainer/MineableDisplay2"
@onready var mineable_display_3: MineableDisplay = $"../MarginContainer/HBoxContainer/MineableDisplay3"

@onready var factory_display: FactoryDisplay = $"../MarginContainer/HBoxContainer2/FactoryDisplay"

func _ready() -> void:
    DATA_UPDATE_BUS.persist_save.connect(_on_persist_save)
    if DataModelSaveload.save_file_exists() && !DEBUG_ALWAYS_NEW_SAVE:
        _load_game()
    else:
        _initialize_save()
    _build_initial_ui()

func _input(event: InputEvent) -> void:
    var key_event := event as InputEventKey
    if !key_event || !key_event.pressed: return
    
    var slot_num : int = 0
    if key_event.keycode == KEY_1:
        slot_num = 1
    elif key_event.keycode == KEY_2:
        slot_num = 2
    elif key_event.keycode == KEY_3:
        slot_num = 3
    elif key_event.keycode == KEY_4:
        slot_num = 4
    elif key_event.keycode == KEY_5:
        slot_num = 5
    
    if slot_num == 0: return
    
    if key_event.shift_pressed:
        _on_persist_save(slot_num)
        LOG_BUS.lg.emit("Quick Save to #%d" % slot_num)
    elif key_event.ctrl_pressed:
        _initialize_save(slot_num)
        LOG_BUS.lg.emit("Initialize Quick Save #%d" % slot_num)
    else:
        _load_game(slot_num)
        LOG_BUS.lg.emit("Load Quick Save #%d" % slot_num)

func _load_game(slot_num: int = 0) -> void:
    Game.save_data = DataModelSaveload.do_load(slot_num)
    DATA_UPDATE_BUS.game_loaded.emit()

func _on_persist_save(slot : int = 0) -> void:
    DataModelSaveload.do_save(Game.save_data, slot)

func _build_initial_ui() -> void:
    # TODO: create mineables and factories on the fly
    mineable_display.assign(0)
    mineable_display_2.assign(1)
    mineable_display_3.assign(2)

func _initialize_save(slot : int = 0) -> void: 
    Game.save_data = SaveData.new()
    
    Game.save_data.elements = [
        _element_0.duplicate(true),
        _element_1.duplicate(true),
        _element_2.duplicate(true)
    ]
    
    var mine := Mine.new()
    mine.mineable = _0.duplicate(true)
    mine.mineable.element = mine.mineable.element.duplicate(true)
    mine.id = 0
    Game.save_data.mines.append(mine)
    var widget := Widget.new()
    widget.blocks = mine.mineable.to_blocks()
    Game.save_data.widgets.append(widget)
    
    mine = Mine.new()
    mine.mineable = _1.duplicate(true)
    mine.mineable.element = mine.mineable.element.duplicate(true)
    mine.id = 1
    Game.save_data.mines.append(mine)
    widget = Widget.new()
    widget.blocks = mine.mineable.to_blocks()
    Game.save_data.widgets.append(widget)
    
    mine = Mine.new()
    mine.mineable = _2.duplicate(true)
    mine.mineable.element = mine.mineable.element.duplicate(true)
    mine.id = 2
    Game.save_data.mines.append(mine)
    widget = Widget.new()
    widget.blocks = mine.mineable.to_blocks()
    Game.save_data.widgets.append(widget)

    var factory := Factory.new()
    Game.save_data.factories.append(factory)
    factory_display.factory_id = 0
    factory.stages = [
        Stage.new(),
        Stage.new()
    ]
    
    DataModelSaveload.do_save(Game.save_data, slot)
