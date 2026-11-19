extends Script
class_name Utils

static func direction_to_components(direction: int):
	return 	[posmod((direction -1), 3) - 1, -( (direction - 1) / 3 - 1)]

static func components_to_direction(x: int, y:int):
	return -3*y + x + 5
	
static func combine_directions(a: int, b: int):
	var da = direction_to_components(a)
	var db = direction_to_components(b)
	
	var dx = clampi(da[0] + db[0] , -1, 1)
	var dy = clampi(da[1] + db[1] , -1, 1)
	
	return components_to_direction(dx, dy)

static func add_colors(a, b):
	return [a[0]+b[0], a[1]+b[1], a[2]+b[2]]
	
static func shift_color(color):
	return [color[2], color[0], color[1]]

static func unshift_color(color):
	return [color[1], color[2], color[0]]
