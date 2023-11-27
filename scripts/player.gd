extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer : Timer = $JumpTimer

@export var speed = 600 # How fast the player will move (pixels/sec).
@export var acceleration = 25
@export var deacceleration = 15

@export var time_to_jump_peak = 0.5
@export var jump_height = 200

var is_jump_buffer_pressed: bool

var jump_force: float
var gravity: float

var is_jump_available: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")
	
	gravity = (2*jump_height)/pow(time_to_jump_peak, 2)
	jump_force = gravity * time_to_jump_peak


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if is_on_floor():
		is_jump_available = true
	elif is_jump_available == true && coyote_jump_timer.is_stopped():
		coyote_jump_timer.start()

	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, speed)
	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -speed)

	if velocity.x > 0 or velocity.x < 0:
			if velocity.x > 0:
				velocity.x = max(velocity.x - deacceleration, 0)
			elif velocity.x < 0:
				velocity.x = min(velocity.x + deacceleration, 0)


	if Input.is_action_just_pressed("jump"):
		if is_jump_available == true:
			jump()
	else:
		velocity.y += gravity*delta

	if velocity.x != 0:
		# Gets the AnimatedSprite2D node and plays the walk animation
		if is_on_floor():
			animated_sprite.play("walk")
		
		animated_sprite.flip_h = velocity.x < 0
	else:
		# Gets the AnimatedSprite2D node and stops the walk animation by starting the idle animation
		animated_sprite.play("idle")
	
	move_and_slide()

func jump():
	velocity.y = -jump_force
	animated_sprite.play("idle")

func _on_jump_timer_timeout():
	is_jump_available = false
