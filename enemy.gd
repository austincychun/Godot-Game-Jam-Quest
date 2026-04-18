extends Area2D

@export var damage := 20.0
@export var move_distance := 140.0
@export var move_time := 1.2
@export var patrol_axis := Vector2.RIGHT
@export var chase_speed := 135.0
@export var chase_radius := 220.0

var start_position := Vector2.ZERO
var time_passed := 0.0
var target_player: Node2D = null

func _ready() -> void:
	start_position = global_position
	patrol_axis = patrol_axis.normalized()

func _physics_process(delta: float) -> void:
	time_passed += delta
	target_player = _find_player()
	if target_player != null and _can_chase_player(target_player):
		var direction := (target_player.global_position - global_position).normalized()
		global_position += direction * chase_speed * delta
	else:
		var t := sin((time_passed / move_time) * TAU) * 0.5 + 0.5
		global_position = start_position + patrol_axis * lerp(-move_distance * 0.5, move_distance * 0.5, t)

func _find_player() -> Node2D:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null
	return players[0] as Node2D

func _can_chase_player(player: Node2D) -> bool:
	if player == null:
		return false
	if global_position.distance_to(player.global_position) > chase_radius:
		return false
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := space_state.intersect_ray(query)
	if result.is_empty():
		return true
	return result.get("collider") == player

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)


func freeze_enemy() -> void:
	set_physics_process(false)
	set_process(false)
	monitoring = false
