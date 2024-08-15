extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var double_jump_enabled: bool = true
var attacking: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D

func _ready():
	animation.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	_handle_gravity(delta)
	_handle_movement(delta)
	move_and_slide()
	
func _handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if animation.get_animation() != "jump" and animation.get_animation() != "fall":
			animation.play("jump")

func _handle_movement(delta):
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !attacking:
		_jump()
	elif Input.is_action_just_pressed("ui_accept") and !is_on_floor() and double_jump_enabled:
		_double_jump()
	elif Input.is_action_just_pressed("ui_down") and !is_on_floor():
		_down_dash()
	elif Input.is_action_just_pressed("ui_down") and is_on_floor():
		_attack() 

	if !attacking:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			velocity.x = direction * SPEED
			animation.flip_h = velocity.x < 0

			if is_on_floor() and animation.get_animation() != "attack":
				animation.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and !attacking:
				animation.play("idle2")


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

func _attack():
	attacking = true
	velocity.x = move_toward(velocity.x, 0, SPEED)
	animation.play("attack1")
		
func _on_animation_finished():
	if  is_on_floor():
			attacking = false
	
