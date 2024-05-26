extends Control

var book: AnimatedSprite2D
var timer: Timer

func _ready():
	book = $Livro
	timer = Timer.new()
	add_child(timer)

	# Inicialmente, o livro é visível e fechado
	book.play("book_closed")
	print("Script está pronto.")

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == Key.KEY_A:
		print("Tecla A pressionada.")
		if book.animation == "book_closed":
			book.play("book_open")
			print("Livro foi aberto!")
			timer.wait_time = 2.0  # Define o tempo de espera em segundos
			timer.one_shot = true
			timer.connect("timeout", Callable(self, "_on_timer_timeout"))
			timer.start()

func _on_timer_timeout():
	print("Mudando para a próxima cena.")
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
