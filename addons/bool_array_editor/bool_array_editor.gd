@tool
extends EditorPlugin

var plugin_type := preload("res://addons/bool_array_editor/bool_array_inspector_plugin.gd")
var plugin : BoolArrayInspectorPlugin

func _enter_tree() -> void:
    # Initialization of the plugin goes here.
    plugin = plugin_type.new()
    add_inspector_plugin(plugin)

func _exit_tree() -> void:
    remove_inspector_plugin(plugin)
