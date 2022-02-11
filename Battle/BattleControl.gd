extends Control

enum BattleState {STANDBY, MOVE_SELECT, POKEMON_SELECT, ITEM_SELECT, RUN, DO_MOVE}
var curState = BattleState.STANDBY

var teamPlayer = [pokemon_instance.new().genWild(1), pokemon_instance.new().genWild(3), pokemon_instance.new().genWild(2), pokemon_instance.new().genWild(4), pokemon_instance.new().genWild(1), pokemon_instance.new().genWild(5)]
var teamEnemy = [pokemon_instance.new().genWild(4), pokemon_instance.new().genWild(2), pokemon_instance.new().genWild(3), pokemon_instance.new().genWild(4)]
var pokeOpp = teamEnemy[0]
var pokePlayer = teamPlayer[0]

var regist = registry.new()

onready var nodeBattleScreen = $BattleScreen

#BattleState.STANDBY vars
onready var nodeStandByMenu = $StandbyMenu

enum StandbyOption {FIGHT, BAG, POKEMON, RUN}
var standbyIndex = StandbyOption.FIGHT

#BattleState.MOVE_SELECT Menu
onready var nodeMoveMenu = $MoveSelectMenu

enum MoveOption {M1, M2, M3, M4}
var moveIndex = MoveOption.M1

#BattleState.DO_MOVE State vars
onready var nodeBattleDialog = $BattleDialog

#BattleState.POKEMON_SELECT State vars
onready var nodeSelectPokeMenu = $SelectPokeMenu

enum SelectPokeOption {P1, P2, P3, P4, P5, P6}
var selectPokeIndex = SelectPokeOption.P1


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
	
func setupMoveMenu() -> void:
	nodeMoveMenu.setup(pokePlayer)
	
func setupOpp() -> void:
	nodeBattleScreen.setupOpp(pokeOpp)
	nodeBattleScreen.setupOppSprite(pokeOpp.nick)
	
## Setups the select pokemon menu by using the information in teamPlayer
func setupSelectPoke() -> void:
	nodeSelectPokeMenu.setup(teamPlayer)
	
func updateGameState() -> void:
	nodeBattleScreen.updateGamestate(pokePlayer, pokeOpp)
	
func oppActionAI():
	var moveIn = randi()%3+1
	var oppMove = pokeOpp.moves[moveIn]
	var oppAction = action.new(action.ActionType.MOVE, oppMove, pokeOpp, pokePlayer, oppMove.priority)
	return oppAction

## Builds a battle queue from the current user move
## together with an AI generated move for themselves 
func buildBattleQueue(myAction : action) -> void:
	var battleQueue = []

	var oppAction = oppActionAI()
	
	battleQueue.append(oppAction)
	battleQueue.append(myAction)

	battleQueue.sort_custom(action, "sortSpeed")
	battleQueue.sort_custom(action, "sortPriority")

	executeBattleQueue(battleQueue)
	
func executeBattleQueue(battleQueue) -> void:
	for act in battleQueue:
		if act.actionType == action.ActionType.MOVE:
			var target
			if(act.actor == pokePlayer):
				target = pokeOpp
			elif(act.actor == pokeOpp):
				target = pokePlayer 
			
			var dmg = calcDamage(act.actor, act.target, act.move)
			target.chp -= dmg
			nodeBattleDialog.queue_text(act.actor.nick + "'s " + act.move.name + " does " + str(dmg) + " damage to " + target.nick)
		elif act.actionType == action.ActionType.SWITCH:
			switchPokemon(selectPokeIndex)
	updateGameState()
	
func calcDamage(actor, target, move):
	var damage: int = (((((2*actor.level)/5) + 2) * move.base_power * (actor.rawstats["atk"] / target.rawstats["def"]))/50)+2
	#damage *= targets
	#damage *= weather
	
	##Crit
	var crit = randi()%10+1
	if crit == 1:
		damage *= 1.5
		
	#DamageRnage
	var randmod = randi()%16+1
	damage = (damage * (100 - randmod))/100
	
	##STAB
	if actor.type1 == move.type || actor.type2 == move.type:
		damage *= 1.5
		print("STAB")
		
	##Type Effectiveness
	var typemod = Type.type_advantage_multiplier(move.type, target)
	damage *= typemod
	print("Typemod: " + str(typemod))
	##Burn halved attack
	
	##Other
	
	if damage == 0:
		damage = 1
		
	return damage

## Switches the current first pokemon in party by changing the order of the teamPlayer array
## Then updates the battlestate and makes the enemy execute their turn.
func switchPokemon(choiceIndex: int) -> void:
	var temp = teamPlayer[0]
	teamPlayer[0] = teamPlayer[choiceIndex]
	teamPlayer[choiceIndex] = temp
	
	setupPlayer()
	setupMoveMenu()

func validSwitch(choiceIndex: int) -> bool:
	if(choiceIndex >= teamPlayer.size()):
		print("Empty Slot")
		return false
	elif(choiceIndex == 0):
		print("Same mon")
		return false
	return true
		
## Use the enum BattleState for current and next
func transistionState(next: int) -> void:
	match curState:
		BattleState.STANDBY:
			nodeStandByMenu.visible = false
		BattleState.MOVE_SELECT:
			nodeMoveMenu.visible = false
		BattleState.DO_MOVE:
			nodeBattleDialog.visible = false
		BattleState.POKEMON_SELECT:
			nodeSelectPokeMenu.visible = false
			
		
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
			selectPokeIndex = 0
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
				transistionState(BattleState.MOVE_SELECT)
			StandbyOption.BAG:
				pass
			StandbyOption.POKEMON:
				transistionState(BattleState.POKEMON_SELECT)
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
		transistionState(BattleState.STANDBY)
		
	elif(event.is_action_pressed("ui_select")):
		var myMove = pokePlayer.moves[moveIndex]
		var myAction = action.new(action.ActionType.MOVE, myMove, pokePlayer, pokeOpp, myMove.priority)
		transistionState(BattleState.DO_MOVE)
		buildBattleQueue(myAction)
		
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
		transistionState(BattleState.STANDBY)
	elif(event.is_action_pressed("ui_select")):
		print("Selected option:")
		print(selectPokeIndex)
		if validSwitch(selectPokeIndex):
			var myAction = action.new(action.ActionType.SWITCH, null, teamPlayer[selectPokeIndex], null, 7)
			transistionState(BattleState.DO_MOVE)
			buildBattleQueue(myAction)
			
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
		transistionState(BattleState.STANDBY)
