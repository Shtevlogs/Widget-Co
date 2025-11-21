class_name WidgetUtils

# 10x10 -1
const EMPTY_BLOCKS : Array[int] = [
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
]

static func get_center(blocks: Array[int]) -> Vector2:
    var sum := Vector2.ZERO
    var count := 0.0
    
    for x:int in 10:
        for y:int in 10:
            var i := x + y * 10
            if !blocks[i]:
                continue
            count += 1
            sum += Vector2(x,y)
    
    return sum / count

static func get_center_d(blocks: Array[int]) -> Vector2:
    var sum := Vector2.ZERO
    var count := 0.0
    
    for x:int in 20:
        for y:int in 20:
            var i := x + y * 20
            if !blocks[i]:
                continue
            count += 1
            sum += Vector2(x,y)
    
    return sum / count
