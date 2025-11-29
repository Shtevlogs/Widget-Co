class_name MoniesTick
extends Node

const SEC := 1.0/60.0
const DATA_UPDATE_BUS : DataUpdateBus = preload("uid://fqqk6etp0pv8")

func _on_timer_timeout() -> void:
    if !Game.save_data: return
    
    var save_data := Game.save_data
    var current_monies := save_data.monies
    
    for mine : Mine in save_data.mines:
        current_monies += mine.get_rate() * SEC * blocks_scrap_value(mine.mineable.to_blocks())
    
    DATA_UPDATE_BUS.monies_updated.emit(current_monies)
    DATA_UPDATE_BUS.persist_save.emit()

func blocks_scrap_value(blocks: Array[int]) -> float:
    var elements := Game.save_data.elements
    var count := 0.0
    var value := 0.0
    
    for b: int in blocks:
        if b != -1:
            count += 1
            value += elements[b].value
    
    return value * (0.8 ** (count - 1))
