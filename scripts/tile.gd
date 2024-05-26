extends TextureButton

signal tile_pressed(position)

var position_in_grid = Vector2()
var game
var sprite  # Referência ao Sprite

# Função chamada quando o nó está pronto
func _ready():
	sprite = $TileSprite  # Obtenha a referência ao Sprite
	connect("pressed", Callable(self, "_on_tile_pressed"))
	_adjust_button_and_sprite()

# Função chamada quando o tile é pressionado
func _on_tile_pressed():
	emit_signal("tile_pressed", position_in_grid)

# Função para definir a textura do tile
func set_texture(texture):
	if sprite:
		sprite.texture = texture
		_adjust_button_and_sprite()

# Função para ajustar o tamanho do botão e do sprite
func _adjust_button_and_sprite():
	if sprite.texture:
		var texture_size = sprite.texture.get_size()
		var button_size = custom_minimum_size
		var scale_x = button_size.x / texture_size.x
		var scale_y = button_size.y / texture_size.y
		var scale_factor = min(scale_x, scale_y)
		sprite.scale = Vector2(scale_factor, scale_factor)
		# Centralizar o sprite no botão
		sprite.centered = true

# Função para ajustar o tamanho mínimo do botão
func set_button_size(size: Vector2):
	custom_minimum_size = size
