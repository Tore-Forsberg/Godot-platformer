extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
@export var acceleration = 20
@export var deacceleration = 10
@export var jump_force = 800
@export var gravity = 30
var screen_size # Size of the game window.
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(100, screen_size.y - 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	if !is_on_floor():
		velocity.y += gravity
		animated_sprite.play("idle")
		if velocity.y > 1000:
			velocity.y = 1000
	else:
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_force
	
	var direction =  Input.get_axis("move_left", "move_right")
	velocity.x = min(velocity.x + (acceleration * direction), speed)
	if velocity.x > 0 or velocity.x < 0:
		if direction != 0:
			velocity.x -= deacceleration*direction
		else:
			if velocity.x > 0:
				velocity.x -= deacceleration
			else:
				velocity.x += deacceleration
	

	if velocity.x != 0:
		# Gets the AnimatedSprite2D node and plays the walk animation
		if is_on_floor():
			animated_sprite.play("walk")
		
		animated_sprite.flip_h = velocity.x < 0
	else:
		# Gets the AnimatedSprite2D node and stops the walk animation by starting the idle animation
		animated_sprite.play("idle")
	
	move_and_slide()
