class_name MineableDisplay
extends Control

const DATA_UPDATE_BUS : DataUpdateBus = preload("uid://fqqk6etp0pv8")

var mine_id : int

#can't really use a widgetrectdisplay here as mineables use arrays of bool
@onready var texture_rect: TextureRect = $VBoxContainer/Control/TextureRect
@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button

func _ready() -> void:
    texture_rect.material = texture_rect.material.duplicate() as ShaderMaterial
    
func assign(id: int) -> void:
    mine_id = id

func _process(_delta: float) -> void:
    _update_ui()

func _update_ui() -> void:
    var mine := Game.save_data.mines[mine_id]
    var blocks := _get_blocks(mine)
    texture_rect.material.set_shader_parameter("blocks", blocks)
    label.text = "%d/m" % mine.get_rate()
    button.text = "Upgrade\n($%0.2f)" % mine.get_upgrade_cost()
        
func _get_blocks(mine: Mine) -> Array[int]:
    return mine.mineable.to_blocks()

func _on_button_pressed() -> void:
    var save_data := Game.save_data
    
    if  !save_data || !save_data.mines.size() > mine_id: return
    
    var mine := Game.save_data.mines[mine_id]
    
    var cost := mine.get_upgrade_cost()
    if cost > save_data.monies:
        return
        
    mine.level += 1
    DATA_UPDATE_BUS.monies_updated.emit(save_data.monies - cost)
    
    _update_ui()
    
