extends Node2D

@export_category("Demo")
@export var use_circle_brush:bool=false

@export_category("Carving Vars")
@export var carve_radius :int = 40
@export var min_movement_update :int = 5

@export_category("Scene Nodes")
@export var carve_area :Polygon2D
@export var rigidbody_parent:Node2D
@export var terrain:Node2D

@export_category("prefabs")
@export var rb_ball : PackedScene

var old_mouse_pos: Vector2 = Vector2()
var mouse_pos: Vector2 = Vector2()

func _ready():
	terrain.generate_terrain()
	if use_circle_brush:
		_make_mouse_circle()

func _make_mouse_circle():
	var nb_points = 15
	var pol = []
	for i in range(nb_points):
		var angle = lerp(-PI, PI, float(i)/nb_points)
		pol.push_back(mouse_pos + Vector2(cos(angle), sin(angle)) * carve_radius)
	carve_area.polygon = pol

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_global_mouse_position()
		carve_area.position = mouse_pos
		queue_redraw()

func _process(_delta):
	if Input.is_action_pressed("click_left"):
		if old_mouse_pos.distance_to(mouse_pos) > min_movement_update:
			terrain.carve(mouse_pos, carve_area, carve_radius)
			old_mouse_pos = mouse_pos
	
	elif Input.is_action_pressed("click_right"):
		if old_mouse_pos.distance_to(mouse_pos) > min_movement_update:
			terrain.add(mouse_pos, carve_area, carve_radius)
			old_mouse_pos = mouse_pos
	
	if Input.is_action_pressed("ui_accept"):
		var rigid = rb_ball.instantiate()
		rigid.position = get_global_mouse_position() + Vector2(randi()%10,0)
		$RigidBodies.add_child(rigid)
