extends Area

@onready var horse_collider = $board/horse_white/Caballo_001/HORSE
@onready var horse_white = $board/horse_white
@onready var pawn_collider = $board/pawn_white/Peon_005/HORSE
@onready var pawn_white = $board/pawn_white
@onready var bishop_collider = $board/bishop_white/Alfil_001/HORSE
@onready var bishop_white = $board/bishop_white
@onready var rook_collider = $board/rook_white/Torre_001/HORSE
@onready var rook_white = $board/rook_white

@onready var world_bottom = $"../walls/world bottom"

var hit_body : StaticBody3D
var state : String = ""
var board := []
var board_current := []
var empty_matrix := []
var picked_collider : StaticBody3D
var chess_colliders := []

# Called when the node enters the scene tree for the first time.
func _ready():
	chess_colliders = [horse_collider, rook_collider, pawn_collider, bishop_collider]
	var row = 0
	for rows in $"board/Position Markers".get_children():
		var arr = []
		var arr2 = []
		var arr3 = []
		board.append(arr)
		board_current.append(arr2)
		empty_matrix.append(arr3)
		for item in rows.get_children():
			board[row].append(item)
			board_current[row].append(false)
			empty_matrix[row].append(false)
		row += 1
	
	board_current[0][2] = "rook"
	board_current[1][4] = "pawn"
	board_current[2][0] = "horse"
	board_current[3][2] = "bishop"
	print(board)
	print("----------------------------")
	print(board_current)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#current_object = %"Game Manager 3D".get_current_object()
	#if str(%"Game Manager 3D".active_scene) == str(get_path()):
		#set_cursor_type(current_object)
	#print(current_object)
	pass

func _input(event):
	if Input.is_action_just_pressed("lmb"):
		hit_body = %"Game Manager 3D".get_current_object()
		print(hit_body)
		if state == "":
			picked(hit_body)
		elif state == "picked": # dont update hit_object if we already have something picked
			drop()



func picked(obj : StaticBody3D):
	print("obj: " + str(obj))
	match obj:
		horse_collider:
			%"Game Manager 3D".play_audio("menuing")
			picked_collider = horse_collider
			horse_white.position += Vector3(.0,.3,.0)
			state = "picked"
			#print("horse")
		pawn_collider:
			%"Game Manager 3D".play_audio("menuing")
			picked_collider = pawn_collider
			pawn_white.position += Vector3(.0,.3,.0)
			state = "picked"
		bishop_collider:
			%"Game Manager 3D".play_audio("menuing")
			picked_collider = bishop_collider
			bishop_white.position += Vector3(.0,.3,.0)
			state = "picked"
		rook_collider:
			%"Game Manager 3D".play_audio("menuing")
			picked_collider = rook_collider
			rook_white.position += Vector3(.0,.3,.0)
			state = "picked"
		world_bottom:
			print("world")

func drop():
	var attempted_placement_collider := hit_body
	match picked_collider: 
		horse_collider:
			var valid_spaces
			var computed = computeValidSpaces("horse")
			valid_spaces = computed
			#print(valid_spaces)
			var okay = isValidSpace(attempted_placement_collider, valid_spaces, "horse")
			valid_spaces = getEmptyMatrix()
			#print(okay)
			if okay:
				var positionToMove = attempted_placement_collider.get_parent().global_position
				#attempted_placement_collider.glob
				#print(attempted_placement_collider)
				#print(attempted_placement_collider.get_parent())
				horse_white.global_position.x = positionToMove.x
				horse_white.global_position.z = positionToMove.z
			horse_white.position -= Vector3(.0,.3,.0)
			#print("horse drop")
		pawn_collider:
			var valid_spaces
			var computed = computeValidSpaces("pawn")
			valid_spaces = computed
			#print(valid_spaces)
			#print(board_current)
			var okay = isValidSpace(attempted_placement_collider, valid_spaces, "pawn")
			valid_spaces = getEmptyMatrix()
			#print(board_current)
			#print(okay)
			if okay:
				var positionToMove = attempted_placement_collider.get_parent().global_position
				pawn_white.global_position.x = positionToMove.x
				pawn_white.global_position.z = positionToMove.z
			pawn_white.position -= Vector3(.0,.3,.0)
		bishop_collider:
			var valid_spaces
			var computed = computeValidSpaces("bishop")
			valid_spaces = computed
			var okay = isValidSpace(attempted_placement_collider, valid_spaces, "bishop")
			valid_spaces = getEmptyMatrix()
			if okay:
				var positionToMove = attempted_placement_collider.get_parent().global_position
				bishop_white.global_position.x = positionToMove.x
				bishop_white.global_position.z = positionToMove.z
			bishop_white.position -= Vector3(.0,.3,.0)
		rook_collider:
			var valid_spaces
			var computed = computeValidSpaces("rook")
			valid_spaces = computed
			var okay = isValidSpace(attempted_placement_collider, valid_spaces, "rook")
			valid_spaces = getEmptyMatrix()
			if okay:
				var positionToMove = attempted_placement_collider.get_parent().global_position
				rook_white.global_position.x = positionToMove.x
				rook_white.global_position.z = positionToMove.z
			rook_white.position -= Vector3(.0,.3,.0)
	state = ""
	picked_collider = null
	
	
func computeValidSpaces(type : String) -> Array:
	var ret_matrix = getEmptyMatrix()
	match type:
		"horse":
			for i in range(4):
				for j in range(5):
					if str(board_current[i][j]) == "horse":
						if i-2 >= 0 and i-2 <= 3 and j+1 >= 0 and j+1 <= 4:
							if ret_matrix[i-2][j+1] == false:
								ret_matrix[i-2][j+1] = true
						if i-2 >= 0 and i-2 <= 3 and j-1 >= 0 and j-1 <= 4:
							if ret_matrix[i-2][j-1] == false:
								ret_matrix[i-2][j-1] = true
						if i+2 >= 0 and i+2 <= 3 and j+1 >= 0 and j+1 <= 4:
							if ret_matrix[i+2][j+1] == false:
								ret_matrix[i+2][j+1] = true
						if i+2 >= 0 and i+2 <= 3 and j-1 >= 0 and j-1 <= 4:
							if ret_matrix[i+2][j-1] == false:
								ret_matrix[i+2][j-1] = true
						if i+1 >= 0 and i+1 <= 3 and j-2 >= 0 and j-2 <= 4:
							if ret_matrix[i+1][j-2] == false: ####
								ret_matrix[i+1][j-2] = true
						if i-1 >= 0 and i-1 <= 3 and j-2 >= 0 and j-2 <= 4:
							if ret_matrix[i-1][j-2] == false:
								ret_matrix[i-1][j-2] = true
						if i+1 >= 0 and i+1 <= 3 and j+2 >= 0 and j+2 <= 4:
							if ret_matrix[i+1][j+2] == false:
								ret_matrix[i+1][j+2] = true
						if i-1 >= 0 and i-1 <= 3 and j+2 >= 0 and j+2 <= 4:
							if ret_matrix[i-1][j+2] == false:
								ret_matrix[i-1][j+2] = true
		"rook":
			for i in range(4):
				for j in range(5):
					if str(board_current[i][j]) == "rook":
						for k in range(5):
							if i >= 0 and i <= 3 and j+k >= 0 and j+k <= 4:
								if ret_matrix[i][j+k] == false:
									ret_matrix[i][j+k] = true
							if i >= 0 and i <= 3 and j-k >= 0 and j-k <= 4:
								if ret_matrix[i][j-k] == false:
									ret_matrix[i][j-k] = true
							if i+k >= 0 and i+k <= 3 and j >= 0 and j <= 4:
								if ret_matrix[i+k][j] == false:
									ret_matrix[i+k][j] = true
							if i-k >= 0 and i-k <= 3 and j >= 0 and j <= 4:
								if ret_matrix[i-k][j] == false:
									ret_matrix[i-k][j] = true
		"pawn":
			for i in range(4):
				for j in range(5):
					if str(board_current[i][j]) == "pawn":
						if i+1 >= 0 and i+1 <= 3 and j >= 0 and j <= 4:
							if ret_matrix[i+1][j] == false:
								ret_matrix[i+1][j] = true
						if i-1 >= 0 and i-1 <= 3 and j >= 0 and j <= 4:
							if ret_matrix[i-1][j] == false:
								ret_matrix[i-1][j] = true
						if i >= 0 and i <= 3 and j+1 >= 0 and j+1 <= 4:
							if ret_matrix[i][j+1] == false:
								ret_matrix[i][j+1] = true
						if i >= 0 and i <= 3 and j-1 >= 0 and j-1 <= 4:
							if ret_matrix[i][j-1] == false:
								ret_matrix[i][j-1] = true
		"bishop":
			for i in range(4):
				for j in range(5):
					if str(board_current[i][j]) == "bishop":
						for k in range(5):
							if i+k >= 0 and i+k <= 3 and j+k >= 0 and j+k <= 4:
								if ret_matrix[i+k][j+k] == false:
									ret_matrix[i+k][j+k] = true
							if i+k >= 0 and i+k <= 3 and j-k >= 0 and j-k <= 4:
								if ret_matrix[i+k][j-k] == false:
									ret_matrix[i+k][j-k] = true
							if i-k >= 0 and i-k <= 3 and j+k >= 0 and j+k <= 4:
								if ret_matrix[i-k][j+k] == false:
									ret_matrix[i-k][j+k] = true
							if i-k >= 0 and i-k <= 3 and j-k >= 0 and j-k <= 4:
								if ret_matrix[i-k][j-k] == false:
									ret_matrix[i-k][j-k] = true
	return ret_matrix

func isValidSpace(collider : CollisionObject3D, valids : Array, piece : String) -> bool:
	var remove = false
	var new_piece_row = null
	var new_piece_col = null
	for i in range(4):
		for j in range(5):
			if board[i][j] == collider.get_parent(): #check if space is OK
				if valids[i][j] == true:
					board_current[i][j] = piece
					remove = true
					new_piece_row = i
					new_piece_col = j
	if remove:
		for k in range(4):
			for l in range(5):
				if (str(board_current[k][l]) == piece) and !(new_piece_row == k and new_piece_col == l):
					board_current[k][l] = false
		return true
	return false
	
func getEmptyMatrix() -> Array:
	var matrix = []
	for i in range(4):
		matrix.append([])
		for j in range(5):
			matrix[i].append(false)
	return matrix

#func set_cursor_type(object : CollisionObject3D):
	#if state == "picked":
		## show pick upo hand as cursor
		##print("right cursor:    --  " + str(%"Game Manager 3D".right_cursor))
		#Input.set_custom_mouse_cursor(%"Game Manager 3D".grab_cursor, Input.CURSOR_ARROW)
		#return 0
	#elif object in chess_colliders:
		## show pick upo hand as cursor
		#Input.set_custom_mouse_cursor(%"Game Manager 3D".hand_cursor, Input.CURSOR_ARROW)
		#return 0
	#elif object in neighbor_scenes:
		#Input.set_custom_mouse_cursor(%"Game Manager 3D".back_cursor, Input.CURSOR_ARROW)
		#return 0
	#else:
		#Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
		#return 0
	##etc
	##etc
