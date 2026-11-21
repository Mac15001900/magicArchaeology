extends Node

@onready var text_input = $"../UI/LineEdit"
@onready var player = $"../Player"
var input_active : bool = false
var last_spell : String = ""
var spell_history : Array[String] = []
var history_index : int = 0
var last_caret_column = 0
var current_caret_column = 0

signal spell_cast(spell : String)

const Spell = {
	divider = 'u',
	cycle = 'nar',
	to = 'tan',
	up = 'wa',
	down = 'nap',
	left = 'pok',
	right = 'kop',
	red = 'loj',
	green = 'lir',
	blue = 'las',
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("spell") && !input_active):
		_toggle_input_mode(true)
	if input_active:
		if Input.is_action_just_pressed("last_spell") && spell_history.size()>0 && history_index > 0:
			history_index -= 1
			text_input.text = spell_history[history_index]
			if history_index == spell_history.size() - 1:
				text_input.caret_column = self.last_caret_column
		elif Input.is_action_just_pressed("next_spell")  && spell_history.size()>0 && history_index < spell_history.size() -1:
			history_index += 1
			text_input.text = spell_history[history_index] #TODO code duplication with other case
			if history_index == spell_history.size() - 1:
				text_input.caret_column = self.last_caret_column
			
		current_caret_column = text_input.caret_column
	

func _toggle_input_mode(on: bool) -> void:
		self.input_active = on
		player.toggle_control(!on)
		if on:
			text_input.appear()
			history_index = spell_history.size()
		else:
			text_input.hide()
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	#print(new_text)
	text_input.clear()
	_toggle_input_mode(false)
	if(new_text.length()>0):
		spell_cast.emit(new_text)
		_cast_spell(new_text)

func _on_line_edit_editing_toggled(toggled_on: bool) -> void:
	if (!toggled_on && self.input_active):
		_toggle_input_mode(false)

func _cast_spell(spell : String) -> void:
	if spell.length() == 0:
		return
	if(spell != self.last_spell):
		self.last_spell = spell
		self.spell_history.append(spell)
	self.last_caret_column = self.current_caret_column 
	
	var parts = spell.split('u')
	match parts[0]:
		Spell.cycle:
			var direction = _parse_direction(parts[1], parts[2] if parts.size()>=3 else "" )
			if direction != 5:
				player.send_projectile(direction, Enums.Projectile_Type.cycle, [])
		Spell.red, Spell.green, Spell.blue:
			#Parsing first color
			if parts.size()<3:
				return
			var first_color = _string_to_color(parts[0])
			var i = 1
			if _string_to_color(parts[i]) != null:
				first_color = Utils.add_colors(first_color, _string_to_color(parts[i]))
				i+=1 
				if parts.size() > i and _string_to_color(parts[i]) != null:
					first_color = Utils.add_colors(first_color, _string_to_color(parts[i]))
					i+=1
			if parts.size() <= i or parts[i] != Spell.to:
				return
			i+=1
			#Parsing second color
			var second_color = _string_to_color(parts[i])
			if second_color == null:
				return
			i+=1
			if parts.size() > i and _string_to_color(parts[i]) != null:
				second_color = Utils.add_colors(second_color, _string_to_color(parts[i]))
				i+=1 
				if parts.size() > i and _string_to_color(parts[i]) != null:
					second_color = Utils.add_colors(second_color, _string_to_color(parts[i]))
					i+=1
			#Parsing direction
			if parts.size() <= i:
				return
			var direction = _string_to_direction(parts[i])
			i+=1
			if parts.size() > i and _string_to_direction((parts[i])) != 5:
				direction = Utils.combine_directions(direction, _string_to_direction(parts[i]))
			if direction != 5:
				player.send_projectile(direction, Enums.Projectile_Type.swap, [first_color, second_color])
			print("making a magic projectile converting "+str(first_color)+" to "+str(second_color)+", heading in direction "+str(direction))
			
	
func _parse_direction(primary: String, secondary: String) -> int:
	if secondary == "":
		return _string_to_direction(primary)
	else:
		return Utils.combine_directions(_string_to_direction(primary), _string_to_direction(secondary))

func _string_to_color(string: String):
	match string:
		Spell.red: return [1,0,0]
		Spell.green: return [0,1,0]
		Spell.blue: return [0,0,1]
		_: return null

func _string_to_direction(string: String) -> int:
	match string:
		Spell.up: return 8
		Spell.down: return 2
		Spell.left: return 4
		Spell.right: return 6
		_: return 5
