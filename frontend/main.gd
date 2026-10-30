extends Control
## Phase 1 blank frontend: dark window, title, and a live input readout.
## Proves the exported app renders and receives keyboard/controller input.
## No dashboard behaviour yet — that is Phase 2.

@onready var _last_input: Label = $Center/Stack/LastInput


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		return
	if event.is_pressed() and not event.is_echo():
		_last_input.text = "Last input: %s" % event.as_text()
