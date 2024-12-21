extends Node3D

var scene_tree = null
var blur_amt := 1.0
var fading := false
var cameras := []
@onready var camera = $"../map/Main Scene/Main cam"
var neighbor_scenes : Dictionary = {}
var current_object : StaticBody3D
var back_cursor : Texture2D
var forward_cursor : Texture2D
var left_cursor : Texture2D
var right_cursor : Texture2D
var hand_cursor : Texture2D
var grab_cursor : Texture2D
@onready var active_scene = $"../map/Main Scene".get_path()
var menuing : AudioStreamWAV
@onready var audio_player = $"../AudioStreamPlayer3D"
var fade_out : ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready():
	neighbor_scenes = $"../map/Main Scene".neighbor_scenes
	# Load your custom cursor image
	back_cursor = preload("res://assets/usuable/back.png") as Texture2D
	right_cursor = preload("res://assets/usuable/right.png") as Texture2D
	left_cursor = preload("res://assets/usuable/right2.png") as Texture2D
	forward_cursor = preload("res://assets/usuable/forward.png") as Texture2D
	hand_cursor = preload("res://assets/usuable/hand2.png") as Texture2D
	grab_cursor = preload("res://assets/usuable/grab.png") as Texture2D
	menuing = preload("res://assets/usuable/menuing.wav") as AudioStreamWAV
	fade_out = load("res://assets/usuable/FADE OUT.tres") as ShaderMaterial
	
	## Define the hotspot position (optional, default is top-left corner)
	#var hotspot = Vector2(cursor_texture.get_width() / 2, cursor_texture.get_height() / 2)  # Center the cursor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading:
		fade_out = load("res://assets/usuable/FADE OUT.tres") as ShaderMaterial
		fade_transition()
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
		current_object = result.collider
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

func fade_start():
	fading = true
	fade_out.set_shader_parameter("shader_parameter/blur_inner", 1)
	fade_out.set_shader_parameter("shader_parameter/blur_outer", 1)

func fade_transition():
	blur_amt = lerp(blur_amt, 0.0, 0.05)
	fade_out.set_shader_parameter("shader_parameter/blur_inner", blur_amt)
	fade_out.set_shader_parameter("shader_parameter/blur_outer", blur_amt)
	
	print(fade_out.get_shader_parameter("shader_parameter/blur_outer"))
	if blur_amt < 0.01:
		fading = false
