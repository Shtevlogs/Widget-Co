class_name MineableDisplay
extends Control

const DATA_UPDATE_BUS : DataUpdateBus = preload("uid://fqqk6etp0pv8")

var mine : Mine

@onready var texture_rect: TextureRect = $VBoxContainer/Control/TextureRect
@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button

func assign(id: int) -> void:
    mine = Game.save_data.mines[id]
    texture_rect.material = texture_rect.material.duplicate() as ShaderMaterial
    _update_ui()

func _update_ui() -> void:
    var center := _get_center()
    var blocks := _get_blocks()
    texture_rect.material.set_shader_parameter("blocks", blocks)
    texture_rect.position = Vector2.ONE * 30 - center * 6
    label.text = "%d/m" % mine.get_rate()
    button.text = "Upgrade\n($%0.2f)" % mine.get_upgrade_cost()

func _get_center() -> Vector2:
    var sum := Vector2.ZERO
    var count := 0.0
    
    for x:int in 10:
        for y:int in 10:
            var i := x + y * 10
            if !mine.mineable.pattern[i]:
                continue
            count += 1
            sum += Vector2(x,y)
    
    return sum / count
             
func _get_blocks() -> Array[int]:
    return mine.mineable.to_blocks()

func _on_button_pressed() -> void:
    var save_data := Game.save_data
    
    if !mine || !save_data: return
    
    var cost := mine.get_upgrade_cost()
    if cost > save_data.monies:
        return
        
    mine.level += 1
    DATA_UPDATE_BUS.monies_updated.emit(save_data.monies - cost)
    
    _update_ui()
    
