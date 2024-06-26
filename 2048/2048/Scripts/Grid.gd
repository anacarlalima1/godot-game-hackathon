extends Node2D

"""
Essas funções estão criando elementos (pieces), encontrando
espaços em branco ou movendo elementos (pieces) e deletando/
substituindo elementos (pieces).
"""

var width := 4
var height := 4
var board := []
var x_start := 32
var y_start := 445
var offset := 76

# Declaração das variáveis PackedScene
export var four_piece_change: int
export var number_of_starting_pieces: int
export var two_piece: PackedScene
export var four_piece: PackedScene
export var background_piece: PackedScene

func _ready():
	randomize()
	board = make_2d_array()
	generate_background()
	generate_new_piece(number_of_starting_pieces)

# Cria um array 4x4
func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func grid_to_pixel(grid_position: Vector2):
	var new_x = x_start + offset * grid_position.x
	var new_y = y_start + -offset * grid_position.y
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_position: Vector2):
	var new_x = round((pixel_position.x - x_start) / offset)
	var new_y = round((pixel_position.y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(grid_position: Vector2):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y > 0 && grid_position.y < height:
			return true
	return false

# Verifica se há um espaço em branco
func is_blank_space():
	for i in width:
		for j in height:
			if board[i][j] == null:
				return true
		return false

func move_all_pieces(direction: Vector2):
	match direction:
		Vector2.UP:
			for i in width:
				for j in range(height - 2, -1, -1):
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.UP)
						
		Vector2.DOWN:
			for i in width:
				for j in range(0, height, 1):
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.DOWN)
						
		Vector2.LEFT:
			for i in range(1, width, 1):
				for j in height:
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.LEFT)
						
		Vector2.RIGHT:
			for i in range(width - 2, -1, -1):
				for j in height:
					if board[i][j] != null:
						move_piece(Vector2(i,j), Vector2.RIGHT)
			pass
		_:
			continue
	generate_new_piece(1)
	
func move_and_set_board_value(current: Vector2, desired: Vector2):
	var temp = board[current.x][current.y]
	temp.move(grid_to_pixel(Vector2(desired.x, desired.y)))
	board[current.x][current.y] = null
	board[desired.x][desired.y] = temp 
	print('aqui')

func move_piece(piece: Vector2, direction: Vector2):
	# Armazena o pedaço
	var this_piece = board[piece.x][piece.y]
	var value = this_piece.value
	var temp = board[piece.x][piece.y].next_value
	var next_space = piece + direction
	
	match direction:
		Vector2.RIGHT:
			for i in range(next_space.x, width):
				# Se não for o final do board e o quadrado é nulo
				if i == width - 1 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(width - 1, piece.y))
					break
				
				# Se o quadrado está preenchido e o valor não é o mesmo do anterior
				if board[i][piece.y] != null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i - 1, piece.y))
					break
				if board[i][piece.y] != null && board[i][piece.y].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					
					if temp != null:
						var new_piece = temp.instance()
						new_piece.value = value * 2  # Atualiza o valor da nova peça
						add_child(new_piece)
						board[i][piece.y] = new_piece
						new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
				
		Vector2.LEFT:
			for i in range(next_space.x, -1, -1):
				# Se não for o final do board e o quadrado é nulo
				if i == 0 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(0, piece.y))
					break
				
				# Se o quadrado está preenchido e o valor não é o mesmo do anterior
				if board[i][piece.y] != null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(i + 1, piece.y))
					break
				if board[i][piece.y] != null && board[i][piece.y].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(i, piece.y))
					
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(i, piece.y))
					break
			
		Vector2.UP:
			for i in range(piece.y + 1, height):
				# Se não for o final do board e o quadrado é nulo
				if i == height - 1 && board[piece.x][i] == null:
					move_and_set_board_value(piece, Vector2(piece.x, height - 1))
					break
				
				# Se o quadrado está preenchido e o valor não é o mesmo do anterior
				if board[piece.x][i] != null && board[piece.x][i].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i-1))
					break
				if board[piece.x][i] != null && board[piece.x][i].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(piece.x, i))
					
					var new_piece = temp.instance()
					print('temp', temp)
					print('new piece', new_piece)
					add_child(new_piece)
					board[piece.x][i] = new_piece
					new_piece.position = grid_to_pixel(Vector2(piece.x, i))
					break
			
		Vector2.DOWN:
			for i in range(piece.y - 1, -1, -1):
				# Se não for o final do board e o quadrado é nulo
				if i == 0 && board[i][piece.y] == null:
					move_and_set_board_value(piece, Vector2(piece.x, 0))
					break
				
				# Se o quadrado está preenchido e o valor não é o mesmo do anterior
				if board[i][piece.y] != null && board[i][piece.y].value != value:
					move_and_set_board_value(piece, Vector2(piece.x, i + 1))
					break
					
				if board[piece.x][i] != null && board[piece.x][i].value == value:
					remove_and_clear(piece)
					remove_and_clear(Vector2(piece.x, i))
					
					var new_piece = temp.instance()
					add_child(new_piece)
					board[i][piece.y] = new_piece
					new_piece.position = grid_to_pixel(Vector2(piece.x, i))
					break
			
func remove_and_clear(piece: Vector2):
	if board[piece.x][piece.y] != null:
		board[piece.x][piece.y].remove()
		board[piece.x][piece.y] = null

func move():
	pass

func generate_new_piece(number_of_pieces: int):
	if is_blank_space():
		var pieces_made = 0
		while pieces_made < number_of_pieces:
			var x_position = int(floor(rand_range(0, 4)))
			var y_position = int(floor(rand_range(0, 4)))
			if board[x_position][y_position] == null:
				var piece_scene = is_two_or_four()
				if piece_scene:
					var existing_piece = get_node(str(x_position) + "-" + str(y_position))  # Check if node already exists
					if existing_piece:
						remove_child(existing_piece)  # Remove existing node if present
					var new_piece = piece_scene.instance()
					if new_piece and new_piece is Node2D:
						add_child(new_piece)
						board[x_position][y_position] = new_piece
						new_piece.position = grid_to_pixel(Vector2(x_position, y_position))
						pieces_made += 1
	else:
		print('No more space for new pieces.')


func is_two_or_four():
	var temp = rand_range(0, 100)
	if temp <= (100 - four_piece_change):
		return two_piece
	else:
		return four_piece

func generate_background():
	for i in width:
		for j in height:
			var temp = background_piece.instance()
			add_child(temp)
			temp.position = grid_to_pixel(Vector2(i,j))

func _on_TouchControl_move(direction: Vector2):
	move_all_pieces(direction)

func _on_KeyboardControl_move(direction: Vector2):
	move_all_pieces(direction)
