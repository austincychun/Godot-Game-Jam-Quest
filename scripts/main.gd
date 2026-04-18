extends Node2D

@onready var player = $Player
@onready var hud = $CanvasLayer/HUD
@onready var result_label = $CanvasLayer/ResultLabel
@onready var objective_label = $CanvasLayer/ObjectiveLabel
@onready var exit_visual = $ExitVisual
@onready var exit_label = $ExitLabel
@onready var generator_light = $GeneratorLight
@onready var generator_status_label = $GeneratorStatusLabel
@onready var activate_audio: AudioStreamPlayer = $ActivateAudio
@onready var music: AudioStreamPlayer = $Music
@onready var end_screen: Control = $CanvasLayer/EndScreen
@onready var end_title: Label = $CanvasLayer/EndScreen/Panel/EndTitle
@onready var end_subtitle: Label = $CanvasLayer/EndScreen/Panel/EndSubtitle
@onready var victory_audio: AudioStreamPlayer = $VictoryAudio

var game_over := false

func _ready() -> void:
	player.battery_changed.connect(_on_battery_changed)
	player.player_died.connect(_on_player_died)
	player.reached_exit.connect(_on_reached_exit)
	player.generator_activated.connect(_on_generator_activated)
	hud.set_battery(player.battery, player.max_battery)
	result_label.visible = false
	end_screen.visible = false
	hud.show_status_text()
	objective_label.visible = true
	objective_label.text = "OBJECTIVE: Reach the generator"
	exit_visual.color = Color(0.65, 0.2, 0.2, 1)
	exit_label.text = "EXIT LOCKED"
	generator_status_label.text = "GENERATOR"
	generator_light.color = Color(0.95, 0.8, 0.25, 0.45)

func _process(_delta: float) -> void:
	if game_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_battery_changed(current: float, max_value: float) -> void:
	hud.set_battery(current, max_value)

func _on_player_died() -> void:
	_end_game(false)

func _on_generator_activated() -> void:
	objective_label.text = "OBJECTIVE: Return to the exit"
	hud.set_status_text("Generator online. Backtrack through the station and reach the green exit at the top-left.")
	exit_visual.color = Color(0.25, 0.82, 0.45, 1)
	exit_label.text = "EXIT OPEN"
	generator_status_label.text = "GENERATOR ONLINE"
	generator_light.color = Color(0.25, 1.0, 0.45, 0.9)
	if activate_audio.stream:
		activate_audio.play()

func _on_reached_exit() -> void:
	_end_game(true)

func _end_game(victory: bool) -> void:
	if game_over:
		return
	game_over = true
	player.set_process(false)
	player.set_physics_process(false)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_method("freeze_enemy"):
			enemy.freeze_enemy()
	if music != null and music.playing:
		music.stop()
	hud.hide_status_text()
	objective_label.visible = false
	result_label.visible = false
	end_screen.visible = true
	if victory:
		end_title.text = "POWER RESTORED"
		end_subtitle.text = "Facility back online. Press R to run again."
		if victory_audio.stream:
			victory_audio.play()
	else:
		end_title.text = "OUT OF POWER"
		end_subtitle.text = "The station went dark. Press R to restart."
