extends Area2D

#loads the informative label and assigns it to a variable for accessibility
@onready var e_label : Label = $"../../canvas/canvas_control/interact/label"

func _on_body_entered(body: Node2D) -> void:
	'''
	a builtin Godot function responsible for detecting whether the player 
	hath just entered unto the lettuce node's CollisionShape
	
	parameters:
	body: the body node (such as CharacterBody2D) that hath entered 
	unto the aforementioned collision area. in most instances, this is the Player node.
	'''
	
	if body.name == "player":#determines whether the provided body node is in fact, the aforementioned player node.
		if GameState.l_grown: #conducts a conditional evaluation using dot notation and an unspoken comparison statement to determine the ultimate truthiness of the boolean
			#performs an assessment on the aggregated total of lettuce heads in the inventory 
			#to check if it is not equal to the amount of lettuce requested by their royal stupendousness the customer. 
			#if they are not of an equivalent value, the instructive label displays informative material,
			#entailing the user action required to perform the harvesting action.
			if GameState.inventory["lettuce"] != GameState.customers[GameState.customer_index][2]:
				body.interact = "lettuce" #changes a player variable responsible for storing objects it is in contact with
				e_label.text = "E to harvest"
		else: #if the condition evaluates to false
			#the user is prompted to plant the lettuce starts if they possess them
			if "lettuce" in GameState.bought:
				body.interact = "lettuce"
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
