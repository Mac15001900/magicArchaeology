extends Area2D
class_name Crystal

@export var r : int = 1
@export var g : int = 1
@export var b : int = 1

var correct : bool = false

func _ready() -> void:
	_update_color()
	
func _update_color() -> void:
	self.modulate.r = r
	self.modulate.g = g
	self.modulate.b = b
	

func cycle():
	var newR = b
	var newG = r
	var newB = g
	
	self.r = newR
	self.g = newG
	self.b = newB
	
	_update_color()
	
func change(from, to):
	assert(from != null and to != null)
	assert(from.size() == 3 and to.size() == 3)
	if (from[0]==0 or r>=2) and (from[1]==0 or g>=2) and (from[2]==0 or b>=2):
		r -= from[0]
		g -= from[1]
		b -= from[2]
		
		r = clamp(r + to[0], 1, 2)
		g = clamp(g + to[1], 1, 2)
		b = clamp(b + to[2], 1, 2)
		_update_color()
	
func matches_target(colors: Array[int]) -> bool:
	return r==colors[0] && g==colors[1] && b==colors[2]
