class_name Mineable
extends _DataModel

@export var element: Element
@export var pattern: Array[bool] = [
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false, false, false
]

func to_blocks() -> Array[int]:
    var to_return : Array[int] = []
    
    for i in 100:
        var val := element.id if pattern[i] else -1
        to_return.append(val)
    
    return to_return
