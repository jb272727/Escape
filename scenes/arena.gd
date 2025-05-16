extends Node3D

@onready var positions_to_move_to = $"Arena To Scale/Positions To Move To"
#@onready var chess_clock = $"../Chess Clock"
#@onready var enemy_clock : Label3D = $"../Chess Clock/chess_clock/Enemy Clock"
#@onready var player_clock : Label3D = $"../Chess Clock/chess_clock/Player Clock"
#@onready var enemy_timer : Label3D = $"../Chess Clock/chess_clock/Enemy Clock/Timer"
#@onready var player_timer : Label3D = $"../Chess Clock/chess_clock/Player Clock/Timer"
#@onready var clicker = $"../Chess Clock/chess_clock/clicker"
#@export var playing_time_minutes : int = 5
#var clicker_rotation_z : float = 6.0
#
#var players_turn : bool = true

@onready var playing_camera = $"Arena To Scale/Arena Cameras/Playing Camera"
var current_object : StaticBody3D
var hit_object : StaticBody3D
#var coords : Array
#var result : Node3D
@onready var friendly = $Pieces/Friendly

var blue_mat = preload("res://blue_marble.tres")
var red_mat = preload("res://red_marble.tres")

var friendly_pieces : Array
var enemy_pieces : Array
var friendly_lineup : Array[Piece]
var enemy_lineup : Array[Piece]
@export var camera : Camera3D
@export var in_scene : bool = false
@export var example_model_scene : PackedScene = preload("res://scenes/ankh.tscn")
@export var checker_moveset_scene : PackedScene = preload("res://scenes/checker_moveset.tscn")
@export var checker_opponent_moveset_scene : PackedScene = preload("res://scenes/checker_opponent_moveset.tscn")


# @TODO load all possible piece scripts here
const ExamplePiece = preload("res://scripts/Piece Scripts/example_piece.gd")
const AnkhPiece = preload("res://scripts/Piece Scripts/ankh_piece.gd")
const ArtifactPiece = preload("res://scripts/Piece Scripts/artifact_piece.gd")
const DiamondPiece = preload("res://scripts/Piece Scripts/diamond_piece.gd")
const JupiterPiece = preload("res://scripts/Piece Scripts/jupiter_piece.gd")
const MechanicalEyePiece = preload("res://scripts/Piece Scripts/mechanical_eye_piece.gd")
const PyramidPiece = preload("res://scripts/Piece Scripts/pyramid_piece.gd")
const SaviorPiece = preload("res://scripts/Piece Scripts/savior_piece.gd")
const ToriiPiece = preload("res://scripts/Piece Scripts/torii_piece.gd")

var board_representation : BoardState
var board_size : int = 5
var board_buffer : int = 2
@export var board_total : int = board_size + (2*board_buffer)

var selected_piece : Node3D = null
var selected_coords : Array = [null,null]
var is_picked : bool = false
@export var can_click : bool = true
@export var can_select : bool = true

signal player_turn_ended
signal arena_ready
signal start_enemy_clock
signal start_player_clock

func _ready():
	camera = playing_camera
	#playing_camera.transform = self.transform
	## Vector3(-1.413, 1.304, 0.75)
	#playing_camera.position = playing_camera.position + Vector3(-1.413, 1.304, 0.75)
	print(playing_camera.position)
	for i in range(board_size + (board_buffer*2)): # Max board size of 7x7, board_size + board_buffer = 5 + 2 = 7
		var row := []
		for j in range(board_size + (board_buffer*2)):
			row.append(null)
	friendly_pieces.append("AnkhPiece")
	friendly_pieces.append("JupiterPiece")
	friendly_pieces.append("SaviorPiece")
	friendly_pieces.append("ArtifactPiece")
	friendly_pieces.append("DiamondPiece")
	
	enemy_pieces.append("PyramidPiece")
	enemy_pieces.append("MechanicalEyePiece")
	enemy_pieces.append("ToriiPiece")
	enemy_pieces.append("SaviorPiece")
	enemy_pieces.append("ArtifactPiece")
	# @TODO initialize each piece to play in the game like:
	#var pawn_instance = pawn_scene.instantiate() as PawnPiece
	#add_child(pawn_instance)
	#pawn_instance.model_scene = preload("res://path/to/pawn_model.tscn")  # assign the model scene
	#pawn_instance.initialize_piece(positions_to_move_to.get_child(0).get_child(0).position)
	#pawn_instance.compute_moves(pawn_instance.current_pos)

	add_friendly_pieces()
	add_enemy_pieces()
	print_board()
	
	#clicker.rotation_degrees = Vector3(0.0, 0.0, -clicker_rotation_z) # - is players turn, + is enemies turn
	#playing_time_minutes
	#enemy_clock.text = str(playing_time_minutes) + ":00"
	#player_clock.text = str(playing_time_minutes) + ":00"
	
	emit_signal("arena_ready")
	
	#var example_piece_instance = Node3D.new()
	#example_piece_instance.instantiate() as ExamplePiece
	#friendly.add_child(example_piece_instance)
	#example_piece_instance.initialize_piece(positions_to_move_to.get_child(0).get_child(0).global_position)
	#example_piece_instance.compute_moves(example_piece_instance.current_pos)


func _process(delta):
	#if players_turn:
		#update_player_clock()
	#else:
		#updating_enemy_clock()
	if not in_scene:
		var mousePos = get_viewport().get_mouse_position()
		#print(mousePos)
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
			if result is StaticBody3D:
				current_object = result.collider
		if !current_object:
			pass


func get_current_object() -> StaticBody3D:
	return current_object


func _input(event):
	if Input.is_action_just_pressed("lmb"):
		if not in_scene:
			input_not_in_scene()
			return
		
		#if not can_click: return
		hit_object = %"Game Manager Library".get_current_object()
		if hit_object == null: return
		if hit_object.get_collision_layer() == 3: return
		var coords = get_coords(hit_object)
		if coords == null: return
		
		var result = get_piece_at_coords(coords)
		
		if is_picked == false and result != null:
			clear_checker_movesets()
			
			if result == null: return
			if is_enemy_piece(result):
				display_valid_enemy_moves(result, coords)
			else:
				selected_piece = result
				selected_coords = coords
				display_valid_moves(selected_piece, selected_coords)
				is_picked = true
			
		elif is_picked == true:
			var moveset = selected_piece.compute_moves(selected_coords)
			if moveset != null:
				for move in moveset:
					if coords == move:
						print("Attempting the moving of " + str(selected_piece) + " to " + str(coords) + " from " + str(selected_coords))
						var moving_result : bool = false
						if is_enemy_piece(result):
							if not can_click: return
							var test_piece_existence = get_piece_at_coords(selected_coords)
							if test_piece_existence == null: return
							moving_result = move_piece(selected_coords, coords, selected_piece, true)
							clear_checker_movesets()
							is_picked = false
							can_click = false
							emit_signal("player_turn_ended")
							return
						else:
							var test_piece_existence = get_piece_at_coords(selected_coords)
							if test_piece_existence == null: return
							moving_result = move_piece(selected_coords, coords, selected_piece, false)
							if moving_result == false and not is_enemy_piece(result):     # If the result matches, but we should be switching to a different piece if its friendly, select that piece
								if not can_click: return
								selected_coords = coords
								selected_piece = result
								clear_checker_movesets()
								display_valid_moves(selected_piece, selected_coords)
								return
							elif is_enemy_piece(result):
								clear_checker_movesets()
								display_valid_enemy_moves(selected_piece, selected_coords)
								#take_piece(selected_coords, coords, selected_piece)
								return
							else: # movement to non-enemy square should succeed
								clear_checker_movesets()
								is_picked = false
								can_click = false
								emit_signal("player_turn_ended")
								return

				# We found no move which matched with the clicked tile
			if result != null and not is_enemy_piece(result):
				selected_coords = coords
				selected_piece = result
				clear_checker_movesets()
				display_valid_moves(selected_piece, selected_coords)
				return
			elif result != null and is_enemy_piece(result):
				clear_checker_movesets()
				display_valid_enemy_moves(result, coords)
				return
			else:
				clear_checker_movesets()
				is_picked = false
				selected_coords = [null,null]
				selected_piece = null

func move_piece(from : Array, to : Array, piece : Node3D, ai : bool):
	if not can_click and ai == false: return false
	var from_node = positions_to_move_to.get_child(from[0] + 1).get_child(from[1] + 1).get_child(1)
	print(from_node.name)
	var to_node = positions_to_move_to.get_child(to[0] + 1).get_child(to[1] + 1).get_child(1)
	#print(to_node.name)
	var to_node_parent = positions_to_move_to.get_child(to[0] + 1).get_child(to[1] + 1)
	assert(from_node != null, "From node should never be null")
	if to_node != null:
		if not ai:
			return false
		else:
			to_node_parent.remove_child(to_node)
			piece.reparent(to_node_parent)
			piece.global_position = to_node_parent.global_position
			return false
	else:
		# Do dropping animation!!!!!!!!!!!!!
		#
		piece.reparent(to_node_parent)
		piece.global_position = to_node_parent.global_position
		return true
		

func display_move(move : Array, row_node : Node3D, pos_node : Node3D, is_enemy : bool) -> void:
	var pos = pos_node.position
	var moveset_scene_instance
	if not is_enemy:
		moveset_scene_instance = checker_moveset_scene.instantiate()
	else:
		moveset_scene_instance = checker_opponent_moveset_scene.instantiate()
	
	moveset_scene_instance.position = pos
	positions_to_move_to.add_child(moveset_scene_instance, true)
	moveset_scene_instance.position.x += row_node.position.x

func display_valid_moves(piece : Node3D, position : Array) -> void:
	var moves = piece.compute_moves(position)
	for move in moves:
		if !within_bounds(move):
			continue
		var row_node = positions_to_move_to.get_child(move[0] + 1)
		var pos_node = row_node.get_child(move[1] + 1)
		
		if pos_node.visible == false:
			continue
		if pos_node.get_child_count() <= 1:  # if > 1 there's already a piece there.
			display_move(move, row_node, pos_node, false)
		elif is_enemy_piece(pos_node.get_child(1)):
			display_move(move, row_node, pos_node, false)
		else:
			print("Theres already friendly piece at ", pos_node)

func display_valid_enemy_moves(piece : Node3D, position : Array) -> void:
	var moves = piece.enemy_compute_moves(position) 
	for move in moves:
		if !within_bounds(move):
			continue
		var row_node = positions_to_move_to.get_child(move[0] + 1)
		var pos_node = row_node.get_child(move[1] + 1)
		
		if pos_node.visible == false:
			continue
		if pos_node.get_child_count() <= 1:  # if > 1 there's already a piece there.
			display_move(move, row_node, pos_node, true)
		elif is_enemy_piece(pos_node.get_child(1)):
			print("Theres already an enemy piece at ", pos_node)
		else:
			display_move(move, row_node, pos_node, true)
			

func within_bounds(move : Array) -> bool:
	if move[0] > board_size + board_buffer or move[0] < 1 - board_buffer:    # >7 or <-1
		return false
	if move[1] > board_size + board_buffer or move[1] < 1 - board_buffer:    # >7 or <-1
		return false
	return true

func clear_checker_movesets():
	var count = 0
	while positions_to_move_to.get_child_count() > board_total:
		var moveset_child = positions_to_move_to.get_child(positions_to_move_to.get_child_count() - 1)
		positions_to_move_to.remove_child(moveset_child)
		count += 1


func compute_valid_moves(piece : Node3D, position : Array):
	pass


func print_board():
	for i in range(8, -1, -1):
		var line_output : String = ""
		for j in range(0, 9):
			line_output += str(positions_to_move_to.get_child(i).get_child(j).get_child(1)) + " "
		print(line_output)

func get_piece_at_coords(coords : Array):
	#var node_name = str(coords[0]) + "," + str(coords[1])
	var node_row = positions_to_move_to.get_child(coords[0] + 1)
	var node_col = node_row.get_child(coords[1] + 1)
	#var piece : Node3D
	if len(node_col.get_children()) > 2:
		assert(len(node_col.get_children()) <= 2, "This node should never have more than two children")
	else:
		return node_col.get_child(1)    # We should always add the child as the second

func add_friendly_pieces():
	# for piece in friendly pieces: add it like the following, all scripts should already be loaded at top
	#var pyramid_instance = PyramidPiece.new()
	#friendly.add_child(pyramid_instance)
	#assert(pyramid_instance.get_script() == PyramidPiece)
	var size = 0
	for piece in friendly_pieces:
		if size < len(friendly_pieces):
			var script = map_piece(piece)
			enemy_lineup.append(script)
			var instance = script.new() as Node3D
			instance.name = piece
			#friendly.add_child(instance)
			#assert(instance.get_script() == script)
			var row_node = positions_to_move_to.get_child(0 + board_buffer)   # Should be row 1
			var col_node = row_node.get_child(size + board_buffer)
			col_node.add_child(instance)
			assert(instance.get_script() == script)
			
			friendly_lineup.append(instance)
			
			size += 1
		else:
			print("something wrong in adding friendly loop")

func add_enemy_pieces():
	# for piece in friendly pieces: add it like the following, all scripts should already be loaded at top
	#var pyramid_instance = PyramidPiece.new()
	#friendly.add_child(pyramid_instance)
	#assert(pyramid_instance.get_script() == PyramidPiece)
	var size = 0
	for piece in enemy_pieces:
		if size < len(friendly_pieces):
			var script = map_piece(piece)
			enemy_lineup.append(script)
			var instance = script.new() as Node3D
			instance.name = piece + " Enemy"
			var row_node = positions_to_move_to.get_child(board_size - 1 + board_buffer)   # Should be row 1
			var col_node = row_node.get_child(size + board_buffer)
			col_node.add_child(instance)
			assert(instance.get_script() == script)
			
			var inner_inner_node_instance = instance.get_child(0).get_child(0)
			print("INSTANCES: ", instance, inner_inner_node_instance)
			inner_inner_node_instance.rotation.y += 135.0
			
			for child in inner_inner_node_instance.get_children():
				if child is VisualInstance3D:
					if child.material_override == blue_mat:
						child.material_override = red_mat
			
			enemy_lineup.append(instance)
			
			#Make the enemy pieces switch to red marble:
				#1. Unify the blue marble into a material wherever it appears
				#2. Use this func to search for the blue_marble.tres and replace it with red_marble.tres
			#
			#board_representation[2][size + board_buffer] = instance
			size += 1
		else:
			print("something wrong in adding friendly loop")


# GET COORDS FOR USE IN THE SCENE TREE
func get_coords(tile : StaticBody3D):    
	var position_node = ((tile.get_parent()).get_parent()).get_parent()
	if position_node.visible == true:      # Do movement
		var parts = position_node.name.split(",")
		var i = int(parts[0])
		var j = int(parts[1])
		return [i, j]
	else:
		return null


func map_piece(piece_name : String):
	match piece_name:
		"AnkhPiece":
			return AnkhPiece
		"ArtifactPiece":
			return ArtifactPiece
		"DiamondPiece":
			return DiamondPiece
		"ExamplePiece":
			return ExamplePiece
		"JupiterPiece":
			return JupiterPiece
		"MechanicalEyePiece":
			return MechanicalEyePiece
		"PyramidPiece":
			return PyramidPiece
		"SaviorPiece":
			return SaviorPiece
		"ToriiPiece":
			return ToriiPiece
			
		

func is_enemy_piece(piece) -> bool:
	if piece == null:
		return false
	if (piece.name).substr((piece.name).length() - 5, 5) == "Enemy":
		return true
	return false



func input_not_in_scene():
		hit_object = get_current_object()
		if hit_object == null:
			return
		var coords = get_coords(hit_object)
		print("coords ", coords)
		if coords == null:
			print("Tile is not valid")
			return
		var result = get_piece_at_coords(coords)     # result[i] is row and result[j] is column

		# Getting a new piece
		if is_picked == false:
			selected_piece = result
			if selected_piece == null:    
				return
			selected_coords = coords
			display_valid_moves(selected_piece, selected_coords)
			is_picked = true
		else:    # Dropping a piece
			# Can this piece move here?
			var moveset = selected_piece.compute_moves(selected_coords)
			if moveset != null:
				for move in moveset:
					#display_move(move)
					if coords == move:
						print("Moving " + str(selected_piece) + " to " + str(coords) + " from " + str(selected_coords))
						var moving_result = move_piece(selected_coords, coords, selected_piece, true)
						if moving_result == false:     # If the result matches, but we should be switching to a different piece, select that piece
							selected_coords = coords
							selected_piece = result
							clear_checker_movesets()
							display_valid_moves(selected_piece, selected_coords)
							return
						clear_checker_movesets()
						is_picked = false
						return
			# If we selected a tile which cannot be reached, un-select it 
			# | if we selected the tile of a different piece and that wasnt within the moveset, select that piece instead
			if result != null:
				selected_coords = coords
				selected_piece = result
				clear_checker_movesets()
				display_valid_moves(selected_piece, selected_coords)
				return
			else:
				clear_checker_movesets()
				is_picked = false
				selected_coords = [null,null]
				selected_piece = null


func add_friendly_pieces_example():
	# for piece in friendly pieces: add it like the following, all scripts should already be loaded at top
	for piece in friendly_pieces:
		var script = map_piece(piece)
		var instance = script.new()
		friendly.add_child(instance)
		assert(instance.get_script() == script)
	#var ExamplePiece = load("res://example_piece.gd")
	#var example_instance = ExamplePiece.new()
	#friendly.add_child(example_instance)
	#example_instance.set_model_scene(example_model_scene)
	#assert(example_instance.get_script() == ExamplePiece)

#func print_board():
	#for i in range(board_size + (board_buffer*2) - 1, -1, -1):
		#print(board_representation[i])
