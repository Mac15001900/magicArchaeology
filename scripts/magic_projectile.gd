extends Area2D

var projectile_ready = false
var dx : int = 0
var dy : int = 0
var type = Enums.Projectile_Type.none
var from_color = null
var to_color = null
var origin : Node2D 

const DELETION_DISTANCE = 1000**2

@export var speed: float = 32.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if projectile_ready:
		self.position.x += dx * speed * delta
		self.position.y += dy * speed * delta
		if self.position.distance_squared_to(origin.position) > DELETION_DISTANCE:
			queue_free()

func setup(_origin : Node2D, direction: int, _type: Enums.Projectile_Type, _from_color=null, _to_color=null) -> void:
	self.origin = _origin
	self.dx = posmod((direction -1), 3) - 1
	self.dy = -( (direction - 1) / 3 - 1)
	self.type = _type
	self.from_color = _from_color
	self.to_color = _to_color
	projectile_ready = true
	

func _on_area_entered(crystal: Area2D) -> void:
	match type:
		Enums.Projectile_Type.cycle:			
			assert(crystal.has_method("cycle"))
			crystal.cycle()
		Enums.Projectile_Type.swap:
			assert(crystal.has_method("change"))
			crystal.change(from_color, to_color)
