class_name DataModelSaveload

const SAVE_PATH := "user://savegame.dm"
const SLOT_SAVE_PATH := "user://savegame_%d.dm"

static func _open(slot : int, access: FileAccess.ModeFlags) -> FileAccess:
    var f : FileAccess
    if slot == 0:
        f = FileAccess.open(SAVE_PATH, access)
    else:
        f = FileAccess.open(SLOT_SAVE_PATH % slot, access)
    return f

static func do_save(save_data: SaveData, slot : int = 0) -> void:
    var f := _open(slot, FileAccess.WRITE)
    var data := save_data.stringify()
    f.store_string(data)
    f.close()
    
static func do_load(slot: int = 0) -> SaveData:
    var f := _open(slot, FileAccess.READ)
    var data := f.get_as_text()
    f.close()
    var save_data := SaveData.new(data)
    return save_data

static func save_file_exists(slot: int = 0) -> bool:
    if slot == 0:
        return FileAccess.file_exists(SAVE_PATH)
    else:
        return FileAccess.file_exists(SLOT_SAVE_PATH % slot)
