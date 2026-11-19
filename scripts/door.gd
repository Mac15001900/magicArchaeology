extends StaticBody2D

@export var crystals : Array[Crystal]

@export var target_red : int
@export var target_green : int
@export var target_blue : int

@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D

var open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate.r = target_red
	self.modulate.g = target_green
	self.modulate.b = target_blue


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !open and _all_crystals_match():
		print("open!") #TODO An animation for opening?
		#sprite.region_rect.size.y = 18
		#collider.shape.size.y = 18
		self.position.y += 3*18
		open = true

func _all_crystals_match() -> bool:
	if crystals.size() == 0:
		return true
	
	var target : Array[int] = [target_red, target_green, target_blue]
	return crystals.all(func (c): return c.matches_target(target))
