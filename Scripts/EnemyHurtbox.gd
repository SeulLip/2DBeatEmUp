extends Area2D

signal on_hit(player: CharacterBody2D)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		var player = area.get_node(".").player
		on_hit.emit(player)
	if area.is_in_group("ComboA"):
		print("bruh")
	if area.is_in_group("KnockUp"):
		print("yay")
