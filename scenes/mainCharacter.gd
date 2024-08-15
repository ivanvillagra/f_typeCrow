extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var double_jump_enabled: bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D

func _ready():
	# Conectar la señal de animación terminada
	animation.animation_looped.connect(_on_animation_finished)

func _physics_process(delta):
	_handle_gravity(delta)
	_handle_movement(delta)

func _handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if animation.get_animation() != "jump" and animation.get_animation() != "fall":
			animation.play("jump")

func _handle_movement(delta):
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_jump()
	elif Input.is_action_just_pressed("ui_accept") and !is_on_floor() and double_jump_enabled:
		_double_jump()
	elif Input.is_action_just_pressed("ui_down") and !is_on_floor():
		_down_dash()

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animation.flip_h = velocity.x < 0

		if is_on_floor() and animation.get_animation() != "attack":
			animation.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if Input.is_action_just_pressed("ui_down") and is_on_floor():
			_attack()
		elif is_on_floor() and animation.get_animation() != "attack":
			animation.play("idle2")
	
	move_and_slide()

func _jump():
	velocity.y = JUMP_VELOCITY
	double_jump_enabled = true
	if animation.get_animation() != "jump":
		animation.play("jump")

func _double_jump():
	velocity.y = JUMP_VELOCITY
	double_jump_enabled = false
	if animation.get_animation() != "jump":
		animation.play("jump")

func _down_dash():
	velocity.y = -(JUMP_VELOCITY * 2.25)
	if animation.get_animation() != "fall":
		animation.play("fall")

func _attack():
	if animation.get_animation() != "attack1":
		animation.play("attack1")

func _on_animation_finished():
	if animation.get_animation() == "attack1":
		if is_on_floor():
			animation.play("idle2")
