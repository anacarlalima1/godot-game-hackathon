extends GridContainer

var grid_size = 3
var sequence = []
var tiles = []
var empty_position = Vector2(2, 2)

func _ready():
	sequence = [
		[true, false, true],
		[false, true, true],
		[true, false, true]
	]
	shuffle_sequence()
	create_grid()
	_rearrange_tiles()

func shuffle_sequence():
	var flat_sequence = []
	for row in sequence:
		flat_sequence += row
	flat_sequence.shuffle()
	
	for i in range(grid_size):
		for j in range(grid_size):
			sequence[i][j] = flat_sequence.pop_front()

func create_grid():
	for i in range(grid_size):
		var row = []
		for j in range(grid_size):
			if Vector2(i, j) == empty_position:
				row.append(null)
				continue
			var tile_scene = preload("res://scenes/tile.tscn").instantiate()
			if tile_scene:
				tile_scene.position_in_grid = Vector2(i, j)
				tile_scene.game = self
				tile_scene.set_texture(get_tile_texture(i, j))
				tile_scene.connect("tile_pressed", Callable(self, "_on_tile_pressed").bind(Vector2(i, j)))
				add_child(tile_scene)
				row.append(tile_scene)
		tiles.append(row)

func get_tile_texture(i, j):
	if sequence[i][j]:
		return preload("res://sprites-tictactoe/hippo.png")
	else:
		return preload("res://sprites-tictactoe/chick.png")

func _on_tile_pressed(position):
	var distance = position.distance_to(empty_position)
	if distance == 1:
		swap_tiles(position, empty_position)
		empty_position = position
		_rearrange_tiles()
		if check_sequence():
			print("Você completou a sequência!")

func swap_tiles(pos1, pos2):
	var tile1 = tiles[pos1.x][pos1.y]
	tiles[pos2.x][pos2.y] = tile1
	tiles[pos1.x][pos1.y] = null
	tile1.position_in_grid = pos2

func _rearrange_tiles():
	for i in range(grid_size):
		for j in range(grid_size):
			if tiles[i][j] != null:
				print('min', tiles[i][j].rect_min_size)
				# tiles[i][j].rect_min_size = Vector2(64, 64)  # Define o tamanho mínimo do botão
				# tiles[i][j].rect_position = Vector2(j * 64, i * 64)  # Ajusta a posição do botão no GridContainer

func check_sequence():
	for i in range(grid_size):
		for j in range(grid_size):
			if sequence[i][j] == null:
				if tiles[i][j] != null:
					return false
			else:
				if tiles[i][j] == null or (tiles[i][j].get_texture() == preload("res://sprites-tictactoe/hippo.png")) != sequence[i][j]:
					return false
	return true
