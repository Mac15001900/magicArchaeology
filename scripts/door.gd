extends StaticBody2D

@export var crystals : Array[Crystal]

@export var target_red : int
@export var target_green : int
@export var target_blue : int

@export var opening_distance: int = 3*18 + 9

@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D
@onready var sound_open = $OpenSound

var open : bool = false
var in_animation : bool = false
var animation_progress : float = 0
var start_y : float
const ANIMATION_LENGHT : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate.r = target_red
	self.modulate.g = target_green
	self.modulate.b = target_blue
	self.start_y = self.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_animation:
		animation_progress += delta
		if animation_progress >= 1:
			position.y = start_y + opening_distance
			in_animation = false
		else:
			var offset = ease_in_out_sine(animation_progress) * opening_distance
			position.y = start_y + offset	
	
	if !open and _all_crystals_match():
		print("open!")
		sound_open.play()
		self.in_animation = true
		open = true

func _all_crystals_match() -> bool:
	if crystals.size() == 0:
		return true
	
	var target : Array[int] = [target_red, target_green, target_blue]
	return crystals.all(func (c): return c.matches_target(target))

func ease_in_out_sine(x: float) -> float:
	return -(cos(PI * x) - 1) / 2;
