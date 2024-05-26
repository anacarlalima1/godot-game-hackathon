extends Area2D
#
@export var speed = 400
var screen_size
var destination = Vector2.ZERO
var is_mouse_pressed = false

func _ready():
	screen_size = get_viewport_rect().size
	destination = position  # Inicialmente, o destino é a posição atual

func _process(delta):
	var velocity = Vector2.ZERO 

	# Verifica se o mouse foi clicado
	if Input.is_action_pressed("click"):
		is_mouse_pressed = true
		destination = get_global_mouse_position()
	else:
		is_mouse_pressed = false

	# Calcula a direção para o destino
	var direction = destination - position
	if direction.length() > 1:
		velocity = direction.normalized() * speed
#
	# Atualiza a posição do personagem
	position += velocity * delta

	# Garante que o personagem permaneça dentro dos limites da tela
	position = position.clamp(Vector2.ZERO, screen_size)
#
	# Animações de movimento
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				$AnimatedSprite2D.animation = "walk_right"
			else:
				$AnimatedSprite2D.animation = "walk_left"
		else:
			if velocity.y > 0:
				$AnimatedSprite2D.animation = "walk"
			else:
				$AnimatedSprite2D.animation = "back_walk"
	else:
		if is_mouse_pressed:
			if destination.x > position.x:
				$AnimatedSprite2D.animation = "walk_right"
			elif destination.x < position.x:
				$AnimatedSprite2D.animation = "walk_left"
			elif destination.y < position.y:
				$AnimatedSprite2D.animation = "walk"
			elif destination.y > position.y:
				$AnimatedSprite2D.animation = "back_walk"
		else:
			if $AnimatedSprite2D.animation == "walk_right" or $AnimatedSprite2D.animation == "stop_right":
				$AnimatedSprite2D.animation = "stop_right"
			elif $AnimatedSprite2D.animation == "walk_left" or $AnimatedSprite2D.animation == "stop_left":
				$AnimatedSprite2D.animation = "stop_left"
			elif $AnimatedSprite2D.animation == "walk" or $AnimatedSprite2D.animation == "stop":
				$AnimatedSprite2D.animation = "stop"
			elif $AnimatedSprite2D.animation == "walk" or $AnimatedSprite2D.animation == "back":
				$AnimatedSprite2D.animation = "back"
