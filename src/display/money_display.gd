class_name MoneyDisplay
extends Control

const DATA_UPDATE_BUS : DataUpdateBus = preload("uid://fqqk6etp0pv8")

@onready var total: Label = $Total

func _ready() -> void:
    DATA_UPDATE_BUS.monies_updated.connect(_on_monies_change)

func _on_timer_timeout() -> void:
    if !Game.save_data: return
    
    DATA_UPDATE_BUS.monies_updated.emit(Game.save_data.monies)

func _on_monies_change(new_monies: float) -> void:
    Game.save_data.monies = new_monies
    var out_val := roundf(new_monies * 100.0) / 100.0
    total.text = "$%0.2f" % out_val
