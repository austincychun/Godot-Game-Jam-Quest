extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.has_method("handle_exit"):
		body.handle_exit()
