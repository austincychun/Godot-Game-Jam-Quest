extends Area2D

@export var charge_amount := 25.0

func _on_body_entered(body: Node) -> void:
	if body.has_method("add_battery"):
		body.add_battery(charge_amount)
		queue_free()
