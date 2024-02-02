extends CharacterBody2D


@onready var left_raycast : RayCast2D = $LeftRayCast
@onready var right_raycast : RayCast2D = $RightRayCast

@export var movement_range = 1000
@export var speed = 200
@export var bounce_value = 1000


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.x = speed

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if left_raycast.is_colliding() or right_raycast.is_colliding():
		velocity.x *= -1

	move_and_slide()


func death():
	queue_free()


func _on_top_checker_body_entered(body):
	if body is Player:
		body.velocity.y -= bounce_value
		death()


func _on_side_checker_body_entered(body):
	if body is Player:
		body.death()
