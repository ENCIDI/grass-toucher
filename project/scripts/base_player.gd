extends CharacterBody2D

var pos : Vector2 = position

@export var stats = {
	"max_hp": 100,
	"max_stamina": 100,
	"speed": 800,
	"sprint_multiplier": 1.5,
	"overjump_kd": 3,
	"interaction_kd": 3,
}

var hp : int = stats["max_hp"]
var stamina : float = stats["max_stamina"]

signal stats_changed(current_health, max_health, current_stamina, max_stamina)

func send_ui_data():
	stats_changed.emit(hp, stats["max_hp"], stamina, stats["max_stamina"])

func _ready() -> void:
	send_ui_data()

func move():
	var is_sprinting = false
	
	if Input.is_action_pressed("sprint") and stamina > 0 and (
	Input.is_action_pressed("move_down") or 
	Input.is_action_pressed("move_up") or 
	Input.is_action_pressed("move_right") or 
	Input.is_action_pressed("move_left")):
		is_sprinting = true
		stamina -= 1
		send_ui_data()
	else:
		is_sprinting = false
		if stamina < stats["max_stamina"]:
			stamina += 0.25
			send_ui_data()
	if stamina > stats["max_stamina"]:
			stamina = stats["max_stamina"]
			send_ui_data()
	if stamina < 0:
			stamina = 0
			send_ui_data()
	
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

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move()
	take_damage()
	heal()
	deal_damage()
