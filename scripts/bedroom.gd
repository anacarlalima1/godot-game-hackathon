extends Control

var book: AnimatedSprite2D
var present: AnimatedSprite2D
var timer: Timer
var present_open = false
var book_visible = false
var book_open = false  # Adicionada a variável book_open

func _ready():
	book = $Livro
	present = $Presente
	timer = Timer.new()
	add_child(timer)

	# Inicialmente, o presente é visível e fechado
	present.play("present_closed")
	book.hide()  # Esconde o livro inicialmente
	print("Script está pronto.")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == Key.KEY_B:
			_handle_b_pressed()
		elif event.keycode == Key.KEY_A:
			_handle_a_pressed()

func _handle_b_pressed():
	if not present_open:
		print("Tecla B pressionada - Abrindo presente.")
		present.play("present_open")
		timer.wait_time = 1.0  # Define o tempo de espera em segundos
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_present_opened"))
		timer.start()
	else:
		print("Tecla B pressionada - Mostrando livro fechado.")
		present.hide()
		book.show()
		book.play("book_closed")
		present_open = false
		book_visible = true

func _on_present_opened():
	print("Presente aberto.")
	present.play("present_opened")
	present_open = true

func _handle_a_pressed():
	if book_visible and not book_open:
		print("Tecla A pressionada - Abrindo livro.")
		book.play("book_open")
		book_open = true  # Atualiza o estado para indicar que o livro está aberto
		timer.wait_time = 2.0  # Define o tempo de espera em segundos
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_book_opened"))
		timer.start()

func _on_book_opened():
	print("Mudando para a próxima cena.")
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
