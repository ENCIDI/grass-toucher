extends CharacterBody2D

var pos = position

@export var stats = {
	"max_hp": 100,
	"max_stamina": 100,
	"speed": 800,
	"sprint_multiplier": 1.5,
	"overjump_kd": 3,
	"interaction_kd": 3,
}

func _ready() -> void:
	pass

func move():
	var is_sprinting = false
	var run_time_left = stats["max_stamina"]
	
	if Input.is_action_pressed("sprint") and run_time_left > 0:
		is_sprinting = true
		run_time_left -= 3
	else:
		is_sprinting = false
		if run_time_left < stats["max_stamina"]:
			run_time_left += 1
	if run_time_left > stats["max_stamina"]:
			run_time_left = stats["max_stamina"]
	if run_time_left < 0:
			run_time_left = 0
	
	var move_speed = stats["speed"]
	
	if is_sprinting:
		move_speed = stats["speed"] * stats["sprint_multiplier"]
	elif not is_sprinting:
		move_speed = stats["speed"]
	
	velocity = (Input.get_vector("move_left","move_right","move_up","move_down")*move_speed)
	move_and_slide()

func take_damage():
	pass

func heal():
	pass

func deal_damage():
	pass

func _physics_process(delta: float) -> void:
	move()
	take_damage()
	heal()
	deal_damage()
