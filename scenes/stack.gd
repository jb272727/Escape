extends Node3D

@onready var start_node = $START
var cubes : Array = []
const BLUE = preload("res://blue_mat_override_new.tres")

@onready var test_timer = $"Test Timer"
@onready var game_timer = $"Game Timer"
@onready var wait_timer = $"Wait Timer"
@onready var button_timer = $"Button Timer"
@onready var button = $Cylinder_034

var current_row = 0
var current_i = 0
var playing : bool = false
var width_left : int = 3
var speed : float = 1.0
var going_right : bool = false
var first : bool = true
var situation : Array
var front : int
var last : int

@export var coin_inserted : bool = false : set = play
func play(val:bool)->void:
	if val == false:
		pass
	else:
		speed = .2
		current_row = 0
		front = 8
		last = 10
		var current_i = 0
		width_left = 3
		first = true
		set_all_off()
		playing = true
		do_patterns(speed)

@export var game_over : bool = false : set = cleanup
func cleanup(val:bool)->void:
	playing = false
	print("cleaning up")
	wait_timer.start(.01)
	button_timer.start(3.2)
	for i in range(29, -1, -1):
		for j in range(11):
			set_cube_emissive(i, j, false)
			await wait_timer.timeout
	await button_timer.timeout

func do_patterns(speed):
	if first:
		situation = [0,0,0,0,0,0,0,0,1,1,1]
		going_right = false
		print("first")
		print("current row: " + str(current_row) + " " + str(width_left))
		game_timer.start(speed)
		if width_left >= 3:
			set_cube_emissive(current_row,8,true)
		if width_left >= 2:
			set_cube_emissive(current_row,9,true)
		if width_left >= 1:
			set_cube_emissive(current_row,10,true)
		first = false
	pass

func _ready():
	_initialize_cubes_array()

func _initialize_cubes_array():
	var all_cubes = start_node.get_children()
	var total_rows = 29
	for row in range(total_rows):
		cubes.append([])
	for i in range(all_cubes.size()):
		var cube = all_cubes[all_cubes.size() - 1 - i]
		if cube is MeshInstance3D:
			var row_index = i / 12
			var col_index = i % 12
			if row_index < total_rows:
				cubes[row_index].append(cube)
			else:
				break
		else:
			print("Warning: Child ", cube.name, " is not a MeshInstance3D.")
	print(cubes)

func set_cube_emissive(row:int, column:int, on:bool):
	var col : int = 11 - column
	if row < 0 or row >= 29:
		return
	if col < 0 or col >= 12:
		return
	var cube = cubes[row][col]
	if on:
		cube.set_surface_override_material(0, BLUE)
	else:
		cube.set_surface_override_material(0, null)

func _process(delta):
	#if playing and first:
		##await
		#do_patterns(speed)
	if Input.is_action_just_pressed("space") and playing and game_timer.is_stopped() == false:
		print("current row2: " + str(current_row) + " " + str(width_left))
		game_timer.stop()
		button.position.y = 0.850
		wait_timer.start(1.0)
		# find where each square landed
		# find if each landed square is valid and correct each squares override textures if invalid
		# update width_left appropriately
		if current_row == 0:
			print("row 0")
		else:
			for i in range(11):
				if cubes[current_row][11-i].get_surface_override_material(0) == BLUE:
					if cubes[current_row - 1][11-i].get_surface_override_material(0) == null:
						width_left = width_left - 1
						cubes[current_row][11-i].set_surface_override_material(0, null)
		await wait_timer.timeout
		button.position.y = 0.861
		if width_left > 0:
			current_row += 1
			first = true
		elif width_left == 0:
			playing = false
			game_over = true
			pass
		# increase speed global variable if current_row > x
		match current_row:
			0,1,2:
				speed = .2
			3,4,5:
				speed = .15
			6,7,8:
				speed = .1
			9,10,11:
				speed = .1
			12,13,14:
				speed = .09
			15,16,17:
				speed = .08
			18,19,20:
				speed = .07
			21,22,23,24,25,26,27,28,29:
				speed = .05
		if width_left > 0:
			do_patterns(speed)

func _on_test_timer_timeout():
	var row : int = current_i / 12
	set_cube_emissive(row, current_i % 12, true)
	current_i += 1

func _on_game_timer_timeout():
	for i in range(11):
		if cubes[current_row][11-i].get_surface_override_material(0) == BLUE:
			front = i
			break
	for j in range(11):
		if cubes[current_row][11-j].get_surface_override_material(0) == BLUE:
			last = j
	if !going_right:
		set_cube_emissive(current_row, front-1, true)
		set_cube_emissive(current_row, last, false)
		if front-1 == 0:
			going_right = true
	else:
		set_cube_emissive(current_row, last+1, true)
		set_cube_emissive(current_row, front, false)
		if last+1 == 10:
			going_right = false
	print(" Game Timer Timeout ")
	print(going_right)
	print(front)
	print(last)

func set_all_off() -> void:
	var i : int = 0
	while i < 348:
		set_cube_emissive(i / 12, i % 12, false)
		i += 1

func set_all_on() -> void:
	var i : int = 0
	while i < 348:
		set_cube_emissive(i / 12, i % 12, true)
		i += 1
