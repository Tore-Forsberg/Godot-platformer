extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(100, screen_size.y - 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# Gets the AnimatedSprite2D node and plays the walk animation
		$AnimatedSprite2D.play("walk")
		
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		# Gets the AnimatedSprite2D node and stops the walk animation
		$AnimatedSprite2D.play("idle")
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
