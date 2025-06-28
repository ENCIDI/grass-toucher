extends CharacterBody2D

var pos = position

@export var speed = 800
@export var stats = {
	hp = 500,
	stamina = 500
}

func move():
	velocity = (Input.get_vector("move_left","move_right","move_up","move_down")*speed)
	move_and_slide()

func _physics_process(delta: float) -> void:
	move()
