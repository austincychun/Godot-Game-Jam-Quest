extends CharacterBody2D

signal battery_changed(current: float, max_value: float)
signal player_died
signal reached_exit
signal generator_activated

@export var move_speed := 220.0
@export var dash_speed := 460.0
@export var dash_length := 0.18
@export var dash_cooldown := 0.65
@export var max_battery := 100.0
@export var drain_per_second := 8.0
@export var dash_cost := 8.0
@export var hit_cost := 15.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_audio: AudioStreamPlayer2D = $PickupAudio
@onready var hit_audio: AudioStreamPlayer2D = $HitAudio
@onready var dash_audio: AudioStreamPlayer2D = $DashAudio

var battery := 100.0
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var dash_direction := Vector2.ZERO
var generator_online := false

func _ready() -> void:
	add_to_group("player")
	battery = max_battery
	emit_signal("battery_changed", battery, max_battery)

func _physics_process(delta: float) -> void:
	if battery <= 0.0:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	dash_timer = max(dash_timer - delta, 0.0)
	dash_cooldown_timer = max(dash_cooldown_timer - delta, 0.0)

	battery -= drain_per_second * delta
	battery = max(battery, 0.0)
	emit_signal("battery_changed", battery, max_battery)
	if battery <= 0.0:
		emit_signal("player_died")
		return

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0.0 and battery > dash_cost:
		var chosen_dir := input_dir if input_dir != Vector2.ZERO else Vector2.RIGHT
		dash_direction = chosen_dir.normalized()
		dash_timer = dash_length
		dash_cooldown_timer = dash_cooldown
		battery -= dash_cost
		emit_signal("battery_changed", battery, max_battery)
		if dash_audio.stream:
			dash_audio.play()

	if dash_timer > 0.0:
		velocity = dash_direction * dash_speed
	else:
		velocity = input_dir * move_speed

	move_and_slide()
	_update_animation(input_dir)

func _update_animation(input_dir: Vector2) -> void:
	if animated_sprite.sprite_frames == null:
		return
	if input_dir == Vector2.ZERO and dash_timer <= 0.0:
		if animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")
	else:
		if animated_sprite.sprite_frames.has_animation("walk"):
			animated_sprite.play("walk")
		if input_dir.x != 0:
			animated_sprite.flip_h = input_dir.x < 0

func add_battery(amount: float) -> void:
	battery = min(battery + amount, max_battery)
	emit_signal("battery_changed", battery, max_battery)
	if pickup_audio.stream:
		pickup_audio.play()

func take_damage(amount: float) -> void:
	battery = max(battery - amount, 0.0)
	emit_signal("battery_changed", battery, max_battery)
	if hit_audio.stream:
		hit_audio.play()
	if battery <= 0.0:
		emit_signal("player_died")

func activate_generator() -> void:
	if generator_online:
		return
	generator_online = true
	emit_signal("generator_activated")

func handle_exit() -> void:
	if generator_online:
		emit_signal("reached_exit")
