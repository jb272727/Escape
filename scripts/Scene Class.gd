# AreaManager.gd
extends Node3D
class_name Area

# References to neighbor areas using StaticBody3D as keys and Node3D as values
var neighbor_scenes: Dictionary = {}

# Reference to this area's camera
var camera: Camera3D

func _ready():
	$"map/Main Scene".activate_camera()

# Called when the player clicks a collision box (StaticBody3D) to move to a neighboring area
func move_to_scene(static_body : StaticBody3D):
	if %"Game Manager 3D".neighbor_scenes.has(static_body):
		var target_scene = %"Game Manager 3D".neighbor_scenes[static_body]
		print("Moving to area: " + target_scene.name)
		
		%"Game Manager 3D".fade_start()
		camera.current = false
		target_scene.activate_camera()
	else:
		print("Area not found for the clicked collision shape")

# Adds a new neighbor area reference with a StaticBody3D as key
func add_neighbor(static_body : StaticBody3D, scene_ref : Node3D):
	neighbor_scenes[static_body] = scene_ref
	
func remove_neighbor(static_body : StaticBody3D):
	neighbor_scenes.erase(static_body)

func activate_camera():
	%"Game Manager 3D".active_scene = get_path()
	if camera:
		#remove visibility of old transitioners staticbodies
		for scene in %"Game Manager 3D".neighbor_scenes:
			scene.set_collision_layer_value(1, false)
		%"Game Manager 3D".neighbor_scenes = neighbor_scenes
		for scene in %"Game Manager 3D".neighbor_scenes:
			scene.set_collision_layer_value(1, true)
		%"Game Manager 3D".camera = camera
		camera.current = true
		print("Activated camera for this area")
		
		# Make all neighbor CollisionShape3D visible

func set_cursor_type(object : CollisionObject3D):
	push_error("set_cursor_type() must be implemented in subclass!")
