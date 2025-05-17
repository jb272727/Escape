extends Node
class_name floater

@export var speed : float = 0.6
@export var amount : float = 0.1
var _start_y : float
var _end_y : float
var direction: int = -1
var target : float

func _ready() -> void:
	_start_y = self.position.y
	_end_y = self.position.y - amount
	target = _end_y

func _process(delta):
	#print("start: ", _start_y)
	#print("end: ", _end_y)
	#print(self.position.y)
	bob(amount, delta)


func bob(amount : float, delta) -> void:
		var pos = self.position.y
		if pos > _end_y - 0.01 and pos < _end_y + 0.01:
			target = _start_y
		if pos < _start_y + 0.01 and pos > _start_y - 0.01:
			target = _end_y
		pos = lerp(pos, target, speed * delta)
		self.position.y = pos
