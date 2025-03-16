extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var a = Action.new()
	var b = a.get_resulting_state(true)
	print(b)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
