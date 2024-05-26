extends Node2D

func _ready():
	# Carregar as cenas
	var player_scene = preload("res://player.tscn")
	var bedroom_scene = preload("res://bedroom.tscn")
	
	# Verificar se as cenas foram carregadas corretamente
	if player_scene and bedroom_scene:
		var player = player_scene.instance()
		var bedroom = bedroom_scene.instance()
		
		# Adicionar as instâncias à cena principal
		add_child(bedroom)
		add_child(player)

		# Definir a posição inicial do player
		player.position = Vector2(100, 100)  # Ajuste conforme necessário
	else:
		print("Erro ao carregar as cenas")
