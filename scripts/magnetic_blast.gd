extends Area2D


@onready var explosion_timer : Timer = $ExplosionTimer
@onready var active_timer : Timer = $ActiveTimer
@onready var projectile_sprite: Sprite2D = $Sprite2D
@onready var projectile_collision: CollisionShape2D = $ProjectileCollisionShape
@onready var explosion_collision: CollisionShape2D = $ExplosionCollisionShape


@export var speed = 2000
@export var explosion_particle : PackedScene
@export var magnetic_blast_knockback = 10


var has_hit_item: bool
var player
var is_explosion_active: bool
var is_hitting_player: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	explosion_collision.disabled = true


func _physics_process(delta):
	if not has_hit_item:
		position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	if is_explosion_active:
		magnetic_blast_explosion()


func _on_explosion_timer_timeout():
	explode()


func _on_active_timer_timeout():
	queue_free()


func explode():
	# Starts an instance of the explosion particles
	var _particle = explosion_particle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	
	# Adds the particle to the scene
	get_tree().current_scene.add_child(_particle)
	
	# Hides the sprite
	projectile_sprite.visible = false
	
	# Disables the projectile collision and enables the explosion collision
	projectile_collision.disabled = true
	explosion_collision.disabled = false
	
	is_explosion_active = true
	active_timer.start()


func magnetic_blast_explosion():
	if player != null:
		var x_velocity = (player.position.x - global_position.x)*magnetic_blast_knockback
		var y_velocity = (player.position.y - global_position.y)*magnetic_blast_knockback
		player.velocity = Vector2(x_velocity, y_velocity)


func _on_body_entered(body):
	if body is Player:
		if is_explosion_active:
			player = body
		return
	has_hit_item = true
	explosion_timer.start()


func _on_body_exited(body):
	if body is Player:
		if is_explosion_active:
			player = null
