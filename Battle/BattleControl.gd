extends Control

enum BattleState {STANDBY, MOVE_SELECT, POKEMON_SELECT, ITEM_SELECT, RUN, DO_MOVE}
var curState = BattleState.STANDBY

var teamPlayer = [pokemon_instance.new().genWild(4), pokemon_instance.new().genWild(3), pokemon_instance.new().genWild(2), pokemon_instance.new().genWild(1), pokemon_instance.new().genWild(1)]
var teamEnemy = [pokemon_instance.new().genWild(1), pokemon_instance.new().genWild(2), pokemon_instance.new().genWild(3), pokemon_instance.new().genWild(4)]
var pokeOpp = teamEnemy[0]
var pokePlayer = teamPlayer[0]

onready var nodeBattleScreen = $BattleScreen

var regist = registry.new()

#BattleState.STANDBY vars
onready var nodeStandByMenu = $StandbyMenu

const ARROWDEFAULT = 6
const ARROWSPACING = 13
const STANDBYOPTIONS = 4

enum StandbyOption {FIGHT, BAG, POKEMON, RUN}
var standbyIndex = StandbyOption.FIGHT



#BattleState.MOVE_SELECT Menu
onready var nodeMoveMenu = $MoveSelectMenu

const MOVEARROWDEFAULT = Vector2(7, 7)

enum MoveOption {M1, M2, M3, M4}
var moveIndex = MoveOption.M1

#BattleState.DO_MOVE State vars
var dialogDone = false
onready var nodeBattleDialog = $BattleDialog

#BattleState.POKEMON_SELECT State vars
onready var nodeSelectPokeMenu = $SelectPokeMenu
onready var nodeSelectPokeMenuArrow = $SelectPokeMenu/BasePanel/Arrow

enum SelectPokeOption {P1, P2, P3, P4, P5, P6}
var selectPokeIndex = SelectPokeOption.P1

const SWITCHARROWDEFAULT = Vector2(37, 58)


func _ready():
	
	nodeStandByMenu.visible = true
	nodeBattleScreen.visible = true
	nodeMoveMenu.visible = false
	nodeSelectPokeMenu.visible = false
	
	setupPlayer()
	setupOpp()
	setupMoveMenu()
	setupSelectPoke()
	
func setupPlayer() -> void:
	pokePlayer = teamPlayer[0]
	nodeStandByMenu.changePrompt("What will " + pokePlayer.nick + " do?") 
	nodeBattleScreen.setupPlayer(pokePlayer)
	nodeBattleScreen.setupPlayerSprite(pokePlayer.nick)
	
func setupMoveMenu():
	nodeMoveMenu.setup(pokePlayer)
	
func setupOpp() -> void:
	nodeBattleScreen.setupOpp(pokeOpp)
	nodeBattleScreen.setupOppSprite(pokeOpp.nick)
	
func updateGameState() -> void:
	nodeBattleScreen.updateGamestate(pokePlayer, pokeOpp)

#func nodeSelectPokeMenu.changeArrowPos(index : int ) -> void:
#	match index:
#		SelectPokeOption.P1:
#			nodeSelectPokeMenuArrow.rect_position = Vector2(37, 58)
#		SelectPokeOption.P2:
#			nodeSelectPokeMenuArrow.rect_position = Vector2(120, 58)
#		SelectPokeOption.P3:
#			nodeSelectPokeMenuArrow.rect_position = Vector2(37, 88)
#		SelectPokeOption.P4:
#			nodeSelectPokeMenuArrow.rect_position = Vector2(120, 88)
#		SelectPokeOption.P5:
#			nodeSelectPokeMenuArrow.rect_position = Vector2(37, 118)
#		SelectPokeOption.P6:
#			nodeSelectPokeMenuArrow.rect_position = Vector2(120, 118)
#	selectPokeIndex = index
	
func oppMoveAI():
	var moveIn = randi()%3+1
	var oppMove = {"move": pokeOpp.moves[moveIn], "self": pokeOpp, "target": pokePlayer}
	return oppMove
	
## Setups the select pokemon menu by using the information in teamPlayer
func setupSelectPoke():
	nodeSelectPokeMenu.setup(teamPlayer)

## Builds a battle queue from the current user move
## together with an AI generated move for themselves 
func buildBattleQueue(move : Move) -> void:
	var battleQueue = []
	var myMove = {"move": move, "self": pokePlayer, "target": pokeOpp}

	var oppMove = oppMoveAI()
	
	if(pokeOpp.rawstats["spe"] > pokePlayer.rawstats["spe"]):
		battleQueue.append(oppMove)
		battleQueue.append(myMove)
	else:
		battleQueue.append(myMove)
		battleQueue.append(oppMove)
		
	executeBattleQueue(battleQueue)
	
func executeBattleQueue(battleQueue):
	for action in battleQueue:
		var move = action["move"]
		var actor = action["self"]
		var target = action["target"]
		
		target.chp -= move.base_power / 10 
		nodeBattleDialog.queue_text(actor.nick + "'s " + move.name + " does " + str(move.base_power / 10) + " damage to " + target.nick)
		updateGameState()

## Switches the current first pokemon in party by changing the order of the teamPlayer array
## Then updates the battlestate and makes the enemy execute their turn.
func switchPokemon(choiceIndex: int) -> void:
	if(choiceIndex >= teamPlayer.size()):
		print("Empty Slot")
		return
	elif(choiceIndex == 0):
		print("Same mon")
		return
		
	var temp = teamPlayer[0]
	teamPlayer[0] = teamPlayer[choiceIndex]
	teamPlayer[choiceIndex] = temp
	
	setupPlayer()
	
	
	
	transistionState(BattleState.POKEMON_SELECT, BattleState.DO_MOVE)
	var aiMove = []
	aiMove.append(oppMoveAI())
	executeBattleQueue(aiMove)

## Use the enum BattleState for current and next
func transistionState(current: int, next: int) -> void:
	match current:
		BattleState.STANDBY:
			nodeStandByMenu.visible = false
		BattleState.MOVE_SELECT:
			nodeMoveMenu.visible = false
		BattleState.DO_MOVE:
			nodeBattleDialog.visible = false
		BattleState.POKEMON_SELECT:
			nodeSelectPokeMenu.visible = false
			selectPokeIndex = 0
		
	match next:
		BattleState.STANDBY:
			curState = BattleState.STANDBY
			nodeStandByMenu.visible = true
		BattleState.MOVE_SELECT:
			curState = BattleState.MOVE_SELECT
			nodeMoveMenu.visible = true
		BattleState.DO_MOVE:
			nodeBattleDialog.visible = true
			curState = BattleState.DO_MOVE
		BattleState.POKEMON_SELECT:
			setupSelectPoke()
			nodeSelectPokeMenu.visible = true
			curState = BattleState.POKEMON_SELECT

func standbyEventHandler(event):
	if event.is_action_pressed("ui_down"):
		if standbyIndex == 3:
			standbyIndex = 0
		else:
			standbyIndex += 1
		nodeStandByMenu.changeArrowPos(standbyIndex)
	elif event.is_action_pressed("ui_up"):
		if standbyIndex == 0:
			standbyIndex = 3
		else:
			standbyIndex -= 1
		nodeStandByMenu.changeArrowPos(standbyIndex)
	elif event.is_action_pressed("ui_accept"):
		match standbyIndex:
			StandbyOption.FIGHT:
				transistionState(BattleState.STANDBY, BattleState.MOVE_SELECT)
			StandbyOption.BAG:
				pass
			StandbyOption.POKEMON:
				transistionState(BattleState.STANDBY, BattleState.POKEMON_SELECT)
				nodeSelectPokeMenu.changeArrowPos(0)
			StandbyOption.RUN:
				pass

func moveSelectEventHandler(event):
	if(event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down") ):
		moveIndex = (moveIndex + 2) % 4
		nodeMoveMenu.changeArrowPos(moveIndex, pokePlayer.moves[moveIndex])
		
	elif(event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right")):
		moveIndex = (moveIndex + 1) if (moveIndex % 2 == 0) else (moveIndex - 1)
		nodeMoveMenu.changeArrowPos(moveIndex, pokePlayer.moves[moveIndex])
		
	elif(event.is_action_pressed("ui_cancel")):
		transistionState(BattleState.MOVE_SELECT, BattleState.STANDBY)
		
	elif(event.is_action_pressed("ui_select")):
		var mymove = moveIndex
		transistionState(BattleState.MOVE_SELECT, BattleState.DO_MOVE)
		buildBattleQueue(pokePlayer.moves[mymove])
		
func pokemonSelectEventHandler(event):
	if event.is_action_pressed("ui_up") :
		selectPokeIndex = (selectPokeIndex + 4) % 6
		nodeSelectPokeMenu.changeArrowPos(selectPokeIndex)
	if event.is_action_pressed("ui_down") :
		selectPokeIndex = (selectPokeIndex + 2) % 6
		nodeSelectPokeMenu.changeArrowPos(selectPokeIndex)
	elif(event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right")):
		selectPokeIndex = (selectPokeIndex + 1) if (selectPokeIndex % 2 == 0) else (selectPokeIndex - 1)
		nodeSelectPokeMenu.changeArrowPos(selectPokeIndex)	
	elif(event.is_action_pressed("ui_cancel")):
		transistionState(BattleState.POKEMON_SELECT, BattleState.STANDBY)
	elif(event.is_action_pressed("ui_select")):
		print("Selected option:")
		print(selectPokeIndex)
		switchPokemon(selectPokeIndex)
			
func _unhandled_input(event):
	match curState:
		BattleState.STANDBY:
			standbyEventHandler(event)
		BattleState.MOVE_SELECT:
			moveSelectEventHandler(event)
		BattleState.DO_MOVE:
			pass
		BattleState.POKEMON_SELECT:
			pokemonSelectEventHandler(event)

## Signal fired by BattleDialog when the text queue has been emptied.
func _on_BattleDialog_allPrinted():
	if(curState == BattleState.DO_MOVE):
		transistionState(BattleState.DO_MOVE, BattleState.STANDBY)
