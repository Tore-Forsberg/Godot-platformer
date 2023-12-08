extends Area2D

@onready var player : CharacterBody2D = $".."
@onready var player_sprite : AnimatedSprite2D = $"../AnimatedSprite2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	if mouse_position.x > player.position.x:
		player_sprite.flip_h = false
		position = Vector2(player_sprite.position.x + 20, player_sprite.position.y + 2)
	elif mouse_position.x < player.position.x:
		player_sprite.flip_h = true
		position = Vector2(player_sprite.position.x - 20, player_sprite.position.y + 2)
