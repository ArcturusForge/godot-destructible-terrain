@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("CarvingTerrain", "res://addons/2d_terrain_carving/Scripts/global_CarvingTerrain.gd")
	pass


func _exit_tree():
	remove_autoload_singleton("CarvingTerrain")
	pass
