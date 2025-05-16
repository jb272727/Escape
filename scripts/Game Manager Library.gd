extends Node3D

var scene_tree = null
var blur_amt := 1.0

@onready var entry_camera = $"../Cameras/Entry Camera"
@export var camera : Camera3D = entry_camera

@onready var arena = $"../Arena Wrapper/Arena"
@onready var chess_clock = $"../Arena Wrapper/Chess Clock"
@onready var enemy_clock : Label3D = $"../Arena Wrapper/Chess Clock/Enemy Clock"
@onready var player_clock : Label3D = $"../Arena Wrapper/Chess Clock/Player Clock"
@onready var clicker = $"../Arena Wrapper/Chess Clock/chess_clock/clicker"
@onready var clock_body = $"../Arena Wrapper/Chess Clock/StaticBody3D"
@export var playing_time_minutes : int = 1
var clicker_rotation_z : float = 6.0

@export var game_started : bool = false
var enemy_time : float
var player_time : float
var local_can_click : bool = true
@export var moved_piece : bool = false

var players_turn : bool = true

var current_object : StaticBody3D
var back_cursor : Texture2D
var forward_cursor : Texture2D
var left_cursor : Texture2D
var right_cursor : Texture2D
var hand_cursor : Texture2D
var grab_cursor : Texture2D
var menuing : AudioStreamWAV
@onready var audio_player = $"../AudioStreamPlayer3D"

signal click_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = entry_camera
	back_cursor = preload("res://assets/usuable/back.png") as Texture2D
	right_cursor = preload("res://assets/usuable/right.png") as Texture2D
	left_cursor = preload("res://assets/usuable/right2.png") as Texture2D
	forward_cursor = preload("res://assets/usuable/forward.png") as Texture2D
	hand_cursor = preload("res://assets/usuable/hand2.png") as Texture2D
	grab_cursor = preload("res://assets/usuable/grab.png") as Texture2D
	menuing = preload("res://assets/usuable/menuing.wav") as AudioStreamWAV
	
	clicker.rotation_degrees = Vector3(0.0, 0.0, -clicker_rotation_z) # - is players turn, + is enemies turn
	enemy_time = playing_time_minutes * 60
	player_time = playing_time_minutes * 60
	enemy_clock.text = str(playing_time_minutes) + ":00"
	player_clock.text = str(playing_time_minutes) + ":00"



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
	else:
		current_object = null
	#print(current_object)
	#if !current_object:
		#pass
		#if active_scene:
			#active_scene.set_curso r_type(current_object) # use the set_cursor_type for the active scene
	#print(result)
	if game_started:
		if local_can_click == false:
			enemy_time -= 1.0 * delta
			update_clock(false)
		else:
			player_time -= 1.0 * delta
			update_clock(true)
		if player_time <= 0.0:
			print("Opponent wins")
			clicker.rotation_degrees.z = 0.0
			game_started = false
			reset_game()
		if enemy_time <= 0.0:
			clicker.rotation_degrees.z = 0.0
			print("Player wins")
			game_started = false
			reset_game()

func reset_game() -> void:
	pass

func get_current_object() -> StaticBody3D:
	return current_object

func update_clock(updating_player : bool) -> void:
	if updating_player:
		var player_minutes : int = clamp((int(player_time) / 60), 0.0, INF)
		var player_modulo : int = clamp((int(player_time) % 60), 0.0, INF)
		var mod_txt : String = str(player_modulo)
		if player_modulo < 10:
			mod_txt = "0" + mod_txt
		player_clock.text = str(player_minutes) + ":" + str(mod_txt)
	else:
		var enemy_minutes : int = clamp((int(enemy_time) / 60), 0.0, INF)
		var enemy_modulo : int = clamp((int(enemy_time) % 60), 0.0, INF)
		var mod_txt : String = str(enemy_modulo)
		if enemy_modulo < 10:
			mod_txt = "0" + mod_txt
		enemy_clock.text = str(enemy_minutes) + ":" + str(mod_txt)


func _input(event):
	# @TODO: disallow clicks when player hasn't moved a piece
	if Input.is_action_just_pressed("lmb"):
		if get_current_object() == clock_body and not moved_piece:
			print("cannot go next turn until moved a piece")
			return
		elif get_current_object() == clock_body:
			arena.can_click = false
			local_can_click = false
			clicker.rotation_degrees.z = clicker_rotation_z
			if not game_started:
				game_started = true
			
			
			print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! emitting player clicked signal")
			
			emit_signal("click_signal")


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

func _on_agent_start_player_clock():
	print("start player clock")
	clicker.rotation_degrees.z = -clicker_rotation_z
	arena.is_picked = false
	arena.selected_coords = [null,null]
	arena.selected_piece = null
	arena.clear_checker_movesets()
	arena.can_click = true
	local_can_click = true
	
