extends Area2D

#loads the informative label and assigns it to a variable for accessibility
@onready var e_label : Label = $"../../canvas/canvas_control/interact/label"

func _on_body_exited(body: Node2D) -> void:
	'''
	an inbuilt Godot function responsible for detecting when a node exits the berries' collision area.
	
	parameters:
	body: the body node that hath just exited the humble collision area
	'''
	if body.name == "player": #determines whether the provided body node is the player node.
		body.interact = "" #resets the player's interact variable
		e_label.text = "" #resets the instructional label text
