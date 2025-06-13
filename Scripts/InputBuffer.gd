extends Node

var buffer := []
var held_keys := {}
var ordered_keys := []
var last_combo := ""
var detected_combo := ""

var frame_timer := 0
const FRAME_TIMEOUT := 12

const QCF := ["down", "down-right", "right"]
const QCB := ["down", "down-left", "left"]
const DP := ["right", "down", "down-right"]

var combos = {
	"L.Hadoken": QCF + ["light_attack"],
	"L.Shoryu": DP + ["light_attack"],
	"H.Tatsu": QCB + ["heavy_attack"],
	"L.Tatsu": QCB + ["light_attack"]
}

# New variables for waiting-for-attack logic
var waiting_for_attack := false
var attack_wait_timer := 0
const ATTACK_WAIT_FRAMES := 9
var pending_combo_name := ""
var pending_motion_sequence := []
var expected_attack := ""

func _process(_delta):
	if waiting_for_attack:
		attack_wait_timer += 1
		
		if Input.is_action_just_pressed(expected_attack):
			detected_combo = pending_combo_name
			$CanvasLayer/ComboLabel.bbcode_text = "%s detected! [img]res://Assets/ThumbsUpRyoSmol.png[/img]" % detected_combo
			print("%s detected!" % detected_combo)
			
			# Reset states
			waiting_for_attack = false
			attack_wait_timer = 0
			pending_combo_name = ""
			pending_motion_sequence = []
			expected_attack = ""
			buffer.clear()
			last_combo = ""
			return
		
		if attack_wait_timer > ATTACK_WAIT_FRAMES:
			# Timeout: no attack pressed in time
			waiting_for_attack = false
			attack_wait_timer = 0
			pending_combo_name = ""
			pending_motion_sequence = []
			expected_attack = ""
			buffer.clear()
			last_combo = ""
			print("Attack input timeout. Buffer cleared.")
			return
	else:
		frame_timer += 1
		if frame_timer >= FRAME_TIMEOUT and not buffer.is_empty():
			buffer.clear()
			last_combo = ""
			detected_combo = ""
			$CanvasLayer/BufferLabel.text = ""
			$CanvasLayer/ComboLabel.text = ""

func _input(event):
	if event is InputEventKey:
		if event.pressed and not held_keys.has(event.keycode):
			held_keys[event.keycode] = true
			ordered_keys.append(event.keycode)
			log_combo()
		elif not event.pressed and held_keys.has(event.keycode):
			held_keys.erase(event.keycode)
			ordered_keys.erase(event.keycode)
			log_combo()

func log_combo():
	var raw_combo := get_combo_string()
	var normalized := normalize_direction(raw_combo)

	if normalized == "":
		return

	if normalized != last_combo:
		if normalized in ["up", "down", "left", "right", "up-left", "up-right", "down-left", "down-right", "light_attack", "heavy_attack"]:
			buffer.push_back(normalized)
			last_combo = normalized
			frame_timer = 0
			print_buffer(buffer)
			if not waiting_for_attack:
				detect_motion_part()

func detect_motion_part():
	for combo_name in combos.keys():
		var full_sequence = combos[combo_name]
		var motion_sequence = full_sequence.slice(0, full_sequence.size() - 1)
		var attack_input = full_sequence[full_sequence.size() - 1]
		
		if buffer.size() >= motion_sequence.size():
			var recent = buffer.slice(buffer.size() - motion_sequence.size(), buffer.size())
			if recent == motion_sequence:
				waiting_for_attack = true
				attack_wait_timer = 0
				pending_combo_name = combo_name
				pending_motion_sequence = motion_sequence
				expected_attack = attack_input
				print("%s motion detected. Waiting for attack: %s" % [combo_name, attack_input])
				return true
	return false

func get_combo_string() -> String:
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")

	if down and right:
		return "down-right"
	elif down and left:
		return "down-left"
	elif up and right:
		return "up-right"
	elif up and left:
		return "up-left"
	elif down:
		return "down"
	elif up:
		return "up"
	elif right:
		return "right"
	elif left:
		return "left"
	elif Input.is_action_pressed("light_attack"):
		return "light_attack"
	elif Input.is_action_pressed("heavy_attack"):
		return "heavy_attack"

	return ""

func normalize_direction(combo: String) -> String:
	match combo:
		"downright", "rightdown":
			return "down-right"
		"downleft", "leftdown":
			return "down-left"
		"upright", "rightup":
			return "up-right"
		"upleft", "leftup":
			return "up-left"
		"up":
			return "up"
		"down":
			return "down"
		"left":
			return "left"
		"right":
			return "right"
		_:
			return combo

func print_buffer(b: Array):
	var buffer_text := "[" + ", ".join(b) + "]"
	$CanvasLayer/BufferLabel.text = buffer_text
