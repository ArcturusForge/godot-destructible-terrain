extends Node

var _collision_shape = preload("res://addons/2d_terrain_carving/Prefabs/collision_polygon.tscn")
var _quadrant = preload("res://addons/2d_terrain_carving/Prefabs/quadrant.tscn")
var _terrain = preload("res://addons/2d_terrain_carving/Prefabs/carving_terrain_node.tscn")

#--- Returns an instatiated terrain node
func create_terrain()->Node2D:
	return _terrain.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	
