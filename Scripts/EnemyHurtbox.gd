extends Area2D

signal on_hit(player: CharacterBody2D, attackdata: AttackData)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		var player = area.get_node("FindPlayer").player
		var attackdata = area.get_node(".").attack
		on_hit.emit(player, attackdata)
