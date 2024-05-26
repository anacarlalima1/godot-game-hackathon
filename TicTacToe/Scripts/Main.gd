extends GridContainer

var grid_size = 3
var sequence = [
	[true, false, true],
	[false, true, true],
	[true, false, true]
]
var initial_sequence = null  # Para salvar o estado inicial
var tiles = []
var empty_position = Vector2(1, 1)  # Posição do quadrado vazio (linha 1, coluna 1)
var initial_empty_position = null  # Para salvar a posição vazia inicial

# Função chamada quando o nó está pronto
func _ready():
	print('começou')
	tiles = []
	if initial_sequence == null:
		print('if')
		shuffle_sequence()
		# Salve o estado inicial após a primeira reorganização
		initial_sequence = duplicate_sequence(sequence)
		initial_empty_position = empty_position
		print("Initial sequence saved:", initial_sequence)
		print("Initial empty position saved:", initial_empty_position)
	else:
		print('else')
		# Carregue o estado salvo
		sequence = duplicate_sequence(initial_sequence)
		empty_position = initial_empty_position
		print("Loaded initial sequence:", sequence)
		print("Loaded initial empty position:", empty_position)
		
	print("Sequence on ready:", sequence)
	
	for i in range(grid_size):
		var row = []
		for j in range(grid_size):
			if i == empty_position.x and j == empty_position.y:
				row.append(null)
				continue
			var tile_scene = preload("res://TicTacToe/Scenes/Tile.tscn")
			var tile = tile_scene.instance()
			tile.position_in_grid = Vector2(i, j)
			tile.game = self
			add_child(tile)
			tile.set_texture(get_tile_texture(i, j))
			tile.connect("tile_pressed", self, "move_tile")
			row.append(tile)
		tiles.append(row)
	_rearrange_tiles()

	print("Tiles initialized:", tiles)

# Função para embaralhar a sequência
func shuffle_sequence():
	var flat_sequence = []
	for row in sequence:
		flat_sequence += row
	flat_sequence.shuffle()
	
	for i in range(grid_size):
		for j in range(grid_size):
			sequence[i][j] = flat_sequence.pop_front()

	print("Shuffled sequence:", sequence)

# Função para reorganizar a posição dos tiles na tela
func _rearrange_tiles():
	for i in range(grid_size):
		for j in range(grid_size):
			if tiles[i][j] != null:
				tiles[i][j].rect_position = Vector2(j * tiles[i][j].rect_size.x, i * tiles[i][j].rect_size.y)

# Função para obter a textura do tile com base na sequência
func get_tile_texture(i, j):
	if sequence[i][j] == true:
		return preload("res://TicTacToe/Assets/hippo.png")
	elif sequence[i][j] == false:
		return preload("res://TicTacToe/Assets/chick.png")
	return null

# Função para mover um tile para a posição vazia
func move_tile(position):
	var distance = position.distance_to(empty_position)
	if distance == 1:
		if can_move_tile(position):
			swap_tiles(position, empty_position)
			empty_position = position
			_rearrange_tiles()
			if check_sequence():
				print("Você completou a sequência!")

# Função para verificar se um tile pode ser movido
func can_move_tile(position):
	var tile_pos = tiles[position.x][position.y].position_in_grid
	return abs(empty_position.x - tile_pos.x) + abs(empty_position.y - tile_pos.y) == 1

# Função para trocar dois tiles de posição
func swap_tiles(pos1, pos2):
	var tile1 = tiles[pos1.x][pos1.y]
	tiles[pos2.x][pos2.y] = tile1
	tiles[pos1.x][pos1.y] = null

	tile1.position_in_grid = pos2
	tile1.rect_position = Vector2(pos2.y * tile1.rect_size.x, pos2.x * tile1.rect_size.y)

# Função para verificar se a sequência está correta
func check_sequence() -> bool:
	for i in range(grid_size):
		for j in range(grid_size):
			if sequence[i][j] == null:
				if tiles[i][j] != null:
					return false
			else:
				if tiles[i][j] == null or (tiles[i][j].sprite.texture == preload("res://TicTacToe/Assets/hippo.png")) != sequence[i][j]:
					return false
	return true

# Função para duplicar a sequência
func duplicate_sequence(original_sequence):
	print('original sequence', original_sequence)
	var new_sequence = []
	for row in original_sequence:
		var new_row = []
		for value in row:
			new_row.append(value)
		new_sequence.append(new_row)
	return new_sequence
