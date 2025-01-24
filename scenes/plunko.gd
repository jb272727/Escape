extends Node3D

@export var CoinScene: PackedScene = preload("res://scenes/coin2.tscn")
var current_coin = null
var previously_set : bool = false
@export var test_diff : float
var stats : Array
var current_pattern : int = 0
var flash_count : int = 0
var global_count : int = 0
var pattern3_loc : Node3D = null
var pattern3_on : bool = false
@onready var bulb_14 = $bulbs/bottom/Bulb14
@onready var bulb_15 = $bulbs/bottom/Bulb15
@onready var bulb_16 = $bulbs/bottom/Bulb16
@onready var bulb_17 = $bulbs/bottom/Bulb17
@onready var bulb_18 = $bulbs/bottom/Bulb18
@onready var bulb_19 = $bulbs/bottom/Bulb19
@onready var bulb_20 = $bulbs/bottom/Bulb20
@onready var bulb_21 = $bulbs/bottom/Bulb21
@onready var bulb_22 = $bulbs/bottom/Bulb22



@export var coin_inserted : bool = false : set = play
func play(val:bool)->void:
		# play animation
		flash_count = 0
		global_count = 0
		pattern3_loc = null
		pattern3_on = false
		current_pattern = 1
		set_pattern1()
		$"Light Timer".start(0.0)
		
		# spawn coin
		var diff : float = float(rng.randi_range(-20, 20))
		diff = diff / 1000
		diff = 0.0
		spawn_coin(Vector3(0.0 + test_diff, 1.801, 0.019)) #1.801, 0.019


@export var print_stats : bool = false : set = print_s
func print_s(val:bool)->void:
	print(stats)

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	stats = [0,0,0,0,0,0,0,0,0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(current_pattern)
	if previously_set == false:
		if coin_inserted:
			rng.randomize()
			play(coin_inserted)
			previously_set = true


func spawn_coin(position: Vector3) -> void:
	var coin_instance = CoinScene.instantiate()
	#coin_instance.translation = position 
	coin_instance.global_transform.origin = position
	#coin_instance.scale = Vector3(1.745, 1.745, 1.745)
	#for child in coin_instance.get_children(true):
		#child.scale = Vector3(1.745, 1.745, 1.745)
	print("Coin Scale: ", coin_instance.scale)

	$"Light Timer".start(0.0)
	add_child(coin_instance)
	#add_sibling(coin_instance)
	#print(get_parent().get_children())
	
	#for child in get_children():
		#if child.name == "coin2":
			#print("YYYYYYYYAYAYBAAAAAAAAAA")
			#child.scale = Vector3(1.745, 1.745, 1.745)


func set_pattern1():
		var count = 0
		print($bulbs/right.get_children())
		var bulbs = $bulbs/right.get_children()
		for bulb in bulbs:
			var light: OmniLight3D = null
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
					break
			if light:
				if count % 2 == 0:
					light.visible = false
				count += 1
		bulbs = $bulbs/left.get_children()
		for bulb in bulbs:
			var light: OmniLight3D = null
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
					break
			if light:
				if count % 2 == 0:
					light.visible = false
				count += 1
		bulbs = $bulbs/top.get_children()
		for bulb in bulbs:
			var light: OmniLight3D = null
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
					break
			if light:
				if count % 2 == 0:
					light.visible = false
				count += 1
		bulbs = $bulbs/bottom.get_children()
		for bulb in bulbs:
			var light: OmniLight3D = null
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
					break
			if light:
				if count % 2 == 0:
					light.visible = false
				count += 1

func reverse_pattern1():
	var bulbs = $bulbs/right.get_children()
	for bulb in bulbs:
		var light: OmniLight3D = null
		for child in bulb.get_children():
			if child is OmniLight3D:
				light = child
				break
		if light.visible == false:
			light.visible = true
		else: 
			light.visible = false
	bulbs = $bulbs/left.get_children()
	for bulb in bulbs:
		var light: OmniLight3D = null
		for child in bulb.get_children():
			if child is OmniLight3D:
				light = child
				break
		if light.visible == false:
			light.visible = true
		else: 
			light.visible = false
	bulbs = $bulbs/top.get_children()
	for bulb in bulbs:
		var light: OmniLight3D = null
		for child in bulb.get_children():
			if child is OmniLight3D:
				light = child
				break
		if light.visible == false:
			light.visible = true
		else: 
			light.visible = false
	bulbs = $bulbs/bottom.get_children()
	for bulb in bulbs:
		var light: OmniLight3D = null
		for child in bulb.get_children():
			if child is OmniLight3D:
				light = child
				break
		if light.visible == false:
			light.visible = true
		else: 
			light.visible = false



func body_entered(body, area_num : int):
	var test = body.get_script()
	if test:
		var children = get_children()
		for child in children:
			if child.name == "coin2":
				child.queue_free()
				remove_child(child)
				#$"Test Timer".start(0.0)
				#play(coin_inserted)
		$"Light Timer".stop()
		unset_all()
		flash_count = 0
		current_pattern = 3
		match area_num:
			1:
				print("0x")
				var childs = bulb_14.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_14
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			2:
				print("0x")
				var childs = bulb_15.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_15
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			3:
				print("1x")
				var childs = bulb_16.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_16
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			4:
				print("2x")
				var childs = bulb_17.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_17
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			5:
				print("10x")
				var childs = bulb_18.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_18
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			6:
				print("2x")
				var childs = bulb_19.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_19
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			7:
				print("1x")
				var childs = bulb_20.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_20
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			8:
				print("0x")
				var childs = bulb_21.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_21
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
			9:
				print("0x")
				var childs = bulb_22.get_children()
				for child in childs:
					if child.name == "Light":
						child.visible = true
				pattern3_loc = bulb_22
				stats[0] = stats[0] + 1
				$"Light Timer".start(0.0)
				


func _on_area_3d_1_body_entered(body):
	body_entered(body, 1)

func _on_area_3d_2_body_entered(body):
	body_entered(body, 2)

func _on_area_3d_3_body_entered(body):
	body_entered(body, 3)

func _on_area_3d_4_body_entered(body):
	body_entered(body, 4)

func _on_area_3d_5_body_entered(body):
	body_entered(body, 5)

func _on_area_3d_6_body_entered(body):
	body_entered(body, 6)

func _on_area_3d_7_body_entered(body):
	body_entered(body, 7)

func _on_area_3d_8_body_entered(body):
	body_entered(body, 8)

func _on_area_3d_9_body_entered(body):
	body_entered(body, 9)


func _on_test_timer_timeout():
	print("timeout")
	#play(coin_inserted)

# Distn:    [305, 82, 60, 117, 62, 106, 65, 68, 293] for about 1240 tries w/ 35 timeouts


func set_all():          # set all lights on
		var bulbs = $bulbs/top.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true
		bulbs = $bulbs/left.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true
		bulbs = $bulbs/right.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true
		bulbs = $bulbs/bottom.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true
			
func unset_all() -> void:
		var bulbs = $bulbs/top.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false
		bulbs = $bulbs/left.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false
		bulbs = $bulbs/right.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false
		bulbs = $bulbs/bottom.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false

func set_pattern2(iteration : int) -> void:
	if iteration == 0:
		var bulbs = $bulbs/top.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true
		bulbs = $bulbs/left.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false
		bulbs = $bulbs/right.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false
		bulbs = $bulbs/bottom.get_children()
		for bulb in bulbs:
			var light : OmniLight3D
			for child in bulb.get_children():
				if child is OmniLight3D:
					light = child
			light.visible = false
	else:
		var bulbs = $bulbs/left.get_children()
		for i in range(iteration):
			var light : OmniLight3D
			for child in bulbs[12-i].get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true
		bulbs = $bulbs/right.get_children()
		for i in range(iteration):
			var light : OmniLight3D
			for child in bulbs[12-i].get_children():
				if child is OmniLight3D:
					light = child
			light.visible = true




func _on_light_timer_timeout():
	if current_pattern <= 2 and current_pattern >= 1:
		flash_count += 1
		if flash_count > 6:
			if global_count <= 13 and global_count >= 1:		# set all the lights to on > then start iterating through the pattern
				if current_pattern != 2:
					current_pattern = 2
					set_pattern2(0)
					$"Light Timer".start(0.0)
				elif current_pattern == 2:
					print(global_count)
					set_pattern2(global_count)
					global_count += 1
			elif global_count == 0:
				set_all()
				global_count += 1
			else:
				global_count = 0
	match current_pattern:
		0:
			set_all()
		1:
			reverse_pattern1()
		2:
			pass
		3:
			if flash_count < 8:
				single_blink()
				flash_count += 1
			else:
				current_pattern = 0


func single_blink() -> void:
	match pattern3_loc:
		bulb_14:
			var childs = bulb_14.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_15:
			var childs = bulb_15.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_16:
			var childs = bulb_16.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_17:
			var childs = bulb_17.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_18:
			var childs = bulb_18.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_19:
			var childs = bulb_19.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_20:
			var childs = bulb_20.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_21:
			var childs = bulb_21.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
		bulb_22:
			var childs = bulb_22.get_children()
			var light : OmniLight3D = null
			for child in childs:
				if child.name == "Light":
					light = child
			if light.visible == false:
				light.visible = true
			else:
				light.visible = false
