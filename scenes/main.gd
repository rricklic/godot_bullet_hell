extends Node2D

@export var bullets_per_ring: int = 40
var boundary_rect: Rect2

var original_vector = Vector2(-1, 0)
var rotation_difference = (2.0 * PI) / bullets_per_ring

@onready var bullet_spawner: BulletSpawner = $BulletSpawner
@onready var timer: Timer = $Timer
func _ready() -> void:
	timer.timeout.connect(_spawn_bullet)

# Spawn a bullet wave with a slightly different rotation
func _spawn_bullet() -> void:
	for i in range(0, bullets_per_ring):
		var movement = original_vector.rotated(rotation_difference * i)
		bullet_spawner.spawn_bullet(movement, 100)
	original_vector = original_vector.rotated(PI / 32.0)
