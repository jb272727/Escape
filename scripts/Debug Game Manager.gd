extends Node3D

#var scene_tree = null
#var blur_amt := 1.0
#var fading := false
#var cameras := []
@onready var camera = $"hanoi cam"
#var neighbor_scenes : Dictionary = {}
var current_object : StaticBody3D
var hit_object : StaticBody3D
#var back_cursor : Texture2D
#var forward_cursor : Texture2D
#var left_cursor : Texture2D
#var right_cursor : Texture2D
#var hand_cursor : Texture2D
#var grab_cursor : Texture2D
#@onready var active_scene = $"../map/Main Scene".get_path()
#var menuing : AudioStreamWAV
#@onready var audio_player = $"../AudioStreamPlayer3D"
#var fade_out : ShaderMaterial
#@export var debug: bool
# Called when the node enters the scene tree for the first time.

# Exclusive Hanoi Code
@onready var green_static_body = $"green/green static body"
@onready var blue_static_body = $blue/StaticBody3D
@onready var unsure_static_body = $unsure/StaticBody3D
@onready var yellow_static_body = $yellow/StaticBody3D
@onready var red_static_body = $red/StaticBody3D
@onready var green = $green
@onready var blue = $blue
@onready var unsure = $unsure
@onready var yellow = $yellow
@onready var red = $red
@onready var hanoi_tower1 = $"hanoi-tower/Cylinder_001/StaticBody3D"
@onready var hanoi_tower2 = $"hanoi-tower2/Cylinder_001/StaticBody3D"
@onready var hanoi_tower3 = $"hanoi-tower3/Cylinder_001/StaticBody3D"
var current_towers : Array
var piece : MeshInstance3D
var selected : bool = false
var towers : Array
var tower_space_positions_y : Array
@export var y_lvl_selected : float = 0.5


func _ready():
	current_towers = [[green,blue,unsure,yellow,red],[null,null,null,null,null],[null,null,null,null,null]] # 1 = green, 2 = blue ,etc
	towers = [hanoi_tower1, hanoi_tower2, hanoi_tower3]
	tower_space_positions_y = [0.279,0.228,0.173,0.117,0.062]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var mousePos = get_viewport().get_mouse_position()
	#var rayLength = 100
	#var from = camera.project_ray_origin(mousePos)
	#var to = from + camera.project_ray_normal(mousePos) * rayLength
	#var space = get_world_3d().direct_space_state
	#var rayQuery = PhysicsRayQueryParameters3D.new()
	#rayQuery.from = from
	#rayQuery.to = to
	#rayQuery.collide_with_areas = true
	#rayQuery.collide_with_bodies = true  # Make sure to also collide with bodies if needed
#
	#var result = space.intersect_ray(rayQuery)
	#if result:
		#current_object = result.collider
		##if active_scene:
			##active_scene.set_cursor_type(current_object) # use the set_cursor_type for the active scene
	##print(result)
	#if !current_object:
		
	hanoi_process(delta)
	
	

func get_current_object() -> StaticBody3D:
	return current_object
	
# If selected, make sure selected is at the top of a tower, make sure we are hovering if selected, make sure the spot it was in is now null
# make sure the spot its placed in is no longer null and we are no longer in selected
func hanoi_process(delta):
	if selected == true:
		if get_current_object() in towers:
			piece.global_position.x = get_current_object().global_position.x

func _input(event):
	if Input.is_action_just_pressed("lmb"):
		hit_object = current_object
		print(hit_object)
		if selected == true:
			var new_pos : float
			var count : int = 0
			match hit_object:
				hanoi_tower1:
					for i in range(5):
						if current_towers[0][i] != null:
							count += 1
					if count == 5:
						pass
					if 4 - count + 1 < 5:   # make sure this calc does null pointer exception
						var result = false
						result = compare(piece, current_towers[0][4 - count + 1])
						if result:
							pass
						else:
							piece.position.y = tower_space_positions_y[4 - count]
							current_towers[0][4 - count] = piece
							set_hitboxes_up()
							selected = false
					elif 4 - count + 1 == 5:
						piece.position.y = tower_space_positions_y[4 - count]
						current_towers[0][4 - count] = piece
						set_hitboxes_up()
						selected = false
				hanoi_tower2:
					for i in range(5):
						if current_towers[1][i] != null:
							count += 1
					if count == 5:
						pass
					if 4 - count + 1 < 5:   # make sure this calc does null pointer exception
						var result = false
						result = compare(piece, current_towers[1][4 - count + 1])  # is piece fatter than the one below it
						if result:
							pass
						else:
							piece.position.y = tower_space_positions_y[4 - count]
							current_towers[1][4 - count] = piece
							set_hitboxes_up()
							selected = false
					elif 4 - count + 1 == 5:
						piece.position.y = tower_space_positions_y[4 - count]
						current_towers[1][4 - count] = piece
						set_hitboxes_up()
						selected = false
				hanoi_tower3:
					for i in range(5):
						if current_towers[2][i] != null:
							count += 1
					if count == 5:
						pass
					if 4 - count + 1 < 5:   # make sure this calc does null pointer exception
						var result = false
						result = compare(piece, current_towers[2][4 - count + 1])
						if result:
							pass
						else:
							piece.position.y = tower_space_positions_y[4 - count]
							current_towers[2][4 - count] = piece
							set_hitboxes_up()
							selected = false
					elif 4 - count + 1 == 5:
						piece.position.y = tower_space_positions_y[4 - count]
						current_towers[2][4 - count] = piece
						set_hitboxes_up()
						selected = false
			print(current_towers)
		elif selected == false:
			match hit_object:
				green_static_body:
					var result = set_piece_if_top(green)
					if !result:
						pass
				blue_static_body:
					var result = set_piece_if_top(blue)
					if !result:
						pass
				unsure_static_body:
					var result = set_piece_if_top(unsure)
					if !result:
						pass
				yellow_static_body:
					var result = set_piece_if_top(yellow)
					if !result:
						pass
				red_static_body:
					var result = set_piece_if_top(red)
					if !result:
						pass

func set_hitboxes_down():
	hanoi_tower1.position.y = hanoi_tower1.position.y + 6.0
	hanoi_tower2.position.y = hanoi_tower2.position.y + 6.0
	hanoi_tower3.position.y = hanoi_tower3.position.y + 6.0

func set_hitboxes_up():
	hanoi_tower1.position.y = hanoi_tower1.position.y - 6.0
	hanoi_tower2.position.y = hanoi_tower2.position.y - 6.0
	hanoi_tower3.position.y = hanoi_tower3.position.y - 6.0
	
func compare(color1 : MeshInstance3D, color2 : MeshInstance3D) -> bool: 	# is color1 > (fatter than) color2
	print("color1 " + str(color1))
	print("color2 " + str(color2))
	if color1 == red:
		return true
	elif color1 == yellow and color2 != red:
		return true
	elif color1 == unsure and color2 != yellow and color2 != red:
		return true
	elif color1 == blue and color2 != yellow and color2 != red and color2 != unsure:
		return true
	else:
		return false
		
func set_piece_if_top(potential_piece : MeshInstance3D) -> bool:
	var i := 0
	var j := 0
	var found := false
	while i < 3:
		j = 0
		found = false
		while j < 5:
			if current_towers[i][j] == null:
				j += 1
				continue
			elif current_towers[i][j] != potential_piece:
				break
			elif current_towers[i][j] == potential_piece:
				found = true
				break
			j += 1
		if found == true:
			break
		i += 1
	if found:
		current_towers[i][j] = null
		selected = true
		piece = potential_piece
		piece.position.y = y_lvl_selected
		set_hitboxes_down()
		return true
	return false
