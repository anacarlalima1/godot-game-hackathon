extends Node2D

func _ready():
	# Obter as dimensões da viewport
	var viewport_size = get_viewport_rect().size
	
	# Ajustar o tamanho e posição do TextureRect "Wall" para cobrir a parte superior da tela
	var wall = $Wall
	wall.rect_min_size = viewport_size
	wall.rect_size = Vector2(viewport_size.x, viewport_size.y * 0.5)
	wall.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	wall.rect_position = Vector2(0, 0)  # Posição na parte superior

	# Ajustar o tamanho e posição do TextureRect "Floor" para cobrir a parte inferior da tela
	var floor = $Floor
	floor.rect_min_size = viewport_size
	floor.rect_size = Vector2(viewport_size.x, viewport_size.y * 0.5)
	floor.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	floor.rect_position = Vector2(0, viewport_size.y * 0.5)  # Posição na parte inferior
