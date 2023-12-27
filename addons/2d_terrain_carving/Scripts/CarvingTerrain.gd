@tool
extends Node2D

@export_category("Config")
@export var quadrant_size :int = 100
@export var quadrant_grid_size := Vector2(10,5)

@export_category("Debug")
@export var draw_preview := true
@export var line_thickness :int = 1

var quadrant_parent:Node2D = self
var quadrants_grid: Array = []

func _draw():
	if Engine.is_editor_hint() && draw_preview:
		for x in range(quadrant_grid_size.x):
			for y in range(quadrant_grid_size.y):
				draw_line(Vector2(1*x,0), Vector2((quadrant_size*x)+quadrant_size,0), Color.AQUAMARINE, line_thickness)
				draw_line(Vector2(0,1*y), Vector2(0,(quadrant_size*y)+quadrant_size), Color.AQUAMARINE, line_thickness)
				draw_line(Vector2((quadrant_size*x)+quadrant_size,0), Vector2((quadrant_size*x)+quadrant_size,(quadrant_size*y)+quadrant_size), Color.AQUAMARINE, line_thickness)
				draw_line(Vector2(0,(quadrant_size*y)+quadrant_size), Vector2((quadrant_size*x)+quadrant_size,(quadrant_size*y)+quadrant_size), Color.AQUAMARINE, line_thickness)
		
	

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
	

func generate_terrain(q_size=quadrant_size, q_grid_size=quadrant_grid_size):
	quadrant_size = q_size
	quadrant_grid_size = quadrant_grid_size
	_spawn_quadrants()
	

func _spawn_quadrants():
	for i in range(quadrant_grid_size.x):
		quadrants_grid.push_back([])
		for j in range(quadrant_grid_size.y):
			var quadrant = CarvingTerrain._quadrant.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			quadrant.default_quadrant_polygon = [
				Vector2(quadrant_size*i,quadrant_size*j),
				Vector2(quadrant_size*(i+1),quadrant_size*j),
				Vector2(quadrant_size*(i+1),quadrant_size*(j+1)),
				Vector2(quadrant_size*i,quadrant_size*(j+1))
			]
			quadrants_grid[-1].push_back(quadrant)
			quadrant_parent.add_child(quadrant)
	

func _get_affected_quadrants(pos, carve_radius):
	"""
	Returns array of Quadrants that are affected by
	the carving. Not the best function: sometimes it
	returns some quadrants that are not affected
	"""
	var affected_quadrants = []
	var half_diag = sqrt(2)*quadrant_size/2
	for quadrant in quadrant_parent.get_children():
		var quadrant_top_left = quadrant.default_quadrant_polygon[0]
		var quadrant_center = quadrant_top_left + Vector2(quadrant_size, quadrant_size)/2
		if quadrant_center.distance_to(pos) <= carve_radius + half_diag:
			affected_quadrants.push_back(quadrant)
	return affected_quadrants
	

func carve(position, carveArea:Polygon2D, carveRadius:int):
	var carve_polygon = Transform2D(0, position) * carveArea.polygon
	var four_quadrants = _get_affected_quadrants(position, carveRadius)
	for quadrant in four_quadrants:
		quadrant.carve(carve_polygon)
	

func add(position, carveArea:Polygon2D, carveRadius:int):
	var add_polygon = Transform2D(0, position) * carveArea.polygon
	var four_quadrants = _get_affected_quadrants(position, carveRadius)
	for quadrant in four_quadrants:
		quadrant.add(add_polygon)
	
