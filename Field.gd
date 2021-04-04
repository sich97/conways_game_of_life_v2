extends Node

var desired_framerate = 30
var framerate_as_milliseconds_between_frames : float

var cell_border_width = 1
var square_width = 4
var initially_alive_probability = 0.1

var window_width : int
var grid_width_border
var window_height: int
var grid_height_border

var grid = {}

var rng = RandomNumberGenerator.new()

onready var Cell = preload("res://Cell.tscn")

var ready = false


func _ready():
	framerate_as_milliseconds_between_frames = (1.0 / desired_framerate) * 1000
	
	#rng.randomize()
	window_width = OS.get_window_size().x
	print("Got window width: " + str(window_width))
	window_height = OS.get_window_size().y
	print("Got window height: " + str(window_height))
	
	grid_width_border = [cell_border_width, window_width - cell_border_width - square_width]
	grid_height_border = [cell_border_width, window_height - cell_border_width - square_width]
	
	print("Grid width border: " + str(grid_width_border))
	print("Grid height border: " + str(grid_height_border))
	
	prepeare_grid()
	
	prepeare_cells()
	
	ready = true

func prepeare_grid():
	var y_done = false
	var y_count = 0
	
	while not y_done:
		y_count += cell_border_width
		if (y_count >= grid_height_border[0] and y_count <= grid_height_border[1]):
			grid[str(y_count)] = {}
			var x_done = false
			var x_count = 0
			while not x_done:
				x_count += cell_border_width
				if (x_count >= grid_width_border[0] and x_count <= grid_width_border[1]):
					create_cell(x_count, y_count)
					
					x_count += square_width
				else:
					#print("Completed inner grid preperation loop")
					x_done = true
			
			y_count += square_width
		else:
			print("Completed outer grid preperation loop")
			y_done = true
	
			
func create_cell(x_pos:int, y_pos:int):
		var new_square = Cell.instance()
		new_square.set_position(Vector2(x_pos, y_pos))
		if (rng.randf_range(0.0, 1.0) < initially_alive_probability):
			new_square.revive()
		grid[str(y_pos)][str(x_pos)] = new_square
		add_child(grid[str(y_pos)][str(x_pos)])
		#print("Created new square at: " + str(x_pos) + ", " + str(y_pos))

func prepeare_cells():
	print("Prepearing cells ...")
	for y_pos in grid.keys():
		#print("Prepearing cells in row: " + y_pos)
		for x_pos in grid[str(y_pos)].keys():
			if grid[str(y_pos)][str(x_pos)]:
				grid[str(y_pos)][str(x_pos)].find_neighbours()
	print("Done prepearing cells")

func _process(delta):
	var remaining_milliseconds_to_wait = framerate_as_milliseconds_between_frames - (delta * 1000)
	#print("Remaining milliseconds: " + str(remaining_milliseconds_to_wait))
	if not (remaining_milliseconds_to_wait <= 0):
		OS.delay_msec (remaining_milliseconds_to_wait)
	
	if ready:
		var cells_to_be_killed = []
		var cells_to_be_revived = []
		
		for row_key in grid.keys():
			for cell_key in grid[row_key].keys():
				var alive = grid[row_key][cell_key].alive
				var alive_neighbours = grid[row_key][cell_key].alive_neighbours()
				if alive:
					if (alive_neighbours < 2 or alive_neighbours > 3):
						cells_to_be_killed.append([row_key, cell_key])
						#print("appended to kill list")
				else:
					if (alive_neighbours == 3):
						cells_to_be_revived.append([row_key, cell_key])
						#print("appended to revive list")
		
		for cell in cells_to_be_killed:
			grid[cell[0]][cell[1]].kill()
		
		for cell in cells_to_be_revived:
			grid[cell[0]][cell[1]].revive()
