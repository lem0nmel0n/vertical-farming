extends TextureRect


func _process(delta: float) -> void:
	#perpetually transforms the text pertaining to the inventory popup to reflect current quantity of harvested items
	var tomatoes = str(GameState.inventory["tomatoes"])
	var berries = str(GameState.inventory["berries"])
	var lettuce = str(GameState.inventory["lettuce"])
	var text = "x" + tomatoes + "\nx" + berries + "\nx" + lettuce #joins the total of each produce category into one coherent string
	$"label".text = text
