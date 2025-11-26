class_name Enums
extends Node

enum StageAction
{
    NUDGE,
    SLICE,
    GLUE,
    ROTATE_CW,
    ROTATE_CCW,
    EXPLODE,
    HEAT,
    SINK
}

static func stage_action_string(e: Enums.StageAction) -> String:
    match e:
        StageAction.NUDGE:
            return "Nudge"
        StageAction.SLICE:
            return "Slice"
        StageAction.GLUE:
            return "Glue"
        StageAction.ROTATE_CW:
            return "Rotate CW"
        StageAction.ROTATE_CCW:
            return "Rotate CCW"
        StageAction.EXPLODE:
            return "Explode"
        StageAction.HEAT:
            return "Heat"
        StageAction.SINK:
            return "Sink"
    return ""
