extends Node3D

@onready var meter := $Plane_007
var current_rotation: float
var target_rotation: float
const LERP_SPEED: float = 5.0
const ROTATION_THRESHOLD: float = 15.0

func _ready():
	randomize()
	current_rotation = meter.rotation_degrees.z
	target_rotation = pick_rotation()

func _process(delta):
	# Interpolate current rotation towards target rotation
	current_rotation = lerp(current_rotation, target_rotation, LERP_SPEED * delta)
	meter.rotation_degrees.z = current_rotation
	
	# Check if close enough to target rotation
	if abs(current_rotation - target_rotation) < ROTATION_THRESHOLD:
		target_rotation = pick_rotation()

func pick_rotation() -> float:
	return randi() % 171 - 90  # Random integer between -90 and 80
