class_name MineableDisplay
extends Control

const DATA_UPDATE_BUS : DataUpdateBus = preload("uid://fqqk6etp0pv8")

var mine : Mine

#can't really use a widgetrectdisplay here as mineables use arrays of bool
@onready var texture_rect: TextureRect = $VBoxContainer/Control/TextureRect
@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button

func assign(id: int) -> void:
    mine = Game.save_data.mines[id]
    texture_rect.material = texture_rect.material.duplicate() as ShaderMaterial
    _update_ui()

func _update_ui() -> void:
    var blocks := _get_blocks()
    var center := WidgetUtils.get_center(blocks)
    texture_rect.material.set_shader_parameter("blocks", blocks)
    texture_rect.position = Vector2.ONE * 50 - center * 5 - Vector2.ONE * 5
    label.text = "%d/m" % mine.get_rate()
    button.text = "Upgrade\n($%0.2f)" % mine.get_upgrade_cost()
        
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
    
