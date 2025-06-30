extends Control

@onready var hpbar = $hpbar
@onready var staminabar = $staminabar

func _on_player_stats_changed(current_health: Variant, max_health: Variant, current_stamina: Variant, max_stamina: Variant) -> void:
	hpbar.max_value = max_health
	hpbar.value = current_health
	staminabar.max_value = max_stamina
	staminabar.value = current_stamina
