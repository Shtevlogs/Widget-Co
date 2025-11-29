class_name StringData
extends RefCounted

var data : String

func _init(d: String = "") -> void:
    data = d

func add_value(val: String) -> void:
    if data.length() == 0:
        data += val
    else:
        data += "," + val

func add_model(model: _DataModel) -> void:
    var model_data := model.stringify()
    add_value("{" + model_data + "}")

func add_array(arr: Array) -> void:
    var to_add := "["
    for thing in arr:
        if thing is _DataModel:
            var model_data := (thing as _DataModel).stringify()
            to_add += "{" + model_data + "},"
        else:
            to_add += str(thing) + ","
    
    if to_add == "[":
        add_value("[]")
        return
    
    to_add = to_add.substr(0, to_add.length() - 1) + "]"
    add_value(to_add)

func get_value() -> String:
    var next_comma_i := data.find(",")
    var value := data.substr(0, next_comma_i)
    data = data.substr(next_comma_i + 1)
    return value

func get_model() -> String:
    var closing_i := _get_next_pair("{","}",data)[1]
    var value := data.substr(1, closing_i - 1)
    data = data.substr(closing_i + 1)
    return value

func get_array_s() -> Array[String]:
    var closing_i := _get_next_pair("[","]",data)[1]
    var full_arr := data.substr(1, closing_i - 1)
    data = data.substr(closing_i + 2)
    
    var vals := full_arr.split(",")
    var to_return : Array[String] = []
    to_return.append_array(vals)
    
    return to_return
    
func get_array_i() -> Array[int]:
    var vals := get_array_s()
    var to_return : Array[int] = []
    for val: String in vals:
        to_return.append(int(val))
    
    return to_return
    
func get_array_f() -> Array[float]:
    var vals := get_array_s()
    var to_return : Array[float] = []
    for val: String in vals:
        to_return.append(float(val))
    
    return to_return

func get_array_b() -> Array[bool]:
    var vals := get_array_s()
    var to_return : Array[bool] = []
    for val: String in vals:
        to_return.append(val == "true")
    
    return to_return

func get_array_v2i() -> Array[Vector2i]:
    var x_vals := get_array_s()
    var y_vals := get_array_s()
    var to_return : Array[Vector2i] = []
    for i: int in x_vals.size():
        to_return.append(Vector2i(int(x_vals[i]),int(y_vals[i])))
    
    return to_return

func get_array_v2f() -> Array[Vector2]:
    var x_vals := get_array_s()
    var y_vals := get_array_s()
    var to_return : Array[Vector2] = []
    for i: int in x_vals.size():
        to_return.append(Vector2(float(x_vals[i]),float(y_vals[i])))
    
    return to_return

func assign_array_of_models(destination: Array, model_type: GDScript) -> void:
    var closing_i := _get_next_pair("[","]",data)[1]
    var full_arr := data.substr(1, closing_i - 1)
    data = data.substr(closing_i + 2)
    
    destination.clear()
    
    while full_arr.length() != 0:
        var c_i := _get_next_pair("{", "}",full_arr)[1]
        var model_s := full_arr.substr(1, c_i - 1)
        destination.append(model_type.new(model_s))
        full_arr = full_arr.substr(c_i + 1)
        if full_arr.begins_with(","):
            full_arr = full_arr.substr(1)

# this should work fine as long as there aren't any strings with {} or [] in them
func _get_next_pair(opening : String, closing : String, d : String) -> Array[int]:
    var first := -1
    var last := -1
    var open_ness := 0
    for i : int in d.length():
        var character := d.substr(i,1)
        if character == opening:
            if first == -1:
                first = i
            open_ness += 1
        if character == closing:
            open_ness -= 1
            if open_ness == 0:
                last = i
                return [first, last]
    return [first, last]
