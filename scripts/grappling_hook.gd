extends Area2D

@onready var player : CharacterBody2D = $".."
@onready var player_sprite : AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var hook_raycast : RayCast2D = $Raycast

var hook_position = Vector2()
var is_hooked = false
var rope_length = 500
var current_rope_length

# Called when the node enters the scene tree for the first time.
func _ready():
	current_rope_length = rope_length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	
	look_at_mouse(mouse_position)
	hook()
	# update()
	if is_hooked:
		swing(delta)
		player.velocity *= 0.98 # Speed of swing

func look_at_mouse(mouse_position):
	look_at(mouse_position)
	
	if mouse_position.x > player.position.x:
		player_sprite.flip_h = false
		position = Vector2(player_sprite.position.x + 20, player_sprite.position.y + 2)
	elif mouse_position.x < player.position.x:
		player_sprite.flip_h = true
		position = Vector2(player_sprite.position.x - 20, player_sprite.position.y + 2)

func hook():
	if Input.is_action_just_pressed("left_click"):
		hook_position = get_hook_position();
		if hook_position:
			is_hooked = true
			current_rope_length = global_position.distance_to(hook_position)
			
func get_hook_position():
	for raycast in hook_raycast.get_children():
		if raycast.is_colliding():
			return raycast.get_collision_point()

func swing(delta):
	var radius = global_position - hook_position
	if player.velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(player.velocity) / (radius.length() * player.velocity.length()))
	var rad_vel = cos(angle) * player.velocity.length()
	player.velocity += radius.normalized() * -rad_vel
	
	if global_position.distance_to(hook_position) > current_rope_length:
		global_position = hook_position + radius.normalized() * current_rope_length
	
	player.velocity += (hook_position - global_position).normalized() * 15000 *delta
