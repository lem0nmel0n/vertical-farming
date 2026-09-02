extends Area2D

#loads the instructional and conversational label nodes into their respective variables to conveniently reference them in forthcoming times
@onready var label : Label = %interact.get_node("label")
@onready var dialogue : Label = %dialogue.get_node("label")
var add_money = false #dictates whether the money addition popup shall be delineated on the top leftmost corner of the screen 
var currently_speaking = false #set currently_speaking to the builtin boolean value that, for lack of any other name, may be called false

func speak(inventory): 
	'''
	called by the player node when it traipses within the bounds of the customer's collision area.
	parameters:
	inventory: the player's inventory, a dictionary with key:val pairs of produce_name:produce_amount
	'''
	if currently_speaking: #stops any further execution of the function
		#if the player is already conversing with their royal prodigiousness, the grand conqueror of all food-related produce, the customer
		return
	currently_speaking = true
	label.text = "" #effectuates the binding of a devoid value to the label.text indentifier, thereby commanding the contents of the label remaining heretofore 
    #to be expunged, effacing any linguistic material inhabiting the label component prior to this instant.
	var customer = GameState.customers[GameState.customer_index] #recuperates customer data from the GameState autoload, including their linguistic choices during
    # the inevitable interlocution betwixt them and the player, and the produce they requisition
	var produce = ["tomatoes", "lettuce", "berries"] #consigns all possible produce within a list abstract data type
	var completed = true #initialises the completed var to a builtin boolean value that, for lack of any other name, may be called false
	for i in produce.size(): #systematically loops through the indices of the produce list
		var item = produce[i] #retrieves the value of the produce
		if not inventory[item] == customer[i+1]: #performs a conditional evaluation to determine if the number of a certain type of produce
			#is not equal to the amount requested by the customer. this implies that the harvesting of such produce hath not occurred,
			#and thereby the order hath not been accomplished.
			completed = false
	if completed: #determines if all requested produce hath been harvested
		var money = customer[4] #initialises the money variable to the fifth item in the customer's data
		GameState.added_money = money #assigns the added_money variable to the customer's payment amount to use in a popup
		if GameState.customer_index != 7: #ensures the customer is not the last
			if GameState.customer_index == 0: #performs a conditional evaluation to determine if the customer is the first
				#displays a popup after the first customer hath been sufficed
				%player.show_message("This farm makes fresh food affordable to combat food insecurity, which impacts about 3.5 million Australian households.")
			clear() #resets the dialogue label's value
			add_money = true #prompts the player script to show the money addition popup
			#resets all produce numbers in the inventory
			GameState.inventory["tomatoes"] = 0
			GameState.inventory["berries"] = 0
			GameState.inventory["lettuce"] = 0
			
			GameState.new_customer = true
			GameState.customer_index += 1 #systematically increments the customer index by 1 to progress to the next customer
			await get_tree().create_timer(1.5).timeout #displays the customer for a short moment before switching to the next customer frame
			$"sprite".frame = GameState.customer_index
			GameState.money += GameState.added_money #performs a standard augmentation of the customer's payment onto the player's aggregated total of money
			add_money = false #prompts the player script to stop showing the money addition popup
			await get_tree().create_timer(1).timeout #waits for a second before displaying the customer's humble request
			customer = GameState.customers[GameState.customer_index]
			dialogue.text = "customer: " + customer[0]
			currently_speaking = false #resets the currently_speaking variable to a boolean value of false
		else: #the block of code below executes if the customer is, unfortunately, the last of the day
			visible = false #incapacitates the customer node's visibility
			$CollisionShape2D.disabled = true #disables the customer node's collision area
			clear() #resets the dialogue text 
			add_money = true #prompts the player script to show the money addition popup
			GameState.inventory["tomatoes"] = 0
			GameState.inventory["berries"] = 0
			GameState.inventory["lettuce"] = 0
			await get_tree().create_timer(1.5).timeout
			GameState.money += GameState.added_money
			add_money = false #prompts the player script to stop showing the money addition popup
			#displays a popup thanking the player for playing through the ups and downs of this rollercoaster 
			#and for being there until the cruel limitations of school videogame project scope hath mercilessly do us part
			%player.show_message("Congratulations on serving all your customers! Thanks for playing :]")
			currently_speaking = false #resets the currently_speaking variable to false

	else:
		dialogue.text = "customer: " + customer[0]
		currently_speaking = false

func clear():
	dialogue.text = ""


func _on_body_entered(body: Node2D) -> void:
	'''
	a builtin Godot function responsible for detecting whether the player 
	hath just entered unto the customer node's CollisionShape
	
	parameters:
	body: the body node (such as CharacterBody2D) that hath entered 
	unto the aforementioned collision area. in most instances, this is the Player node.
	'''
	
	if body.name == "player": #determines whether the provided body node is in fact, the aforementioned player node.
		body.interact = "customers"  #changes the player variable responsible for storing objects it is in contact with
		label.text = "E to interact"

func _on_body_exited(body: Node2D) -> void:
	'''
	an inbuilt Godot function responsible for detecting when a node exits the berries' collision area.
	
	parameters:
	body: the body node that hath just exited the humble collision area
	'''
	if body.name == "player": #determines whether the provided body node is the player node.
		body.interact = "" #resets the player's interact variable
		label.text = "" #resets the instructional label text
