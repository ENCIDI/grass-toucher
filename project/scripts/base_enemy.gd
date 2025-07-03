extends CharacterBody2D

@export var base_stats = {
	"max_hp": 100,
	"speed": 800,
	"attack_kd": 3,
	"base_damage": 15,
}

@onready var label = $ui/Label
@onready var hp_bar = $ui/hp_bar

var hp : int = base_stats["max_hp"]

signal player_damaged(amount)

func move():
	pass

func deal_damage(amount):
	player_damaged.emit(amount)

func take_damage(amount):
	hp -= amount
	if hp > 0:
		hp -= amount
	if hp < 0:
		hp = 0
	if hp == 0:
		get_tree().quit()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	hp_bar.value = hp

@warning_ignore("unused_parameter")
func _on_hit_area_area_entered(area: Area2D) -> void:
	deal_damage(base_stats["base_damage"])

@warning_ignore("unused_parameter")
func _on_damage_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
