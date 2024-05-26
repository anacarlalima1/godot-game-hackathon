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

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		print('oi')
		var mouse_copy = mouse
		print('oi', mouse.position)
		mouse = false
		var rows = int(mouse_copy.position.y / 250)
		var cols = int(mouse_copy.position.x / 250)

		if tiles == solved:
			print("You win!")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print("mouse button event at ", event.position)
