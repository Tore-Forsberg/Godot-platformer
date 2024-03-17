extends CharacterBody2D


@onready var left_raycast : RayCast2D = $LeftRayCast
@onready var right_raycast : RayCast2D = $RightRayCast
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D


@export var speed = 200
@export var bounce_value = 1200


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animated_sprite.play("default")
	if speed < 0:
		animated_sprite.flip_h = true
	velocity.x = speed

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	check_for_collision()

	move_and_slide()


func death():
	queue_free()


func check_for_collision():
	var is_hitting_wall = left_raycast.is_colliding() or right_raycast.is_colliding()
	if is_hitting_wall:
		var collision
		if left_raycast.is_colliding():
			collision = left_raycast.get_collider()
		if right_raycast.is_colliding():
			collision = right_raycast.get_collider()
		if not collision is Player:
			velocity.x *= -1
			animated_sprite.flip_h = not animated_sprite.flip_h


func _on_top_checker_body_entered(body):
	if body is Player:
		body.velocity.y -= bounce_value
		death()
