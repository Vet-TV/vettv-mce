class_name CardFace
extends PanelContainer
## One Memory Card in the dashboard column. Built in code: accent chip,
## title, subtitle, tile count. Focus is shown by background shade and
## scale (applied by the dashboard), never by a colored border.

signal pressed(index: int)

var index: int = 0
var accent: Color = Color.WHITE

var _bg: StyleBoxFlat
var _title_label: Label

const BG_IDLE := Color("#10162e")
const BG_FOCUSED := Color("#1b2447")
const BG_DIM := Color("#0b0f22")
const INK := Color("#e6ecff")
const INK_DIM := Color("#8a93b8")


func _init(p_index: int, data: Dictionary) -> void:
	index = p_index
	accent = data["accent"]
	custom_minimum_size = Vector2(204, 300)

	_bg = StyleBoxFlat.new()
	_bg.bg_color = BG_IDLE
	_bg.set_corner_radius_all(14)
	_bg.content_margin_left = 20
	_bg.content_margin_right = 20
	_bg.content_margin_top = 22
	_bg.content_margin_bottom = 22
	add_theme_stylebox_override("panel", _bg)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	add_child(stack)

	var chip := ColorRect.new()
	chip.color = accent
	chip.custom_minimum_size = Vector2(44, 8)
	stack.add_child(chip)

	_title_label = Label.new()
	_title_label.text = data["title"]
	_title_label.add_theme_font_size_override("font_size", 32)
	_title_label.add_theme_color_override("font_color", INK)
	stack.add_child(_title_label)

	var subtitle := Label.new()
	subtitle.text = data["subtitle"]
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", INK_DIM)
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(subtitle)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(spacer)

	var phase := Label.new()
	phase.text = data["phase"]
	phase.add_theme_font_size_override("font_size", 16)
	phase.add_theme_color_override("font_color", accent)
	stack.add_child(phase)

	var count := Label.new()
	count.text = "%d tiles" % (data["tiles"] as Array).size()
	count.add_theme_font_size_override("font_size", 16)
	count.add_theme_color_override("font_color", INK_DIM)
	stack.add_child(count)

	resized.connect(func() -> void: pivot_offset = size * 0.5)
	gui_input.connect(_on_gui_input)


func set_focus_state(focused: bool, dimmed: bool) -> void:
	if focused:
		_bg.bg_color = BG_FOCUSED
	elif dimmed:
		_bg.bg_color = BG_DIM
	else:
		_bg.bg_color = BG_IDLE


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pressed.emit(index)
		accept_event()
