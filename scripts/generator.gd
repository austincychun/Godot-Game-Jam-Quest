extends Area2D

var activated := false

func _on_body_entered(body: Node) -> void:
	if activated:
		return
	if body.has_method("activate_generator"):
		activated = true
		body.activate_generator()
