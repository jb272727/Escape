extends Node3D
@onready var skeleton := $Skeleton3D
var bones : Array = []
@onready var timer := $Timer
@export var bone1_final : Vector3 = Vector3(1.0,1.0,1.2)
var forward = true
@export var bone2_final : Vector3 = Vector3(1.0,1.0,1.08)
var lerp_speed : float = .001
var lerped_variable : float = 1.0
var lerped_variable2 : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	timer.start(randf_range(0.5,0.75))
	bones.append(skeleton.find_bone("Bone.001"))
	bones.append(skeleton.find_bone("Bone.002"))
	bones.append(skeleton.find_bone("Bone.005"))
	
	#var bone_transform = skeleton.get_bone_pose(bones[0])
	#bone_transform = bone_transform.scaled(Vector3(1.0,15.0,1.0))
	skeleton.set_bone_pose_scale(bones[0], Vector3(1.0,1.0,1.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if forward:
		lerped_variable = lerp(lerped_variable, bone1_final.z, lerp_speed)
		lerped_variable2 = lerp(lerped_variable2, bone2_final.z, lerp_speed)
		skeleton.set_bone_pose_scale(bones[0], Vector3(1.0,1.0,lerped_variable))
		skeleton.set_bone_pose_scale(bones[2], Vector3(1.0,1.0,lerped_variable2))
		#skeleton.set_bone_pose_scale(bones[1], Vector3(1.0,1.0,lerped_variable))
		#skeleton.set_bone_pose_scale(bones[2], Vector3(1.0,1.0,lerped_variable))
	elif !forward:
		lerped_variable = lerp(lerped_variable, Vector3(1.0,1.0,1.0).z, lerp_speed)
		lerped_variable2 = lerp(lerped_variable2, Vector3(1.0,1.0,1.0).z, lerp_speed)
		skeleton.set_bone_pose_scale(bones[0], Vector3(1.0,1.0,lerped_variable))
		skeleton.set_bone_pose_scale(bones[2], Vector3(1.0,1.0,lerped_variable2))
		#skeleton.set_bone_pose_scale(bones[1], Vector3(1.0,1.0,lerped_variable))
		#skeleton.set_bone_pose_scale(bones[2], Vector3(1.0,1.0,lerped_variable))

func _on_timer_timeout():
	forward = !forward
