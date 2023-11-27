extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer : Timer = $JumpTimer
@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var wall_hug_timer : Timer = $WallHugTimer


@export var speed = 700 # This is the max speed of the player
@export var acceleration = 90
@export var deceleration = 25

var air_acceleration = acceleration/2.4
var air_deceleration = deceleration/2.4

@export var jump_height = 220
@export var time_to_jump_peak = 0.35 # The time it takes to reach the jump_height

var is_jump_buffer_pressed: bool

var jump_force: float
var gravity: float

var is_jump_available: bool

var is_wall_hugging = false
var has_hugged_wall: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")
	
	gravity = (2*jump_height)/pow(time_to_jump_peak, 2)
	jump_force = gravity * time_to_jump_peak


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	manage_wall_hug()
	manage_jump_conditions()
	
	manage_movement()
	manage_jump(delta)
	manage_animations()
	
	move_and_slide()


func manage_movement():
	if Input.is_action_pressed("move_right"):
		if is_on_floor():
			velocity.x = min(velocity.x + acceleration, speed)
		else:
			velocity.x = min(velocity.x + air_acceleration, speed)
	if Input.is_action_pressed("move_left"):
		if is_on_floor():
			velocity.x = max(velocity.x - acceleration, -speed)
		else:
			velocity.x = max(velocity.x - air_acceleration, -speed)

	if velocity.x > 0 or velocity.x < 0:
		if is_on_floor():
			if velocity.x > 0:
				velocity.x = max(velocity.x - deceleration, 0)
			elif velocity.x < 0:
				velocity.x = min(velocity.x + deceleration, 0)
		else:
			if velocity.x > 0:
				velocity.x = max(velocity.x - air_deceleration, 0)
			elif velocity.x < 0:
				velocity.x = min(velocity.x + air_deceleration, 0)


func manage_jump_conditions():
	if is_on_floor() or is_on_wall_only():
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
		if is_wall_hugging == false:
			velocity.y += gravity*delta


func jump():
	velocity.y = -jump_force
	animated_sprite.play("idle")
	if is_on_wall_only():
		velocity.y = -jump_force * 0.8
		if animated_sprite.flip_h ==true:
			velocity.x = speed
		else:
			velocity.x = -speed


func manage_wall_hug():
	if is_on_floor() or (not is_on_floor() and not is_on_wall()):
		has_hugged_wall == false
	elif is_on_wall_only() and has_hugged_wall == false:
		velocity.x = 0
		velocity.y = 0
		has_hugged_wall = true
		is_wall_hugging = true
		wall_hug_timer.start()
		


func _on_wall_hug_timer_timeout():
	is_wall_hugging = false


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
