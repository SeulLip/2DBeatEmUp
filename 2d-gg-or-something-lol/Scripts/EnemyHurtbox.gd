extends Area2D

var hit = false;

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if hit == false:
		$AnimationPlayer.play("Idle");


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		hit = true;
		$AnimationPlayer.play("Hit");
		HitStopManager.hit_stop_light()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hit":
		hit = false;
