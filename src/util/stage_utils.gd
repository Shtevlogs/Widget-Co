class_name StageUtils

static var _stage_handlers : Array[GDScript] = [
    Nudge
]

static func get_stage_handler(stage_action: Enums.StageAction) -> _StageHandler:
    return _stage_handlers[stage_action].new()
