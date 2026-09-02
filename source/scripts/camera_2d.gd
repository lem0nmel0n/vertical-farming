extends Camera2D

var base_dimensions : Vector2 = Vector2(1920, 1080) #consigns the yardstick visial display unit (VDU) resolution to the base_dimensions variable,
#which hath 1920px and 1080px inhering within it as a humble Vector2 builtin data structure

func _ready() -> void: #builtin function that runs upon the initialisation of the humble Camera2d node
	update_zoom() #triggers the execution of the update_zoom function


func update_zoom():
	'''
	calculates the camera zoom based on screen resolution.
	this is useful for high-resolution screens that may render the game art much smaller.
	parameters:
	none
	'''
	var screen_size = DisplayServer.screen_get_size()
	var x = screen_size.x / base_dimensions.x
	var y = screen_size.y / base_dimensions.y
	var zoom_size = max(x, y)
	zoom = Vector2(zoom_size*1.4, zoom_size*1.4) #1.4 is the base camera zoom
	%canvas_control.scale = Vector2(zoom_size, zoom_size) #scales up canvaslayer children, as they are unaffected by camera scaling or movement
