extends Control

# Array para armazenar as sprites
var sprites = []
var current_sprite_index = 0

func _ready():
	# Adicione as sprites ao array
	sprites.append($Capa)
	sprites.append($Inicio)
	sprites.append($History)
	sprites.append($Desafio)

	# Inicialmente, mostre apenas a primeira sprite
	show_sprite(current_sprite_index)

	# Conecte o sinal de clique das sprites ao método _on_sprite_pressed
	for sprite in sprites:
		sprite.connect("pressed", Callable(self, "_on_sprite_pressed"))

func _on_sprite_pressed():
	# Verifica se a sprite atual é a última
	if current_sprite_index == sprites.size() - 1:
		change_to_puzzle_scene()
	else:
		# Oculta a sprite atual
		sprites[current_sprite_index].hide()

		# Avança para a próxima sprite
		current_sprite_index += 1

		# Mostra a próxima sprite
		show_sprite(current_sprite_index)

func show_sprite(index):
	# Oculta todas as sprites
	for sprite in sprites:
		sprite.hide()

	# Mostra a sprite especificada
	sprites[index].show()

func change_to_puzzle_scene():
	print("Mudando para a cena do quebra-cabeça.")
	get_tree().change_scene_to_file("res://scenes/sliding_puzzle.tscn")
