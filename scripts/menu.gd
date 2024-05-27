extends Control

# Array para armazenar as sprites
var sprites = []
var current_sprite_index = 0

func _ready():
	# Adicione as sprites ao array
	sprites.append($Capa)
	sprites.append($Inicio)
	sprites.append($History)

	# Inicialmente, mostre apenas a primeira sprite
	show_sprite(current_sprite_index)

	# Conecte o sinal de clique das sprites ao método _on_sprite_pressed
	for sprite in sprites:
		sprite.connect("pressed", Callable(self, "_on_sprite_pressed"))

func _on_sprite_pressed():
	# Oculta a sprite atual
	sprites[current_sprite_index].hide()

	# Avança para a próxima sprite
	current_sprite_index = (current_sprite_index + 1) % sprites.size()

	# Mostra a próxima sprite
	show_sprite(current_sprite_index)

func show_sprite(index):
	# Oculta todas as sprites
	for sprite in sprites:
		sprite.hide()

	# Mostra a sprite especificada
	sprites[index].show()
