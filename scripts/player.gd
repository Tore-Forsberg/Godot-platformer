class_name Player extends CharacterBody2D


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer : Timer = $JumpTimer
@onready var jump_buffer_timer : Timer = $JumpBufferTimer
@onready var magnetic_launcher : Area2D = $MagneticLauncher


@export var top_speed = 700 # This is the max speed of the player
@export var acceleration = 90
@export var deceleration = 25
@export var jump_height = 220
@export var time_to_jump_peak = 0.35 # The time it takes to reach the jump_height


var air_acceleration = acceleration/2.4
var air_deceleration = deceleration/2.4
var is_jump_buffer_pressed: bool
var jump_force: float
var wall_jump_force: float
var gravity: float
var wall_slide_friction: float
var is_jump_available: bool
var is_left_last_direction: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play("idle")
	
	gravity = (2*jump_height)/pow(time_to_jump_peak, 2)
	wall_slide_friction = gravity/1.5
	jump_force = gravity * time_to_jump_peak
	wall_jump_force = -jump_force * 0.75


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	manage_movement()
	manage_jump_conditions()
	manage_jump(delta)
	manage_animations()
	
	var mouse_position = get_global_mouse_position()
	look_at_mouse(mouse_position)

	move_and_slide()


func manage_movement():
	if Input.is_action_pressed("move_right"):
		is_left_last_direction = false
		if is_on_floor():
			if velocity.x < top_speed:
				velocity.x += acceleration
		else:
			if velocity.x < top_speed:
				velocity.x += air_acceleration

	if Input.is_action_pressed("move_left"):
		is_left_last_direction = true
		if is_on_floor():
			if velocity.x > -top_speed:
				velocity.x -= acceleration
		else:
			if velocity.x > -top_speed:
				velocity.x -= air_acceleration

	if velocity.x > 0 or velocity.x < 0:
		if is_on_floor():
			if velocity.x > 0:
				is_left_last_direction = false
				velocity.x = max(velocity.x - deceleration, 0)
			elif velocity.x < 0:
				is_left_last_direction = true
				velocity.x = min(velocity.x + deceleration, 0)
		else:
			if velocity.x > 0:
				is_left_last_direction = false
				velocity.x = max(velocity.x - air_deceleration, 0)
			elif velocity.x < 0:
				is_left_last_direction = true
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
		velocity.y += gravity*delta
		if is_on_wall_only():
			var is_moving : bool = Input.get_axis("move_left", "move_right") != 0
			var is_falling : bool = velocity.y > 0
			var is_wall_sliding : bool = is_moving and is_falling
			if is_wall_sliding == true:
				velocity.y -= wall_slide_friction*delta


func jump():
	animated_sprite.play("idle")
	if is_on_floor():
		velocity.y = -jump_force
	if is_on_wall_only():
		velocity.y = wall_jump_force
		if is_left_last_direction == true:
			velocity.x = top_speed
		if is_left_last_direction == false:
			velocity.x = -top_speed


func manage_animations():
	if velocity.x != 0:
		# Gets the AnimatedSprite2D node and plays the walk animation
		if is_on_floor():
			animated_sprite.play("walk")
	else:
		# Gets the AnimatedSprite2D node and stops the walk animation by starting the idle animation
		animated_sprite.play("idle")


func look_at_mouse(mouse_position):
	if mouse_position.x > position.x:
		animated_sprite.flip_h = false
	elif mouse_position.x < position.x:
		animated_sprite.flip_h = true


func _on_jump_timer_timeout():
	is_jump_available = false


func _on_jump_buffer_timer_timeout():
	is_jump_buffer_pressed = false
