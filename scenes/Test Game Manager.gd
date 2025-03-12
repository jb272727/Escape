extends Node3D

@export var camera : Camera3D
@export var current_object : StaticBody3D

@onready var cameras = $"../Cameras"
@onready var a_camera = $"../Cameras/A Camera"
@onready var b_camera = $"../Cameras/B Camera"

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = a_camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	var rayLength = 100
	var from = camera.project_ray_origin(mousePos)
	var to = from + camera.project_ray_normal(mousePos) * rayLength
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayQuery.collide_with_areas = true
	rayQuery.collide_with_bodies = true  # Make sure to also collide with bodies if needed

	var result = space.intersect_ray(rayQuery)
	if result:
		print(current_object)
		current_object = result.collider
	if !current_object:
		pass
