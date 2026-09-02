extends TextureRect

var buttons = false

func _ready() -> void:
	#disables all buttons when it is first loaded, to ensure farming only commences after the sufficing of the first customer
	for child in $"scroll/vbox".get_children():
		child.disabled = true

func show_buttons():
	#enables all buttons, bestowing unto the player the autonomy to purchase indispensable components for the farm
	for child in $"scroll/vbox".get_children():
		child.disabled = false
		buttons = true

func _on_button_pressed() -> void:
	if subtract_money(80, $"scroll/vbox/button"):
		GameState.bought.append("lights")
		%player.show_message("LED lights are essential for indoor vertical farming. They are energy efficient and replace sunlight.")

func _on_button_2_pressed() -> void:
	if subtract_money(180, $"scroll/vbox/button2"):
		GameState.bought.append("racks")

func _on_button_3_pressed() -> void:
	if ["lights", "racks", "pump"].all(func(equip): return equip in GameState.bought):
		if subtract_money(20, $"scroll/vbox/button3"):
			$"scroll/vbox/button3".disabled = true
			GameState.bought.append("pipes")

func _on_button_4_pressed() -> void:
	if subtract_money(40, $"scroll/vbox/button4"):
		$"scroll/vbox/button4".disabled = true
		GameState.bought.append("pump")
		%player.show_message("The water pump circulates water through the system. Nutrient rich water is reused to reduce waste.")

func _on_button_8_pressed() -> void:
	if subtract_money(15, $"scroll/vbox/button8"):
		$"scroll/vbox/button8".disabled = true
		GameState.bought.append("nutrients")
		%player.show_message("Nutrient solutions feed plant roots, so they can grow without soil. Recycling this water keeps water use low in vertical farms.")

func _on_button_5_pressed() -> void:
	if "tomatoes" in GameState.bought:
		return
	if subtract_money(15, $"scroll/vbox/button5"):
		if GameState.first_buy:
			GameState.first_buy = false
			%player.show_message("You've just bought tomato starts. Walk to the leftmost rack to plant them.")
		GameState.bought.append("tomatoes")
	
func _on_button_6_pressed() -> void:
	if "lettuce" in GameState.bought:
		return
	if subtract_money(15, $"scroll/vbox/button6"):
		GameState.bought.append("lettuce")
	
func _on_button_7_pressed() -> void:
	if "berries" in GameState.bought:
		return
	if subtract_money(15, $"scroll/vbox/button7"):
		GameState.bought.append("berries")


func subtract_money(cost, button):
	if GameState.money - cost >= 0:
		GameState.money -= cost
		button.disabled = true
		return true
	return false
