class_name LogContainer
extends VBoxContainer

const LOG = preload("uid://fu6qy8302pm8")
const LOG_BUS : LogBus = preload("uid://cjmm2v4ioa0li")

func _ready() -> void:
    LOG_BUS.lg.connect(_on_log)

func _on_log(msg: String) -> void:
    var lg := LOG.instantiate() as Label
    add_child(lg)
    lg.text = msg
