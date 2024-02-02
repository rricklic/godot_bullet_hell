extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_detect_collision)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _detect_collision(area: Area2D) -> void:
	print("Collision: " + str(area.get_rid()))
