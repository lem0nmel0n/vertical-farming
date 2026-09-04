extends CharacterBody2D


@export var speed : int = 80 #consigns the player speed variable to 80
var direction #initialises the direction variable, whose sole purpose is to direct the humble player towards glory, that they may accomplish their noble mission
var interact : String = "" #initialises the interact variable, upon whom the substantial role of storing the identifier corresponding to colliding nodes hath been bestowed unto
#monitors whether each respective crop is currently undergoing its transmutation process 
var b_growing = false
var t_growing = false
var l_growing = false

var areas
var amount = 0

#growing functions for three distinct entities, comprising of tomatoes, lettuce and strawberries. 
#though their respective variables are uniquely transformed, ultimately all must endure indentical cultivation processes. 
func t_grow():
	t_growing = true
	GameState.t_grown = false #this is used to determine tomato rack frames in warehouse.gd
	GameState.t_collected = false
	await get_tree().create_timer(2).timeout #a timer is created to simulate fast-paced growing times
	GameState.t_grown = true
	GameState.t_collected = false
	t_growing = false
	
func l_grow():
	l_growing = true
	GameState.l_grown = false
	GameState.l_collected = false
	await get_tree().create_timer(2).timeout
	GameState.l_grown = true
	GameState.l_collected = false
	l_growing = false

func b_grow():
	b_growing = true
	GameState.b_grown = false
	GameState.b_collected = false
	await get_tree().create_timer(2).timeout
	GameState.b_grown = true
	GameState.b_collected = false
	b_growing = false

#exhibits a popup with the contents of the label passed as the mighty text parameter
func show_message(text):
	%info.get_node("info/label").text = text #the info hbox node currently inhabiting beneath canvas/control/
	#hath doth been bestowed a unique moniker to reference it without a directory addres
	%info.visible = true
	%info.get_node("info/canvas").visible = true


func _physics_process(_delta: float) -> void:
	'''
	a builtin Godot function executed at the physics tick rate (60 by default), 
	upon whom the obligation of commanding the player node movement hath been granted
	though it additionally oversees the management of player interaction.
	
	parameters:
	delta (unused)
	'''
	if %info.visible: #performs a conditional check on the obstructive, informational popup
		if Input.is_action_just_pressed("interact"): #additionally, if user interaction hath evaluated to a true value
			#the popup contents are then hidden
			%info.visible = false
			%info.get_node("info/canvas").visible = false
			
	else: #once the obstructive popup hath been ridden by the might of the user's "E" key
		%money.text = "money: $" + str(GameState.money) #updates the money label residing in the top leftmost corner
		if GameState.new_customer and get_tree().current_scene.name == "main":
			#displays a short-lived popup after the sufficing of their royal stateliness, the mighty vegetable supremacist, the customer
			if $"../customers".add_money:
				%money.text += "\n+ $" + str(GameState.added_money) #%money has been marked as a unique name for the money label, allowing it to be called without a path
				
		#determines player direction using a builtin function that accepts input actions as parameters.
		direction = Input.get_axis("left", "right")
		
		if direction: #appraises the truthiness of the direction variable to ensure the player is currently in motion
			$AnimatedSprite2D.flip_h = direction == -1 #if the direction is equal to -1, the sprite is flipped.
			speed += 1 #increases player speed, thus causing them to accelerate.
			speed = min(speed, 120) #circumscribes the maximum speed to 120, mercifully halting the player from attaining infinite velocity
			velocity.x = speed * direction #determines velocity using direction
			$AnimatedSprite2D.play("run") #executes the player run cycle animation
		else:
			#whereupon the direction is evaluated to be 0, the player motion is slowed and the speed is reset to 80.
			velocity.x *= 0.7 
			speed = 80 
			$AnimatedSprite2D.play("idle") #executes the player idle animation

		if interact == "door": #checks whether the player is current within the bounds of the door's collision area
			if Input.is_action_just_pressed("interact"): #checks whether interaction was prompted by the user
				if get_tree().current_scene.name == "main": #systemically evaluates whether the current scene is main or not
					if $"../customers".add_money:
						GameState.money += GameState.added_money
					#whereupon the humble farmer retreats to the door, the scene transforms to the warehouse where further
					#noble argricultural pursuits may be undertaken, to make certain that the population will be adequately sustained.
					get_tree().call_deferred("change_scene_to_file", "res://scenes/warehouse.tscn") 
				else: #in the event that the current scene is therefore, the warehouse
					#the produce is consigned to fully grown states to prevent half-grown produce upon re-entering the warehouse
					if b_growing:
						GameState.b_grown = true
						GameState.b_collected = false
						b_growing = false
					if t_growing:
						GameState.t_grown = true
						GameState.t_collected = false
						t_growing = false
					if l_growing:
						GameState.l_grown = true
						GameState.l_collected = false
						l_growing = false
					get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn") #the scene is transformed to the main scene
				
		if interact == "customers": #performs a systematic evaluation to ascertain any interactions with customers.
			if Input.is_action_just_pressed("interact"): #evaluates if interaction was prompted by the user
				$"../customers".speak(GameState.inventory) #calls unto the customer node to request their needs
		else:
			if has_node("../customers"): 
				#depletes the dialogue label if the customer node resides within the current scene
				$"../customers".clear()
					
		if interact == "tomatoes": #performs an evaluation to ascertain any interactions with tomato planting systems
			if Input.is_action_just_pressed("interact"): #evaluates if interaction was prompted by the user
				if not GameState.t_collected and GameState.t_grown: #checks if tomatoes have been unharvested after they reach a wholly 
					amount = GameState.customers[GameState.customer_index][1] #consigns the amount of requested tomatoes to the amount variable
					if GameState.inventory["tomatoes"] != amount: #executes the block below if the amount of tomatoes requested hath not yet been harvested by the player
						if amount > 0:
							#evaluates tomatoes collected to true if the customer requisitioned any amount of tomatoes
							GameState.t_collected = true
							if amount == 30: #performs a special conditional if the amount of tomatoes solicited is 30, which only occurs with the latermost customer
								amount = 15 #requires only 15 tomatoes to be harvested at a time if the aforementioned conditional evaluates to a true state
							GameState.inventory["tomatoes"] = GameState.inventory.get("tomatoes", 0) + amount #performs an augmentation of the requested tomatoes onto the currently possessed amount 
						#specific conditions after serving specific customers
						if GameState.customer_index == 0:
							GameState.t_grown = false #tomatoes do not grow back
						if GameState.customer_index == 1:
							t_grow() #tomatoes grow back after serving
						if GameState.customer_index == 3:
							#tomatoes remain unchanged due to only a small amount being requisitioned
							GameState.t_collected = false 
							GameState.t_grown = true
						if GameState.customer_index == 4:
							GameState.t_grown = false
						if GameState.customer_index == 5:
							t_grow()
						if GameState.customer_index == 6:
							GameState.t_grown = false
						if GameState.customer_index == 7:
							t_grow()
					
				elif not GameState.t_grown and GameState.bought.has("tomatoes"):
					#ascertains if tomatoes are not grown, yet tomato starts have been acquired.
					GameState.bought.erase("tomatoes") #the starts are planted and erased from the acquisitions list
					t_grow()

		
		if interact == "lettuce": #performs an evaluation to ascertain any interactions with lettuce planting systems
			if Input.is_action_just_pressed("interact"): #evaluates if interaction was prompted by the user
				if not GameState.l_collected and GameState.l_grown: #checks if lettuce have been unharvested after they reach a wholly grown state
					amount = GameState.customers[GameState.customer_index][2] #consigns the amount of requested lettuce to the amount variable
					if GameState.inventory["lettuce"] != amount: #executes the block below if the amount of lettuce requested hath not yet been harvested by the player
						if amount > 0:
							GameState.l_collected = true
							if amount == 30:
								amount = 15
							GameState.inventory["lettuce"] = GameState.inventory.get("lettuce", 0) + amount
							#alas, the reaping of the lettuce hath transpired.
							#and such, it shan't return after the harvest. never, aft its immense sacrifice.
							#such is the cruel essense of agriculture.
							GameState.l_grown = false
							
							if GameState.customer_index == 2:
								show_message("Unfortunately, lettuce heads don't grow back like other plants.")
							if GameState.customer_index == 3:
								GameState.l_collected = false
								GameState.l_grown = true
								
							if GameState.customer_index == 5:
								GameState.l_collected = false
								GameState.l_grown = true
					
				elif not GameState.l_grown and GameState.bought.has("lettuce"):
					#ascertains if lettuce are not grown, yet lettuce starts have been acquired.
					GameState.bought.erase("lettuce") #the starts are planted and erased from the acquisitions list
					l_grow()
				
		
		if interact == "berries": #performs an evaluation to ascertain any interactions with berry planting systems
			if Input.is_action_just_pressed("interact"):
				if not GameState.b_collected and GameState.b_grown:
					amount = GameState.customers[GameState.customer_index][3]
					if GameState.inventory["berries"] != amount: #executes the block below if the amount of berries requested hath not yet been harvested by the player
						if amount > 0:
							GameState.b_collected = true
							GameState.inventory["berries"] = GameState.inventory.get("berries", 0) + amount
						
						if GameState.customer_index == 0:
							GameState.b_grown = false
						if GameState.customer_index == 1:
							b_grow()
						if GameState.customer_index == 4:
							b_grow()
						if GameState.customer_index == 5:
							b_grow()
						if GameState.customer_index == 6:
							GameState.b_grown = false
						
				elif not GameState.b_grown and GameState.bought.has("berries"):
					#ascertains if berries are not grown, yet berries starts have been acquired.
					GameState.bought.erase("berries") #the starts are planted and erased from the acquisitions list
					b_grow()
					
		areas = $Area2D.get_overlapping_areas()
		for area in areas:
			if area.name == "berries":
				if GameState.b_grown: #conducts a conditional evaluation to determine if the boolean assumes a true value.
					#performs an assessment on the aggregated total of berries in the inventory 
					#to check if it is not equal to the amount of berries requested by their majesty the customer. 
					#if they are not of an equivalent value, the instructive label displays informative material,
					#entailing the user action required to perform the harvesting action.
					if GameState.inventory[area.name] != GameState.customers[GameState.customer_index][3]:
						interact = area.name #changes a player variable responsible for storing objects it is in contact with
						%interact.get_node("label").text = "E to harvest"
				else: #if the condition evaluates to false
					#the user is prompted to plant the berry starts if they possess them
					if area.name in GameState.bought:
						interact = area.name
						%interact.get_node("label").text = "E to plant"
					else:
						%interact.get_node("label").text = ""
			elif area.name == "lettuce":
				if GameState.l_grown: #conducts a conditional evaluation to determine if the boolean assumes a true value.
					#performs an assessment on the aggregated total of lettuce heads in the inventory 
					#to check if it is not equal to the amount of lettuce requested by their royal stupendousness the customer. 
					#if they are not of an equivalent value, the instructive label displays informative material,
					#entailing the user action required to perform the harvesting action.
					if GameState.inventory[area.name] != GameState.customers[GameState.customer_index][2]:
						interact = area.name #changes a player variable responsible for storing objects it is in contact with
						%interact.get_node("label").text = "E to harvest"
				else: #if the condition evaluates to false
					#the user is prompted to plant the berry starts if they possess them
					if area.name in GameState.bought:
						interact = area.name
						%interact.get_node("label").text = "E to plant"
					else:
						%interact.get_node("label").text = ""
			elif area.name == "tomatoes":
				if GameState.t_grown: #conducts a conditional evaluation to determine if the boolean assumes a true value.
					#performs an assessment on the aggregated total of lettuce heads in the inventory 
					#to check if it is not equal to the amount of lettuce requested by their royal grandness, the eminent sovereign of infinite velocity, the customer. 
					#if they are not of an equivalent value, the instructive label displays informative material,
					#entailing the user action required to perform the harvesting action.
					if GameState.inventory[area.name] != GameState.customers[GameState.customer_index][1]:
						interact = area.name #changes a player variable responsible for storing objects it is in contact with
						%interact.get_node("label").text = "E to harvest"
				else: #if the condition evaluates to false
					#the user is prompted to plant the berry starts if they possess them
					if area.name in GameState.bought:
						interact = area.name
						%interact.get_node("label").text = "E to plant"
					else:
						%interact.get_node("label").text = ""

		move_and_slide()
