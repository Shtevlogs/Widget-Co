class_name Mine
extends _DataModel

var id := 0
var mineable : Mineable
var level := 1

func get_rate() -> float:
    return float(2 ** (level - 1))

func get_upgrade_cost() -> float:
    return float(2 ** (level - 1)) * 100.0
