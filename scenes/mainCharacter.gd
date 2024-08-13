extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var doubleJump:bool = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = $AnimatedSprite2D

func _physics_process(delta):

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		doubleJump = true
		
	if not is_on_floor():
		velocity.y += gravity * delta
		animation.play("jump")
		
	_doubleJump()
	_downDash()
	_walk()
	_attack()
	move_and_slide()

func _doubleJump():
	# double jump.
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor() and doubleJump:
		velocity.y = JUMP_VELOCITY
		doubleJump = false

func _downDash():
	# Down dash.
	if Input.is_action_just_pressed("ui_down") and !is_on_floor():
		velocity.y = -(JUMP_VELOCITY * 2.25)
		
func _walk():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED

		if velocity.x < 0:
			animation.flip_h = true
		elif velocity.x > 0:
			animation.flip_h = false
		
		if is_on_floor():
			animation.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animation.play("idle2")
		

func _attack():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		animation.play("attack1")
		
	
