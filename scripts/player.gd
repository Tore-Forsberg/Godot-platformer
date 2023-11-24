extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var jump_force = 400
@export var gravity = 40
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
		if velocity.y > 1000:
			velocity.y = 1000 
	else:
		velocity.y = 0
		position.y = screen_size.y - 100
		
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
		animated_sprite.play("idle")
	
	var direction =  Input.get_axis("move_left", "move_right")
	velocity.x = speed * direction
	

	if velocity.x != 0:
		# Gets the AnimatedSprite2D node and plays the walk animation
		animated_sprite.play("walk")
		
		animated_sprite.flip_h = velocity.x < 0
	else:
		# Gets the AnimatedSprite2D node and stops the walk animation by starting the idle animation
		animated_sprite.play("idle")
	
	move_and_slide()
	
#	position += velocity * delta
#	position = position.clamp(Vector2.ZERO, screen_size)
