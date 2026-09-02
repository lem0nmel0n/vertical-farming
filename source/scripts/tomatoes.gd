extends Area2D

#loads the informative label and assigns it to a variable for accessibility
@onready var e_label : Label = $"../../canvas/canvas_control/interact/label"

func _on_body_entered(body: Node2D) -> void:
	'''
	a builtin Godot function responsible for detecting whether the player 
	hath just entered unto the tomato node's CollisionShape
	
	parameters:
	body: the body node (such as CharacterBody2D) that hath entered 
	unto the aforementioned collision area. in most instances, this is the Player node.
	'''
	if body.name == "player": #determines whether the provided body node is in fact, the aforementioned player node.
		if GameState.t_grown: #conducts a conditional evaluation to determine if the boolean assumes a true value.
			#performs an assessment on the aggregated total of tomatoes in the inventory to checkif it is
			#not equal to the amount of tomatoes requested by their royal grandness, the eminent sovereign of infinite velocity, the customer. 
			#if they are not of an equivalent value, the instructive label displays informative material,
			#entailing the user action required to perform the harvesting action.
			if GameState.inventory["tomatoes"] != GameState.customers[GameState.customer_index][1]:
				body.interact = "tomatoes" #changes a player variable responsible for storing objects it is in contact with
				e_label.text = "E to harvest"
		else: #if the condition evaluates to false
			#the user is prompted to plant the lettuce starts if they possess them
			if "tomatoes" in GameState.bought:
				body.interact = "tomatoes"
				e_label.text = "E to plant"

func _on_body_exited(body: Node2D) -> void:
	'''
	an inbuilt Godot function responsible for detecting when a node exits the lettuce's collision area.
	
	parameters:
	body: the body node that hath just exited the humble collision area
	'''
	if body.name == "player": #determines whether the provided body node is the player node.
		body.interact = "" #resets the player's interact variable
		e_label.text = "" #resets the instructional label text
		
