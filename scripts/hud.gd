extends Control

@onready var battery_bar: ProgressBar = $BatteryBar
@onready var battery_label: Label = $BatteryLabel
@onready var info_label: Label = $InfoLabel

func _ready() -> void:
	info_label.text = "WASD move | SPACE dash | Touch generator ring, then reach the exit"

func set_battery(current: float, max_value: float) -> void:
	battery_bar.max_value = max_value
	battery_bar.value = current
	battery_label.text = "Battery: %d%%" % int(round((current / max_value) * 100.0))

func set_status_text(message: String) -> void:
	info_label.text = message

func hide_status_text() -> void:
	info_label.visible = false

func show_status_text() -> void:
	info_label.visible = true
