extends TileMap
class_name ObstaclesMap

@export var spike_layer: int = 0  # The layer where spikes are placed
var damage_zone_scene = preload("res://scenes/attacks/damage_zone.tscn")

func _ready():
	generate_spike_areas()

func generate_spike_areas():
	# Get all used cells in the spike layer
	var used_cells = get_used_cells(spike_layer)
	
	for cell in used_cells:
		var tile_data = get_cell_tile_data(spike_layer, cell)
		print("Processing cell: ", cell)
		
		if tile_data:
			create_area_for_tile(cell)

func create_area_for_tile(cell_position: Vector2i):
	# Instance your DamageZone scene
	var area = damage_zone_scene.instantiate()
	area.name = "DamageZone_%d_%d" % [cell_position.x, cell_position.y]
	
	# Get the tile size as Vector2
	var tile_size = Vector2(tile_set.tile_size)
	
	# Convert map position to local position (returns Vector2i)
	var tile_top_left = map_to_local(cell_position)
	
	# Convert to Vector2 and add half tile size to center the area
	var tile_center = Vector2(tile_top_left) + tile_size / 2
	area.position = tile_center
	
	# Check if the DamageZone already has a collision shape
	if not has_collision_shape(area):
		# Add a collision shape that matches the tile
		add_collision_shape_to_area(area, tile_size)
	
	# Add the area as a child of the TileMap
	add_child(area)
	
	print("Created spike area at: ", area.position)

# Helper function to check if Area2D already has a collision shape
func has_collision_shape(area: Area2D) -> bool:
	for child in area.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			return true
	return false

# Helper function to add a collision shape to the Area2D
func add_collision_shape_to_area(area: Area2D, size: Vector2):
	var collision = CollisionShape2D.new()
	var rectangle = RectangleShape2D.new()
	rectangle.size = size
	collision.shape = rectangle
	area.add_child(collision)
