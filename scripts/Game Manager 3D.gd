extends Node3D

var scene_tree = null
var blur_amt := 1.0

@onready var main_camera : Camera3D = $"../Cameras/Main Camera"
@export var camera : Camera3D = main_camera

var current_object : StaticBody3D
var back_cursor : Texture2D
var forward_cursor : Texture2D
var left_cursor : Texture2D
var right_cursor : Texture2D
var hand_cursor : Texture2D
var grab_cursor : Texture2D
var menuing : AudioStreamWAV
@onready var audio_player = $"../AudioStreamPlayer3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = main_camera
	back_cursor = preload("res://assets/usuable/back.png") as Texture2D
	right_cursor = preload("res://assets/usuable/right.png") as Texture2D
	left_cursor = preload("res://assets/usuable/right2.png") as Texture2D
	forward_cursor = preload("res://assets/usuable/forward.png") as Texture2D
	hand_cursor = preload("res://assets/usuable/hand2.png") as Texture2D
	grab_cursor = preload("res://assets/usuable/grab.png") as Texture2D
	menuing = preload("res://assets/usuable/menuing.wav") as AudioStreamWAV



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
		if result.collider is StaticBody3D:
			current_object = result.collider
	if !current_object:
		pass
		#if active_scene:
			#active_scene.set_cursor_type(current_object) # use the set_cursor_type for the active scene
	#print(result)
	if !current_object:
		pass

func get_current_object() -> StaticBody3D:
	return current_object
	

func play_audio(sound : String):
	if sound == "menuing":
		audio_player.stream = menuing
		audio_player.play()

#func set_cursor_type(object : CollisionObject3D):
	#if object in neighbor_scenes:
		#if object == chess_board:
			#Input.set_custom_mouse_cursor(%"Game Manager 3D".back_cursor, Input.CURSOR_ARROW)
			#return 0
	#else:
		#Input.set_custom_mouse_cursor(%"Game Manager 3D".right_cursor, Input.CURSOR_ARROW)
		#return 0

