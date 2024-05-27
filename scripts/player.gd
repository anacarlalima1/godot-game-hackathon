extends Area2D

@export var speed = 200  # Ajuste a velocidade conforme necessário
var screen_size
var destination = Vector2.ZERO
var is_mouse_pressed = false

func _ready():
	screen_size = get_viewport_rect().size
	destination = position  # Define a posição inicial como destino para evitar movimento imediato

func _process(delta):
	var velocity = Vector2.ZERO

	# Movimento controlado pelo clique do mouse
	if Input.is_action_pressed("click"):
		is_mouse_pressed = true
		destination = get_global_mouse_position()
	else:
		is_mouse_pressed = false

	var direction = destination - position
	var distance = direction.length()

	# Ajuste a distância mínima para parar o movimento
	if distance > 10:
		velocity = direction.normalized() * speed

	# Atualiza a posição do personagem com detecção de colisão
	move_and_collide_custom(velocity * delta)

	# Garante que o personagem permaneça dentro dos limites da tela
	position = position.clamp(Vector2.ZERO, screen_size)

	# Animações de movimento
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				if $AnimatedSprite2D.animation != "walk_right":
					$AnimatedSprite2D.play("walk_right")
			else:
				if $AnimatedSprite2D.animation != "walk_left":
					$AnimatedSprite2D.play("walk_left")
		else:
			if velocity.y > 0:
				if $AnimatedSprite2D.animation != "walk":
					$AnimatedSprite2D.play("walk")
			else:
				if $AnimatedSprite2D.animation != "back_walk":
					$AnimatedSprite2D.play("back_walk")
	else:
		if $AnimatedSprite2D.animation == "walk_right" or $AnimatedSprite2D.animation == "stop_right":
			$AnimatedSprite2D.play("stop_right")
		elif $AnimatedSprite2D.animation == "walk_left" or $AnimatedSprite2D.animation == "stop_left":
			$AnimatedSprite2D.play("stop_left")
		elif $AnimatedSprite2D.animation == "walk":
			$AnimatedSprite2D.play("stop")
		elif $AnimatedSprite2D.animation == "back_walk" or $AnimatedSprite2D.animation == "back":
			$AnimatedSprite2D.play("back")

func move_and_collide_custom(velocity):
	var new_position = position + velocity
	var collision = false

	for area in get_overlapping_areas():
		if area.name == "Escrivaninha" or area.name == "Cadeira":
			collision = true
			break

	if not collision:
		position = new_position
