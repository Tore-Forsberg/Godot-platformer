extends Area2D


@onready var explosion_timer : Timer = $ExplosionTimer


@export var speed = 2000
@export var explosion_particle : PackedScene

var has_hit_item: bool


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


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_explosion_timer_timeout():
	explode()


func explode():
	var _particle = explosion_particle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle) 
	queue_free()


func _on_body_entered(body):
	if body is CharacterBody2D:
		return
	has_hit_item = true
	explosion_timer.start()
