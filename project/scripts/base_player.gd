extends CharacterBody2D

var pos = position

@export var speed = 800

func _physics_process(delta: float) -> void:
	velocity = (Input.get_vector("move_left","move_right","move_up","move_down")*speed)
	move_and_slide()
