extends Node

@onready var _MainWindow: Window = get_window()
@onready var _SubWindow: Window = $Window
var windows: Array[Window] = []

@export var player_size: Vector2i = Vector2i(80, 80) # Should be the size of your character sprite, or slightly bigger

@export_range(0, 19) var player_visibility_layer: int = 1
@export_range(0, 19) var world_visibility_layer: int = 0

@export_node_path("Camera2D") var main_camera: NodePath
@onready var _MainCamera: Camera2D = get_node(main_camera)

func _ready():
	for child in get_children():
		if child is Window:
			windows.append(child)
	# Enable per-pixel transparency, required for transparent windows but has a performance cost
	# Can also break on some systems
	# Set the window settings - most of them can be set in the project settings
	_MainWindow.borderless = true		# Hide the edges of the window
	_MainWindow.unresizable = true		# Prevent resizing the window
	_MainWindow.always_on_top = true	# Force the window always be on top of the screen
	_MainWindow.gui_embed_subwindows = false # Make subwindows actual system windows <- VERY IMPORTANT
	_MainWindow.transparent = true		# Allow the window to be transparent
	# Settings that cannot be set in project settings
	_MainWindow.transparent_bg = true	# Make the window's background transparent

	# The window's size may need to be smaller than the default minimum size
	# so we have to change the minimum size BEFORE setting the window's size
	_MainWindow.min_size = player_size * Vector2i(_MainCamera.zoom)
	_MainWindow.size = _MainWindow.min_size
	
	# To only see the character in the main window, we need to 
	# move its sprite on a separate visibility layer from the world
	# and set the main window to cull (not show) the world's visibility layer
	_MainWindow.set_canvas_cull_mask_bit(player_visibility_layer, true)
	_MainWindow.set_canvas_cull_mask_bit(world_visibility_layer, false)

	# Contrarily to the main window, hide the player and show the world
	for window in windows:
		if window == _MainWindow:
			continue
		window.set_canvas_cull_mask_bit(player_visibility_layer, false)
		window.set_canvas_cull_mask_bit(world_visibility_layer, true)
		window.borderless = false;
		window.world_2d = _MainWindow.world_2d
	
func _process(delta):
	# Update the main window's position
	_MainWindow.position = get_window_pos_from_camera()
	if not _MainWindow.has_focus():
		_MainWindow.grab_focus()
	_MainWindow.always_on_top = true

func get_window_pos_from_camera()->Vector2i:
	return (Vector2i(_MainCamera.global_position + _MainCamera.offset) - player_size / 2) * Vector2i(_MainCamera.zoom)
