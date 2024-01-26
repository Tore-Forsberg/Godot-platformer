extends Area2D


@onready var explosion_timer : Timer = $ExplosionTimer
@onready var active_timer : Timer = $ActiveTimer
@onready var projectile_sprite: Sprite2D = $Sprite2D


@export var speed = 2000
@export var explosion_particle : PackedScene


var has_hit_item: bool
var player = preload("res://scenes/player.tscn")
var is_explosion_active: bool
var is_hitting_player: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not has_hit_item:
		position += (Vector2.RIGHT*speed).rotated(rotation) * delta


func _physics_process(delta):
	await get_tree().create_timer(0.01).timeout
	set_physics_process(false)


func _on_explosion_timer_timeout():
	explode()


func _on_active_timer_timeout():
	queue_free()


func explode():
	#queue_free()
	var _particle = explosion_particle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	scale = Vector2(12, 12)
	projectile_sprite.visible = false
	get_tree().current_scene.add_child(_particle)
	is_explosion_active = true
	active_timer.start()
	


func _on_body_entered(body):
	if body is CharacterBody2D:
		if is_explosion_active:
			is_hitting_player = true
		return
	has_hit_item = true
	explosion_timer.start()
