extends Area2D

@onready
var sprite = $Sprite2D
var baseY = null
var time = 0
var picked_up  = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	baseY = self.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.time += delta
	if(self.picked_up):
		self.modulate.a -= delta*4
		self.position.y -= delta*64
		if(self.modulate.a <=0 ):
			queue_free()
	else:
		self.position.y  = baseY + 4 * sin(self.time*4)


func _on_body_entered(_body: Node2D) -> void:
	if(!picked_up):
		print("Coin picked up")
		self.picked_up = true
	
