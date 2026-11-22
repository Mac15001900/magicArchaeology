extends RichTextLabel

@export var target: String
@export var hint_mode: Enums.Hint_Type
@export var game_controller: Node

var target_list #: Array[String]

const alphabet = "abcdefghijklmnopqrstuvwxyz"

func _ready() -> void:
	assert(target.length()>0)
	self.target_list = Array(target.split())
	game_controller.connect("spell_cast",_on_game_controller_spell_cast)


func _on_game_controller_spell_cast(spell: String) -> void:
	var response = response_for(spell)
	self.clear()
	if Array(response.split('\n')).any(func(line): return line.length() > 5):
		self.push_font_size(8)
	else:
		self.push_font_size(16)
	#print("Setting text of "+str(self)+" to "+response)
	self.add_text(response)


func response_for(spell: String) -> String:
	spell = spell.to_lower()
	var char_list = Array(spell.split())
	#Is the spell valid?
	if spell == target:
		return "="
		
	#Are there any illegal characters?
	var invalid_index = char_list.find_custom(func(s): return letter_index(s) == -1)
	if invalid_index!=-1:
		if spell[invalid_index] == ' ':
			return "a b -> ab"
		else:
			return "x "+spell[invalid_index]+" x"
		
	#Does the length match?
	if spell.length() > target.length():
		return "<--"
	elif spell.length() < target.length():
		return "-->"
	
	match hint_mode:
		Enums.Hint_Type.verbose:
			var res = ""
			for i in range(char_list.size()):
				var diff = letter_index(char_list[i]) - letter_index(target_list[i])
				if diff < 0:
					res+="^"
				elif diff > 0:
					res += "v"
				else:
					res += "-"
			assert(res.length() == spell.length())
			return res
		Enums.Hint_Type.alphabetical:
			if _compare_alphabetically(spell, target) == -1:
				return ">"
			else:
				return "<"
		Enums.Hint_Type.wordle:
			var target_amounts : Array[int] = []
			target_amounts.resize(alphabet.length())
			target_amounts.fill(0)
			for i in range(target.length()):
				target_amounts[letter_index(target[i])] += 1
			for i in range(spell.length()):
				if target[i] == spell[i]:
					target_amounts[letter_index(target[i])] -= 1
			
			var res : String = ""
			for i in range(spell.length()):
				if target[i] == spell[i]:
					res += '-'
				elif target_amounts[letter_index(spell[i])] > 0:
					target_amounts[letter_index(spell[i])] -= 1
					res += '?'
				else:
					res += 'x'
			if res.length()>12:
				 #TODO make this general, not specifically made for this one message
				res = res.insert(12,'\n').insert(8,'\n').insert(4,'\n')
			return res
			
	return "???????????????????????????????"
		
func letter_index(letter: String) -> int:
	return alphabet.find(letter)
	
func _compare_alphabetically(a: String, b: String):
	if a.length() == 0 and b.length()==0:
		return 0
	elif a.length()==0:
		return -1
	elif b.length()==0:
		return 1
	var ai = letter_index(a[0])
	var bi = letter_index(b[0])
	if ai < bi: 
		return -1
	if bi < ai:
		return 1
	else:
		return _compare_alphabetically(a.substr(1), b.substr(1))
	
