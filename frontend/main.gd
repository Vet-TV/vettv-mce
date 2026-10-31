extends Control
## VetTV MCE dashboard (Phase 2 scaffolding).
##
## Six Memory Cards in a horizontal column. D-pad / arrows switch cards,
## A / Enter opens a card's placeholder tile grid, B / Esc goes back
## (Esc on the card row quits this dev build). After 90 s idle the
## dashboard drifts into Ambient Mode: clock grows, particles thicken,
## cards float. Any input snaps back. See blueprint sections 4-5.

enum Mode { CARD, TILE, SYSTEM, GAME }

const INK := Color("#e6ecff")
const INK_DIM := Color("#8a93b8")
const BG_TILE := Color("#131a35")
const BG_TILE_FOCUSED := Color("#232f5c")
const GRID_COLUMNS := 4
const IDLE_AMBIENT_SECONDS := 90.0

var _cards: Array = []
var _faces: Array[CardFace] = []
var _tiles: Array[PanelContainer] = []
var _tile_styles: Array[StyleBoxFlat] = []

var _mode: Mode = Mode.CARD
var _card_index: int = 0
var _tile_index: int = 0

var _margin: MarginContainer
var _card_row: HBoxContainer
var _tile_panel: PanelContainer
var _tile_header: Label
var _tile_grid: GridContainer
var _status: Label
var _hint: Label
var _wordmark: Label
var _clock_box: VBoxContainer
var _clock_label: Label
var _date_label: Label
var _particles: GPUParticles2D

var _tween: Tween
var _http: HTTPRequest
var _http_post: HTTPRequest
var _retro_online: bool = false
var _retro_eras: Array = []
var _retro_systems: Dictionary = {}
var _current_era: String = ""
var _current_system: Dictionary = {}
var _idle_seconds: float = 0.0
var _ambient: bool = false
var _last_clock_second: int = -1


const SERVICE_URL := "http://127.0.0.1:8471"

func _ready() -> void:
	_cards = CardData.cards()
	_build_ui()
	_http = HTTPRequest.new()
	_http.timeout = 4.0
	add_child(_http)
	_http.request_completed.connect(_on_systems_received)
	_http_post = HTTPRequest.new()
	_http_post.timeout = 10.0
	add_child(_http_post)
	_http_post.request_completed.connect(_on_launch_completed)
	_refresh(true)
	_update_clock(true)
	_fetch_retro_systems()


func _fetch_retro_systems() -> void:
	var err := _http.request(SERVICE_URL + "/systems")
	if err != OK:
		_retro_online = false


func _on_systems_received(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		_retro_online = false
		if _cards[_card_index].get("id") == "retro":
			_refresh(true)
		return
	var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
	if not (parsed is Dictionary):
		_retro_online = false
		return
	_retro_online = true
	_retro_eras = parsed.get("eras", [])
	_retro_systems.clear()
	for system in parsed.get("systems", []):
		_retro_systems[system["id"]] = system
	if _cards[_card_index].get("id") == "retro":
		_refresh(true)


func _on_launch_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		var detail := body.get_string_from_utf8()
		_status.text = "Launch failed (%d) %s" % [response_code, detail.substr(0, 80)]
		return
	_status.text = "Game running - close it to return to the dashboard"


func _build_ui() -> void:
	_particles = GPUParticles2D.new()
	_particles.amount = 120
	_particles.amount_ratio = 0.5
	_particles.lifetime = 16.0
	_particles.position = Vector2(960, 540)
	_particles.visibility_rect = Rect2(-1300, -900, 2600, 1800)
	var mat := ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = Vector3(1020, 600, 1)
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 180.0
	mat.gravity = Vector3.ZERO
	mat.initial_velocity_min = 5.0
	mat.initial_velocity_max = 16.0
	mat.scale_min = 0.5
	mat.scale_max = 1.5
	mat.color = Color(0.62, 0.70, 0.95, 0.5)
	_particles.process_material = mat
	_particles.texture = _make_dot_texture()
	add_child(_particles)

	var margin := MarginContainer.new()
	_margin = margin
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 56)
	margin.add_theme_constant_override("margin_right", 56)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_bottom", 30)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 18)
	margin.add_child(root)

	# Top bar: wordmark left, clock right.
	var top := HBoxContainer.new()
	root.add_child(top)
	_wordmark = Label.new()
	_wordmark.text = "VetTV MCE"
	_wordmark.add_theme_font_size_override("font_size", 30)
	_wordmark.add_theme_color_override("font_color", INK)
	top.add_child(_wordmark)
	var top_spacer := Control.new()
	top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(top_spacer)
	_clock_box = VBoxContainer.new()
	_clock_box.add_theme_constant_override("separation", 0)
	top.add_child(_clock_box)
	_clock_label = Label.new()
	_clock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_clock_label.add_theme_font_size_override("font_size", 46)
	_clock_label.add_theme_color_override("font_color", INK)
	_clock_box.add_child(_clock_label)
	_date_label = Label.new()
	_date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_date_label.add_theme_font_size_override("font_size", 18)
	_date_label.add_theme_color_override("font_color", INK_DIM)
	_clock_box.add_child(_date_label)
	_clock_box.resized.connect(func() -> void: _clock_box.pivot_offset = Vector2(_clock_box.size.x, 0))

	# Card column, centered.
	var center := CenterContainer.new()
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(center)
	_card_row = HBoxContainer.new()
	_card_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_card_row.add_theme_constant_override("separation", 22)
	center.add_child(_card_row)
	for i in _cards.size():
		var face := CardFace.new(i, _cards[i])
		face.pressed.connect(_on_card_clicked)
		_faces.append(face)
		_card_row.add_child(face)

	# Tile panel for the opened card.
	_tile_panel = PanelContainer.new()
	var panel_bg := StyleBoxFlat.new()
	panel_bg.bg_color = Color("#0d1330")
	panel_bg.set_corner_radius_all(14)
	panel_bg.content_margin_left = 28
	panel_bg.content_margin_right = 28
	panel_bg.content_margin_top = 20
	panel_bg.content_margin_bottom = 24
	_tile_panel.add_theme_stylebox_override("panel", panel_bg)
	_tile_panel.custom_minimum_size = Vector2(0, 252)
	root.add_child(_tile_panel)
	var tile_stack := VBoxContainer.new()
	tile_stack.add_theme_constant_override("separation", 14)
	_tile_panel.add_child(tile_stack)
	_tile_header = Label.new()
	_tile_header.add_theme_font_size_override("font_size", 22)
	_tile_header.add_theme_color_override("font_color", INK)
	tile_stack.add_child(_tile_header)
	_tile_grid = GridContainer.new()
	_tile_grid.columns = GRID_COLUMNS
	_tile_grid.add_theme_constant_override("h_separation", 14)
	_tile_grid.add_theme_constant_override("v_separation", 14)
	tile_stack.add_child(_tile_grid)

	_status = Label.new()
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status.add_theme_font_size_override("font_size", 24)
	_status.add_theme_color_override("font_color", INK)
	root.add_child(_status)

	_hint = Label.new()
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint.add_theme_font_size_override("font_size", 18)
	_hint.add_theme_color_override("font_color", INK_DIM)
	root.add_child(_hint)


func _make_dot_texture() -> Texture2D:
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	for y in 64:
		for x in 64:
			var d := Vector2(x - 32, y - 32).length() / 32.0
			var a: float = clampf(1.0 - d, 0.0, 1.0)
			img.set_pixel(x, y, Color(1, 1, 1, a * a))
	return ImageTexture.create_from_image(img)


func _process(delta: float) -> void:
	_update_clock(false)
	if _ambient:
		var drift := sin(Time.get_ticks_msec() / 1000.0 * 0.45) * 12.0
		_margin.position.y = drift
	else:
		_idle_seconds += delta
		if _idle_seconds >= IDLE_AMBIENT_SECONDS:
			_set_ambient(true)


func _update_clock(force: bool) -> void:
	var now := Time.get_time_dict_from_system()
	if not force and now["second"] == _last_clock_second:
		return
	_last_clock_second = now["second"]
	_clock_label.text = "%02d:%02d" % [now["hour"], now["minute"]]
	var date := Time.get_date_dict_from_system()
	var weekdays := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	_date_label.text = "%s %s %d" % [weekdays[int(date["weekday"])], months[int(date["month"]) - 1], int(date["day"])]


func _unhandled_input(event: InputEvent) -> void:
	var acted := false
	if event.is_action_pressed("ui_cancel"):
		acted = true
		match _mode:
			Mode.GAME:
				_mode = Mode.SYSTEM
				_tile_index = 0
				_refresh(false)
			Mode.SYSTEM:
				_mode = Mode.TILE
				_tile_index = 0
				_refresh(false)
			Mode.TILE:
				_mode = Mode.CARD
				_refresh(false)
			_:
				get_tree().quit()
	elif event.is_action_pressed("ui_accept"):
		acted = true
		if _mode == Mode.CARD:
			_mode = Mode.TILE
			_tile_index = 0
			_refresh(false)
		else:
			_activate_tile()
	elif event.is_action_pressed("ui_left"):
		acted = true
		_move(Vector2i.LEFT)
	elif event.is_action_pressed("ui_right"):
		acted = true
		_move(Vector2i.RIGHT)
	elif event.is_action_pressed("ui_up"):
		acted = true
		_move(Vector2i.UP)
	elif event.is_action_pressed("ui_down"):
		acted = true
		_move(Vector2i.DOWN)
	elif event is InputEventJoypadButton and event.pressed:
		acted = true
	# Joypad axis motion deliberately does not reset idle: Batocera hosts
	# virtual gamepad devices that can emit repeated axis events, which
	# would keep Ambient Mode from ever engaging. Stick navigation still
	# registers via the ui_* actions above (they carry a deadzone).
	# Only deliberate presses count as activity. A bare is_pressed()
	# catch-all also catches pointer-motion style events, which can
	# arrive continuously in VMs and would starve Ambient Mode forever.
	# Mouse clicks register via the card/tile gui_input handlers.
	if acted:
		_register_input()


func _register_input() -> void:
	_idle_seconds = 0.0
	if _ambient:
		_set_ambient(false)


func _move(dir: Vector2i) -> void:
	if _mode == Mode.CARD:
		if dir == Vector2i.LEFT:
			_card_index = wrapi(_card_index - 1, 0, _cards.size())
			_refresh(false)
		elif dir == Vector2i.RIGHT:
			_card_index = wrapi(_card_index + 1, 0, _cards.size())
			_refresh(false)
	else:
		var count := _tiles.size()
		if count == 0:
			return
		var col := _tile_index % GRID_COLUMNS
		if dir == Vector2i.LEFT and col > 0:
			_tile_index -= 1
		elif dir == Vector2i.RIGHT and col < GRID_COLUMNS - 1 and _tile_index + 1 < count:
			_tile_index += 1
		elif dir == Vector2i.UP and _tile_index - GRID_COLUMNS >= 0:
			_tile_index -= GRID_COLUMNS
		elif dir == Vector2i.DOWN and _tile_index + GRID_COLUMNS < count:
			_tile_index += GRID_COLUMNS
		_refresh(false)


func _on_card_clicked(index: int) -> void:
	_register_input()
	if _mode == Mode.CARD and index == _card_index:
		_mode = Mode.TILE
		_tile_index = 0
	elif _mode == Mode.CARD:
		_card_index = index
	_refresh(false)


func _is_retro() -> bool:
	return _cards[_card_index].get("id") == "retro"


func _current_items() -> Array:
	# Each item: {label, detail, payload}. Drives tiles for every level.
	var items: Array = []
	var card: Dictionary = _cards[_card_index]
	match _mode:
		Mode.CARD, Mode.TILE:
			if _is_retro() and _retro_online:
				for era_group in _retro_eras:
					var systems: Array = era_group["systems"]
					var games := 0
					for s in systems:
						games += int(s["game_count"])
					items.append({"label": era_group["era"], "detail": "%d systems · %d games" % [systems.size(), games], "payload": era_group})
			else:
				for t in card["tiles"]:
					items.append({"label": t, "detail": "", "payload": t})
		Mode.SYSTEM:
			for era_group in _retro_eras:
				if era_group["era"] == _current_era:
					for s in era_group["systems"]:
						items.append({"label": s["name"], "detail": "%d games" % int(s["game_count"]), "payload": s})
		Mode.GAME:
			for g in _current_system.get("games", []):
				var kb := int(g["size_bytes"]) / 1024.0
				var size_text := "%.1f MB" % (kb / 1024.0) if kb >= 1024.0 else "%d KB" % int(kb)
				items.append({"label": g["title"], "detail": size_text, "payload": g})
	return items


func _activate_tile() -> void:
	var items := _current_items()
	if _tile_index >= items.size():
		return
	var item: Dictionary = items[_tile_index]
	var card: Dictionary = _cards[_card_index]
	match _mode:
		Mode.TILE:
			if _is_retro() and _retro_online:
				_current_era = item["label"]
				_mode = Mode.SYSTEM
				_tile_index = 0
				_refresh(false)
			else:
				_status.text = "%s / %s - lands in %s" % [card["title"], item["label"], card["phase"]]
		Mode.SYSTEM:
			_current_system = _retro_systems.get(item["payload"]["id"], {})
			_mode = Mode.GAME
			_tile_index = 0
			_refresh(false)
		Mode.GAME:
			var game: Dictionary = item["payload"]
			_status.text = "Launching %s..." % game["title"]
			var payload := {"system": _current_system.get("id", ""), "game_path": game["path"]}
			var err := _http_post.request(
				SERVICE_URL + "/launch",
				["Content-Type: application/json"],
				HTTPClient.METHOD_POST,
				JSON.stringify(payload)
			)
			if err != OK:
				_status.text = "Launch failed - service busy (HTTP %d)" % err


func _refresh(instant: bool) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	var dur := 0.0 if instant else 0.18
	for i in _faces.size():
		var face := _faces[i]
		var focused := i == _card_index
		var dist := absi(i - _card_index)
		face.set_focus_state(focused, _mode != Mode.CARD and not focused)
		var target_scale := 0.94
		var target_alpha := 0.55
		if focused:
			target_scale = 1.22 if _mode != Mode.CARD else 1.12
			target_alpha = 1.0
		elif dist == 1:
			target_alpha = 0.8
		if _mode != Mode.CARD and not focused:
			target_alpha = 0.3
		_tween.tween_property(face, "scale", Vector2.ONE * target_scale, dur)
		_tween.tween_property(face, "modulate:a", target_alpha, dur)
	_rebuild_tiles()
	if _mode == Mode.CARD:
		var card: Dictionary = _cards[_card_index]
		_status.text = "%s - %s" % [card["title"], card["subtitle"]]
		if _is_retro() and not _retro_online:
			_status.text += "  (service offline)"
		_hint.text = "Left / Right: choose card    Enter: open    Esc: quit (dev build)"
	else:
		match _mode:
			Mode.TILE:
				_hint.text = "Arrows: choose    Enter: open    Esc: back"
			Mode.SYSTEM:
				_hint.text = "Arrows: choose system    Enter: open    Esc: back"
			Mode.GAME:
				_hint.text = "Arrows: choose game    Enter: launch    Esc: back"
		_activate_status_for_tile_focus()


func _rebuild_tiles() -> void:
	for child in _tile_grid.get_children():
		_tile_grid.remove_child(child)
		child.free()
	_tiles.clear()
	_tile_styles.clear()
	var card: Dictionary = _cards[_card_index]
	match _mode:
		Mode.SYSTEM:
			_tile_header.text = "Retro  -  %s" % _current_era
		Mode.GAME:
			_tile_header.text = "Retro  -  %s" % _current_system.get("name", "")
		_:
			_tile_header.text = "%s  -  %s" % [card["title"], "choose an era" if (_is_retro() and _retro_online) else card["phase"]]
	_tile_header.add_theme_color_override("font_color", card["accent"])
	var tiles := _current_items()
	for i in tiles.size():
		var tile := PanelContainer.new()
		tile.custom_minimum_size = Vector2(248, 74)
		var bg := StyleBoxFlat.new()
		bg.bg_color = BG_TILE_FOCUSED if (_mode != Mode.CARD and i == _tile_index) else BG_TILE
		bg.set_corner_radius_all(10)
		bg.content_margin_left = 16
		bg.content_margin_right = 16
		tile.add_theme_stylebox_override("panel", bg)
		var stack := VBoxContainer.new()
		stack.alignment = BoxContainer.ALIGNMENT_CENTER
		stack.add_theme_constant_override("separation", 2)
		tile.add_child(stack)
		var label := Label.new()
		label.text = tiles[i]["label"]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.clip_text = true
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_color", INK if (_mode != Mode.CARD and i == _tile_index) else INK_DIM)
		stack.add_child(label)
		if tiles[i]["detail"] != "":
			var detail := Label.new()
			detail.text = tiles[i]["detail"]
			detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			detail.add_theme_font_size_override("font_size", 15)
			detail.add_theme_color_override("font_color", INK_DIM)
			stack.add_child(detail)
		tile.gui_input.connect(_on_tile_gui_input.bind(i))
		_tile_grid.add_child(tile)
		_tiles.append(tile)
		_tile_styles.append(bg)
		if _mode != Mode.CARD:
			tile.scale = Vector2.ONE * 0.85
			tile.modulate.a = 0.0
			var tw := create_tween()
			tw.tween_interval(i * 0.035)
			tw.set_parallel(true)
			tw.tween_property(tile, "scale", Vector2.ONE, 0.16)
			tw.tween_property(tile, "modulate:a", 1.0, 0.16)


func _activate_status_for_tile_focus() -> void:
	var items := _current_items()
	if _tile_index >= items.size():
		return
	var label: String = items[_tile_index]["label"]
	match _mode:
		Mode.TILE:
			_status.text = "%s / %s" % [_cards[_card_index]["title"], label]
		Mode.SYSTEM:
			_status.text = "%s / %s" % [_current_era, label]
		Mode.GAME:
			_status.text = "%s / %s" % [_current_system.get("name", ""), label]


func _on_tile_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_register_input()
		if _mode != Mode.CARD and index == _tile_index:
			_activate_tile()
		else:
			if _mode == Mode.CARD:
				_mode = Mode.TILE
			_tile_index = index
			_refresh(false)


func _set_ambient(on: bool) -> void:
	_ambient = on
	_idle_seconds = 0.0
	var tw := create_tween().set_parallel(true)
	if on:
		tw.tween_property(_clock_box, "scale", Vector2.ONE * 1.5, 0.8)
		tw.tween_property(_particles, "amount_ratio", 1.0, 0.8)
		for node in [_wordmark, _status, _hint, _tile_panel]:
			tw.tween_property(node, "modulate:a", 0.22, 0.8)
	else:
		_margin.position.y = 0.0
		tw.tween_property(_clock_box, "scale", Vector2.ONE, 0.4)
		tw.tween_property(_particles, "amount_ratio", 0.5, 0.4)
		for node in [_wordmark, _status, _hint, _tile_panel]:
			tw.tween_property(node, "modulate:a", 1.0, 0.4)
