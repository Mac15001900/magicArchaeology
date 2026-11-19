extends Area2D

var player_in_range = false
var time_till_harvest = 0
var harvest_ready = true
@onready var sprite = $Sprite2D

@export var growth_time: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(sprite.region_rect.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.time_till_harvest>0:
		self.time_till_harvest -= delta
		if(self.time_till_harvest<=0):
			harvest_ready = true
			time_till_harvest = 0
			sprite.region_rect.position.y -= 18
			if(player_in_range):
				toggle_highlight(true)
	if Input.is_action_just_pressed("interact") && player_in_range && harvest_ready:
		print("Harvest!")
		sprite.region_rect.position.y += 18
		toggle_highlight(false)
		harvest_ready = false
		time_till_harvest = float(growth_time)



func _on_body_entered(_body: Node2D) -> void:
	if(harvest_ready):
		toggle_highlight(true)
	player_in_range = true

func _on_body_exited(_body: Node2D) -> void:
	player_in_range = false
	toggle_highlight(false)

func toggle_highlight(on: bool) -> void:
	var value = 1.5 if on else 1.0
	self.modulate.g = value
	self.modulate.r = value
