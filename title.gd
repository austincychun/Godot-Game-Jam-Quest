extends Control

@onready var start_button: Button = $StartButton

func _ready() -> void:
	start_button.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") or event.is_action_pressed("ui_accept"):
		_start_game()

func _on_start_button_pressed() -> void:
	_start_game()

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
