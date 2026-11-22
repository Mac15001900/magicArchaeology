extends ColorRect

var in_animation : bool = false
var time_left_in_animation : float
const ANIMATION_LENGHT : float = 1.0 #in seconds
const ANIMATION_DISTANCE : float = 720.0
var start_y : float

@export var enable_diary : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_y = self.position.y
	if !enable_diary:
		self.modulate.a = 0
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !in_animation and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel")):
		in_animation = true
		time_left_in_animation = ANIMATION_LENGHT
	if in_animation:
		self.position.y = easeInSine((1-time_left_in_animation) / ANIMATION_LENGHT) * ANIMATION_DISTANCE + start_y
		time_left_in_animation -= delta
		if time_left_in_animation <= 0:
			queue_free()

func easeInSine(x: float) -> float:
	return 1 - cos((x * PI) / 2)
