extends Node2D

onready var ground 
onready var grass
onready var collision 
onready var passthrough 
onready var objects 
onready var actors 

onready var actors_pos = []
onready var objects_pos = []

func setup():
	if $Ground:
		ground = $Ground
	if $Grass:
		grass = $Grass
	if $CollisionObjects:
		collision = $CollisionObjects
	if $PassthroughObjects:
		passthrough = $PassthroughObjects
	if $Objects:
		objects = $Objects
	if $Actors:
		actors = $Actors

func _ready():
	setup()
	for child in actors.get_children():
		actors_pos.append(ground.world_to_map(child.position))
	for child in objects.get_children():
		objects_pos.append(ground.world_to_map(child.position))
		
	print("Actors pos:")
	print(actors_pos)
	print("Object pos:")
	print(objects_pos)
	
	
	
func request_move(pawn, direction):
	var cell_start = ground.world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_ground = ground.get_cellv(cell_target)
	var cell_target_col = collision.get_cellv(cell_target)
	
	if(cell_target in objects_pos):
		var objfound = findObj(cell_target)
		print(objfound.name)
	elif cell_target in actors_pos:
		var actfound = findActor(cell_target)
		var actname = "" if actfound == null else actfound.name
		print(actname)
	elif cell_target_ground != -1 and cell_target_col == -1:
		return update_pawn_position(pawn, cell_start, cell_target)
	else:
		print(cell_target_ground)
		print(cell_target_col)
		
func look_ahead(pawn, direction):
	var cell_start = ground.world_to_map(pawn.position)
	var cell_target = cell_start + direction
	if(cell_target in objects_pos):
		print("Ahead is an object")
		var objfound = findObj(cell_target)
		return objfound
	elif cell_target in actors_pos:
		print("Ahead is an actor")
		var actfound = findActor(cell_target)
		return actfound
	else:
		print("There's nothing ahead")
		return null

func update_pawn_position(_pawn, cell_start, cell_target):
	var index = actors_pos.find(cell_start)
	actors_pos[index] = cell_target
	return ground.map_to_world(cell_target) + ground.cell_size / 2

func findObj(coords):
	for child in objects.get_children():
		if ground.world_to_map(child.position) == coords:
			return child

func findActor(coords):
	for child in actors.get_children():
		if ground.world_to_map(child.position) == coords:
			return child
			
func findObjPos(pawn):
	for child in objects.get_children():
		if ground.world_to_map(child.position) == ground.world_to_map(pawn.position):
			return child

func findActPos(pawn):
	for child in actors_pos.get_children():
		if ground.world_to_map(child.position) == ground.world_to_map(pawn.position):
			return child
