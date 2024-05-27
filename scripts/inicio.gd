extends Node

func _ready():
	print("Cena inicial pronta. Aguardando clique para mudar para a cena principal.")
	# Habilita a detecção de eventos de entrada
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Clique detectado. Carregando a cena principal.")
		get_tree().change_scene_to_file("res://scenes/main.tscn")
