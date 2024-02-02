class_name BulletSpawner
extends Node2D

@export var radius: float = 10.0
@export var max_lifetime: float = 10.0
@export var bounding_box: Rect2
@export var bullet_image: Texture2D
@export var image_change_offset: float = 0.2

var bullets: Array[Bullet]

@onready var bullet_image_half: Vector2 = bullet_image.get_size() / 2.0
@onready var origin: Marker2D = $Origin
@onready var shared_area: Area2D = $SharedArea

func spawn_bullet(velocity: Vector2, speed: float = 200) -> void:
	var bullet : Bullet = Bullet.new(velocity, origin.position, speed)
	_config_bullet(bullet)
	bullets.append(bullet)

func _ready() -> void:
	pass
		
func _exit_tree() -> void:
	for bullet: Bullet in bullets:
		PhysicsServer2D.free_rid(bullet.shape_id)
	bullets.clear()

func _physics_process(delta: float) -> void:
	var transform: Transform2D = Transform2D()
	var free_queue: Array[Bullet] = []
	
	for i in range(0, bullets.size()):
		var bullet: Bullet = bullets[i]
		
		if !bounding_box.has_point(bullet.position) || bullet.lifetime >= max_lifetime:
			free_queue.append(bullet)
			continue

		# Move the bullet and the collision
		var offset: Vector2 = Vector2(bullet.velocity.normalized() * bullet.speed * delta)
		bullet.position += offset
		transform.origin = bullet.position
		PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), i, transform)
		
		bullet.animation_lifetime += delta
		bullet.lifetime += delta
	
	for bullet: Bullet in free_queue:
		PhysicsServer2D.free_rid(bullet.shape_id)
		bullets.erase(bullet)
	
	queue_redraw()

func _draw() -> void:
	for i in range(0, bullets.size()):
		var bullet = bullets[i]
		draw_texture(bullet_image, bullet.position - bullet_image_half)

func _config_bullet(bullet: Bullet) -> void:
	# Define the shape's position
	var transform := Transform2D(0, position)
	transform.origin = bullet.position
	  
	# Create the shape
	var circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(circle_shape, radius)

	# Add the shape to the shared area
	PhysicsServer2D.area_add_shape(shared_area.get_rid(), circle_shape, transform)
	
	# Register the generated id to the bullet
	bullet.shape_id = circle_shape
