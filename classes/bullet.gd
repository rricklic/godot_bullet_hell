class_name Bullet
extends Object

var shape_id: RID
var velocity: Vector2
var position: Vector2
var speed: float
var lifetime: float = 0.0
var animation_lifetime: float = 0.0
#var image_offset: int = 0
var layer: String = "front"

# Constructor
func _init(velocity: Vector2, position: Vector2, speed: float) -> void:
	self.velocity = velocity
	self.position = position
	self.speed = speed
