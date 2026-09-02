extends Node2D

#consigns the sprite2D node of each category of produce to 3 distinct variables to guarantee unarduous reference in forthcoming circumstances
@onready var tomatoes : Sprite2D = $"warehouse_bg/tomatoes/sprite"
@onready var lettuce : Sprite2D = $"warehouse_bg/lettuce/sprite"
@onready var berries : Sprite2D = $"warehouse_bg/berries/sprite"

func _process(delta) -> void:
	#store buttons are disabled by default, to prevent the premature purchasing of components, as they are not required for the inaugural customer.
	#the block below enables the buttons if the first customer hath been valeted
	if GameState.customer_index > 0:
		if %store.buttons == false: 
			%store.show_buttons()

	if "lights" in GameState.bought:
		#the new warehouse texture incorporating the prescence of the light-emitted diodes are loaded, and the hue pertaining to the floor
		#is transformed to complement it
		$"warehouse_bg".texture = load("res://assets/warehouse2.png") 
		$"warehouse_bg/ColorRect".color = Color("3e3d3b")
		%store.get_node("scroll/vbox/button").disabled = true #the LED procuring button is disabled.
		#nodes that are bestowed unique designations may be directly summoned using the grand %,
		#however, procuring nodes that comprise their progreny necessitates the use of the .get_node method
	if "racks" in GameState.bought:
		#the rack procuring button hath been disabled, the textures for the lettuce and tomato racks loaded and sliced into frames,
		#and the berry rack is brought into view, expunged from the darkness it knew
		%store.get_node("scroll/vbox/button2").disabled = true
		tomatoes.texture = load("res://assets/rack1-Sheet.png")
		tomatoes.hframes = 3
		lettuce.texture = load("res://assets/rack2-Sheet.png")
		lettuce.hframes = 3
		$"warehouse_bg/berries".visible = true
		$warehouse_bg/berries/CollisionShape2D.disabled = false
		
		#these next 3 blocks dictate which frames must be delineated to match the growth state of each produce category.
		if GameState.t_collected:
			#the crop hath been reaped, and therefore the rack is transformed to an empty state, once again beseeching the player to sow starts.
			tomatoes.frame = 0
		elif not GameState.t_grown:
			#the crop hath not been collected nor attained a fully grown state, hereby the humble sprite is commanded to abandon its 
			#current visual impression and assume the depiction of frame 1, therefore depicting the intermediate cultivation stage
			tomatoes.frame = 1
		else:
			#the crop hath not been reaped, yet it has secured a fully grown state. therefore it is ordered to drop its previous facade of incompleteness
			#and assume frame 2, displaying the produce at its grandest stage.
			tomatoes.frame = 2
		
		#frame transformations for the lettuce
		if GameState.l_collected:
			lettuce.frame = 0
		elif not GameState.l_grown:
			lettuce.frame = 1
		else:
			lettuce.frame = 2
		
		#frame transformations for the berries
		if GameState.b_collected:
			berries.frame = 0
		elif not GameState.b_grown:
			berries.frame = 1
		else:
			berries.frame = 2
			
	else:
		#the execution of this block occurs if vertical farming racks hath not yet been acquisitioned
		if GameState.customer_index == 0: 
			#if the current custoemr hath been identified as the first of his kind, the bountiful tomato and lettuce crops start in a grown state
			#as they have not been collected until the present
			#once they are collected, the frame is transformed to an empty state
			if GameState.t_collected:
				tomatoes.frame = 1
			if GameState.l_collected:
				lettuce.frame = 1
		else:
			#the initial tomato and lettuce plants are reduced to an empty state if racks hath not been aquired
			tomatoes.frame = 1
			lettuce.frame = 1
	if "pump" in GameState.bought:
		#if ascuqisitions list consists of a humble water pump, the player is perpetually barred from purchasing it once more
		#through the incapacitation of the water pump button
		$"warehouse_bg/waterpump".visible = true
		%store.get_node("scroll/vbox/button4").disabled = true

	if "pipes" in GameState.bought:
		#if ascuqisitions list consists of pipes, the player is perpetually barred from purchasing them once more
		#through the incapacitation of the pipe purchasing button
		$"warehouse_bg/pipes".visible = true
		%store.get_node("scroll/vbox/button3").disabled = true
		
	if "nutrients" in GameState.bought:
		#if ascuqisitions list consists of nutrient solution, the player is perpetually barred from purchasing it once more
		#through the incapacitation of the nutrient button
		%store.get_node("scroll/vbox/button8").disabled = true

	#systemically performs a conditional evalUation of every item in the list of prescribed equipment, determining if each individual 
	#item hath been identified to coexist with each other, within the indexed, alterable GameState.bought sequence which possesses the 
	#ability to contain heterogenous elements, although this power is not abused for the current inventory of bought items
	if not ["lights", "racks", "pipes", "pump", "nutrients"].all(func(equip): return equip in GameState.bought):
		#the player is obstructed from purchasing crop starts until necessary equipment hath been procured
		%store.get_node("scroll/vbox/button5").disabled = true
		%store.get_node("scroll/vbox/button6").disabled = true
		%store.get_node("scroll/vbox/button7").disabled = true
	else:
		#the player is given imprimatur to purchase crop starts due to the procuremnet of necessary equipment
		%store.get_node("scroll/vbox/button5").disabled = false
		%store.get_node("scroll/vbox/button6").disabled = false
		%store.get_node("scroll/vbox/button7").disabled = false
	
