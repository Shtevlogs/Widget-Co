class_name Game
extends Node

static var save_data : SaveData

const _0 = preload("uid://bnt02aamem8fg")
const _1 = preload("uid://ilfmxi5boy6y")
const _2 = preload("uid://lxc6jytmc1nr")

const _element_0 : Element = preload("uid://dk6v71aqysral")
const _element_1 : Element = preload("uid://c0c5n37gwofe3")
const _element_2 : Element = preload("uid://dak4ln80qdwl0")

@onready var mineable_display: MineableDisplay = $"../MarginContainer/HBoxContainer/MineableDisplay"
@onready var mineable_display_2: MineableDisplay = $"../MarginContainer/HBoxContainer/MineableDisplay2"
@onready var mineable_display_3: MineableDisplay = $"../MarginContainer/HBoxContainer/MineableDisplay3"

func _ready() -> void:
    save_data = SaveData.new()
    
    save_data.elements = [
        _element_0,
        _element_1,
        _element_2
    ]
    
    var mine := Mine.new()
    mine.mineable = _0
    mine.id = 0
    save_data.mines.append(mine)
    mineable_display.assign(mine.id)
    
    mine = Mine.new()
    mine.mineable = _1
    mine.id = 1
    save_data.mines.append(mine)
    mineable_display_2.assign(mine.id)
    
    mine = Mine.new()
    mine.mineable = _2
    mine.id = 2
    save_data.mines.append(mine)
    mineable_display_3.assign(mine.id)
