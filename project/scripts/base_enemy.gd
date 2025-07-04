extends CharacterBody2D

@export var base_stats = {
	"max_hp": 100,
	"speed": 300,
	"attack_kd": 3,
	"base_damage": 15,
}

@onready var hpbar = $ui/hp_bar

var hp : int = base_stats["max_hp"]
var target_player
var speed = base_stats["speed"]

signal damage_player(amount: int)

func send_damage(amount):
	damage_player.emit(amount)

func move():
	find_nearest_player()

	if target_player:
		var distance = global_position.distance_to(target_player.global_position)
		var speed_mod : float
		if distance > 50:
			speed_mod = 1.0
		elif distance > 20 and distance <= 50:
			speed_mod = 0.8
		elif distance <= 20:
			speed_mod = 0.1
		
		var direction = (target_player.global_position - global_position).normalized()
		velocity = direction * speed * speed_mod
		move_and_slide()

func take_damage(amount):
	if hp > 0:
		hp -= amount
	if hp < 0:
		hp = 0
	if hp == 0:
		get_tree().quit()
	hpbar.value = hp

func find_nearest_player():
	var players = get_tree().get_nodes_in_group("Player")
	var closest_dist = INF
	target_player = null

	for p in players:
		if not p or not p.is_inside_tree():
			continue
		var dist = global_position.distance_to(p.global_position)
		if dist < closest_dist:
			closest_dist = dist
			target_player = p

func _ready() -> void:
	hpbar.value = hp

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	move()
