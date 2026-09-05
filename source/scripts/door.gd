extends Area2D

@onready var e_label : Label = $"../../canvas/interact/label"

func _on_body_entered(body: Node2D) -> void:
	'''
	a builtin Godot function responsible for detecting whether the player 
	hath just entered unto the door node's CollisionShape
	
	parameters:
	body: the body node (such as CharacterBody2D) that hath entered 
	unto the aforementioned collision area. in most instances, this is the Player node.
	'''
	if body.name == "player": #determines whether the provided body node is in fact, the aforementioned player node.
		body.interact = "door" #changes a player variable responsible for storing objects it is in contact with
		e_label.text = "E to open door"


func _on_body_exited(body: Node2D) -> void:
	'''
	an inbuilt Godot function responsible for detecting when a node exits the berries' collision area.
	
	parameters:
	body: the body node that hath just exited the humble collision area
	'''
	if body.name == "player": #determines whether the provided body node is the player node.
		body.interact = "" #resets the player's interact variable
		e_label.text = "" #resets the instructional label text
