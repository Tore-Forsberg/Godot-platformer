class_name MagneticLauncher extends Area2D


@onready var player = get_parent()


var magnetic_blast = preload("res://scenes/player_tools/magnetic_blast.tscn")
var can_fire = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	look_at_mouse(mouse_position)
	shoot_magnetic_launcher()


func shoot_magnetic_launcher():
	if Input.is_action_just_pressed("left_click") and can_fire:
		var magnetic_blast_instance = magnetic_blast.instantiate()
		magnetic_blast_instance.rotation = rotation
		magnetic_blast_instance.global_position = global_position
		add_child(magnetic_blast_instance)
		can_fire = false
		await get_tree().create_timer(0.5).timeout
		can_fire = true


func look_at_mouse(mouse_position):
	look_at(mouse_position)
	
	var player_sprite_x = player.animated_sprite.position.x
	var player_sprite_y = player.animated_sprite.position.y
	
	if mouse_position.x > player.position.x:
		position = Vector2(player_sprite_x + 20, player_sprite_y + 2)
	elif mouse_position.x < player.position.x:
		position = Vector2(player_sprite_x - 20, player_sprite_y + 2)
