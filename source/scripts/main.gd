extends Node2D


func _ready() -> void: #called upon when the main scene hath first loaded
	$"customers/sprite".frame = GameState.customer_index #performs the assignment of the customer frame to the customer index,
	#reflecting the everchanging nature of even the most loyal of local, organic produce seeking customers.
	if GameState.first_play: #evaluates whether or not the boolean value of first_play is equivalent to true, whereupon the 
		#informative popup shall be cast out of darkness into view of the player, the canvaslayer shall be revealed, and first_play
		#shall be consigned to false.
		%info.visible = true
		%info.get_node("info/canvas").visible = true
		GameState.first_play = false
