extends CharacterBody2D

@export var base_stats = {
	"max_hp": 100,
	"max_stamina": 100,
	"speed": 800,
	"sprint_multiplier": 1.4,
	"overjump_kd": 3,
	"interaction_kd": 3,
}

@onready var sprite = $sprite_map

var pos : Vector2 = position

var hp : int = base_stats["max_hp"]
var stamina : float = base_stats["max_stamina"]
var is_attacking : bool = false

signal stats_changed(current_health, max_health, current_stamina, max_stamina)
signal damage(amount)

var is_sprinting : bool = false
var can_sprint : bool = true

func send_ui_data():
	stats_changed.emit(hp, base_stats["max_hp"], stamina, base_stats["max_stamina"])

func _ready() -> void:
	send_ui_data()

func anim():
	var anim : String
	
	if is_attacking == true:
		anim = "attack"
	elif velocity.x == 0 and velocity.y == 0:
		anim = "idle"
	elif velocity.x != 0 or velocity.y != 0 and is_sprinting == false:
		anim = "walk"
	elif velocity.x != 0 or velocity.y != 0 and is_sprinting == true:
		anim = "run"
	else:
		anim = "idle"
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	sprite.play(anim)

func move():
	
	if stamina == 0:
		can_sprint = false
	elif stamina >= 50:
		can_sprint = true
	
	if Input.is_action_pressed("sprint") and can_sprint and (
	velocity.x != 0 or velocity.y != 0):
		is_sprinting = true
		stamina -= 1
		send_ui_data()
	else:
		is_sprinting = false
		if stamina < base_stats["max_stamina"]:
			stamina += 0.25
			send_ui_data()
	if stamina > base_stats["max_stamina"]:
			stamina = base_stats["max_stamina"]
			send_ui_data()
	if stamina < 0:
			stamina = 0
			send_ui_data()
	
	var move_speed : int
	
	if is_sprinting:
		move_speed = base_stats["speed"] * base_stats["sprint_multiplier"]
	elif not is_sprinting:
		move_speed = base_stats["speed"]
	
	velocity = (Input.get_vector("move_left","move_right","move_up","move_down")*move_speed)
	move_and_slide()

func take_damage(amount):
	if hp > 0:
		hp -= amount
		send_ui_data()
	if hp < 0:
		hp = 0
		send_ui_data()
	if hp == 0:
		game_over()

func heal(amount):
	if hp < 100:
		hp += amount
		send_ui_data()
	if hp > 100:
		hp = 100
		send_ui_data()

func deal_damage(amount):
	damage.emit(amount)

func game_over():
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move()
	anim()

func _on_enemy_damage_player(amount: int) -> void:
	take_damage(amount)
	
