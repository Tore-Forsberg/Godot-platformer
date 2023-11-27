extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer : Timer = $JumpTimer
@onready var jump_buffer_timer : Timer = $JumpBufferTimer

@export var speed = 700 # This is the max speed of the player
@export var acceleration = 90
@export var deceleration = 25

@export var jump_height = 220
@export var time_to_jump_peak = 0.35 # The time it takes to reach the jump_height

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
	manage_jump_conditions()
	
	manage_movement()
	manage_jump(delta)
	manage_animations()
	
	move_and_slide()


func manage_movement():
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, speed)
	if Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -speed)

	if velocity.x > 0 or velocity.x < 0:
			if velocity.x > 0:
				velocity.x = max(velocity.x - deceleration, 0)
			elif velocity.x < 0:
				velocity.x = min(velocity.x + deceleration, 0)


func manage_jump_conditions():
	if is_on_floor():
		is_jump_available = true
		if is_jump_buffer_pressed == true:
			jump()
	elif is_jump_available == true && coyote_jump_timer.is_stopped():
		coyote_jump_timer.start()


func manage_jump(delta):
	if Input.is_action_just_pressed("jump"):
		if is_jump_available == true:
			jump()
		else:
			is_jump_buffer_pressed = true
			jump_buffer_timer.start()
	else:
		velocity.y += gravity*delta


func jump():
	velocity.y = -jump_force
	animated_sprite.play("idle")


func _on_jump_timer_timeout():
	is_jump_available = false


func _on_jump_buffer_timer_timeout():
	is_jump_buffer_pressed = false


func manage_animations():
	if velocity.x != 0:
		# Gets the AnimatedSprite2D node and plays the walk animation
		if is_on_floor():
			animated_sprite.play("walk")
		animated_sprite.flip_h = velocity.x < 0
	else:
		# Gets the AnimatedSprite2D node and stops the walk animation by starting the idle animation
		animated_sprite.play("idle")
