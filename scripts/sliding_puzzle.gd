extends Area2D

var tiles = []
var solved = []
var mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
	print('hi')
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5, $Tile6, $Tile7, $Tile8, $Tile9, $Tile10, $Tile11, $Tile12, $Tile13, $Tile14, $Tile15, $Tile16 ]
	solved = tiles.duplicate()
	for tile in tiles:
		tile.position.y += 140  # Ajusta a posição vertical inicial dos tiles
	shuffle_tiles()

func shuffle_tiles():
	var previous = 99
	var previous_1 = 98
	for t in range(0,10):
		var tile = randi() % 16
		if tiles[tile] != $Tile16 and tile != previous and tile != previous_1:
			var rows = int((tiles[tile].position.y - 140) / 90)  # Ajusta o cálculo das linhas
			var cols = int(tiles[tile].position.x / 90)
			check_neighbours(rows,cols)
			previous_1 = previous
			previous = tile

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		print('mouse', mouse.position)
		mouse = false
		var rows = int((mouse_copy.position.y - 140) / 90)  # Ajusta o cálculo das linhas
		var cols = int(mouse_copy.position.x / 90)
		# print(rows, ", ", cols)
		var pos = rows * 4 + cols
		print(tiles[pos])
		check_neighbours(rows,cols)
		if tiles == solved:
			print("You win!")
			get_tree().change_scene_to_file("res://scenes/vitoria.tscn")

func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols
	
	if rows < 0 or rows >= 4 or cols < 0 or cols >= 4:
		print("Posição inválida")
		return
	
	while !empty and !done:
		var tile = tiles[pos]
		if tile == null:
			print("Tile não encontrado")
			return
		
		var new_pos = tile.position
		
		if rows < 3:
			new_pos.y += 90
			empty = find_empty(new_pos, pos)
			new_pos.y -= 90
		if rows > 0:
			new_pos.y -= 90
			empty = find_empty(new_pos, pos)
			new_pos.y += 90
		if cols < 3:
			new_pos.x += 90
			empty = find_empty(new_pos, pos)
			new_pos.x -= 90
		if cols > 0:
			new_pos.x -= 90
			empty = find_empty(new_pos, pos)
			new_pos.x += 90
		
		done = true

func find_empty(position, pos):
	var new_rows = int((position.y - 140) / 90)  # Ajusta o cálculo das linhas
	var new_cols = int(position.x / 90)
	var new_pos = new_rows * 4 + new_cols
	if new_pos >= 0 and new_pos < tiles.size() and tiles[new_pos] == $Tile16:
		swap_tiles(pos, new_pos)
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mouse = event
			print("Left button was clicked at ", event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			print("Wheel up")
