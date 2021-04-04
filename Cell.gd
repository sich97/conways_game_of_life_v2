extends ColorRect

var alive = false

var neighbours = {}

var left_blocked = true
var top_blocked = true
var right_blocked = true
var bottom_blocked = true

func _ready():
	rect_size.x = get_parent().square_width
	rect_size.y = get_parent().square_width

func find_neighbours():
	var square_width = get_parent().square_width
	var border_width = get_parent().cell_border_width
	
	if (rect_position.x >= get_parent().grid_width_border[0] + square_width + border_width):
		left_blocked = false
	if (rect_position.y >= get_parent().grid_height_border[0] + square_width + border_width):
		top_blocked = false
	if (rect_position.x <= get_parent().grid_width_border[1] - square_width - border_width):
		right_blocked = false
	if (rect_position.y <= get_parent().grid_height_border[1] - square_width - border_width):
		bottom_blocked = false
	
	if not left_blocked:
		neighbours["left"] = get_parent().grid[str(rect_position.y)][str(rect_position.x - border_width - square_width)]
	if not top_blocked and not left_blocked:
		neighbours["top_left"] = get_parent().grid[str(rect_position.y - border_width - square_width)][str(rect_position.x - border_width - square_width)]
	if not top_blocked:
		neighbours["top"] = get_parent().grid[str(rect_position.y - border_width - square_width)][str(rect_position.x)]
	if not top_blocked and not right_blocked:
		neighbours["top_right"] = get_parent().grid[str(rect_position.y - border_width - square_width)][str(rect_position.x + border_width + square_width)]
	if not right_blocked:
		neighbours["right"] = get_parent().grid[str(rect_position.y)][str(rect_position.x + border_width + square_width)]
	if not bottom_blocked and not right_blocked:
		neighbours["bottom_right"] = get_parent().grid[str(rect_position.y + border_width + square_width)][str(rect_position.x + border_width + square_width)]
	if not bottom_blocked:
		neighbours["bottom"] = get_parent().grid[str(rect_position.y + border_width + square_width)][str(rect_position.x)]
	if not bottom_blocked and not left_blocked:
		neighbours["bottom_left"] = get_parent().grid[str(rect_position.y + border_width + square_width)][str(rect_position.x - border_width - square_width)]

func alive_neighbours():
	var alive_neighbours = 0
	for neighbour in neighbours.keys():
		if neighbours[neighbour].alive:
			alive_neighbours += 1
	return alive_neighbours

func kill():
	alive = false
	#print("killed")
	color = Color(0.41, 0.41, 0.41, 1)

func revive():
	alive = true
	#print("revived")
	color = Color(0.98, 0.92, 0.84, 1)
