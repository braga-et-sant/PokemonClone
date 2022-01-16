extends Control

enum BattleState {STANDBY, MOVE_SELECT, POKEMON_SELECT, ITEM_SELECT, RUN, DO_MOVE}
var curState = BattleState.STANDBY

var teamPlayer = [pokemon_instance.new().genWild(4), pokemon_instance.new().genWild(3), pokemon_instance.new().genWild(2), pokemon_instance.new().genWild(1)]
var teamEnemy = [pokemon_instance.new().genWild(1), pokemon_instance.new().genWild(2), pokemon_instance.new().genWild(3), pokemon_instance.new().genWild(4)]
var pokeOpp = teamEnemy[0]
var pokePlayer = teamPlayer[0]



var pokeSprite
var oppSprite

var regist = registry.new()

# Standby Menu
onready var standByMenu = $StandbyMenu
onready var arrow = $StandbyMenu/SelectAction/ArrowSelect

const ARROWDEFAULT = 6
const ARROWSPACING = 13
const STANDBYOPTIONS = 4

enum StandbyOption {FIGHT, BAG, POKEMON, RUN}
var standbyIndex = StandbyOption.FIGHT



#Move Select Menu
onready var moveMenu = $MoveSelectMenu
onready var moveArrow = $MoveSelectMenu/MoveSelect/ArrowSelect

onready var ppValue = $MoveSelectMenu/MoveInfo/MovePP/PPInfo
onready var typeInfo = $MoveSelectMenu/MoveInfo/MoveType/TypeInfo

const MOVEARROWDEFAULT = Vector2(7, 7)

enum MoveOption {M1, M2, M3, M4}
var moveIndex = MoveOption.M1

#doMove
var dialogDone = false
onready var battleDialog = $BattleDialog

#Switch Menu
onready var selectMenu = $Switch
onready var switchArrow = $Switch/BasePanel/Arrow

enum SwitchOption {P1, P2, P3, P4, P5, P6}
var switchIndex = SwitchOption.P1

const SWITCHARROWDEFAULT = Vector2(37, 58)


func _ready():
	arrow.rect_position.y = ARROWDEFAULT # 13 between select
	moveArrow.rect_position = MOVEARROWDEFAULT
	standByMenu.visible = true
	moveMenu.visible = false
	selectMenu.visible = false
	
	setupPlayer()
	setupOpp()
	setupSwitch()
	
func setupPlayer() -> void:
	
	pokePlayer = teamPlayer[0]
	
	$StandbyMenu/MessageBox/StandbyPrompt.text = "What will " + pokePlayer.nick + " do?"
	
	$BattleScreen/PlayPoke/HpProgress/Cvalue.text = str(pokePlayer.chp)
	$BattleScreen/PlayPoke/HpProgress/Mvalue.text = str(pokePlayer.rawstats.hp)
	$BattleScreen/PlayPoke/HpBar.max_value = pokePlayer.rawstats.hp
	$BattleScreen/PlayPoke/Name.text = pokePlayer.nick
	$BattleScreen/PlayPoke/Level.text =  "Lv " + str(pokePlayer.level)
	$MoveSelectMenu/MoveSelect/MoveBox/Move1.text = pokePlayer.moves[0].name
	$MoveSelectMenu/MoveSelect/MoveBox/Move2.text = pokePlayer.moves[1].name
	$MoveSelectMenu/MoveSelect/MoveBox/Move3.text = pokePlayer.moves[2].name
	$MoveSelectMenu/MoveSelect/MoveBox/Move4.text = pokePlayer.moves[3].name
	
	var filepath = regist.get_pokemon_class(pokePlayer.ID).spritenode
	
	$BattleScreen.remove_child(pokeSprite)
	pokeSprite = load(filepath).instance()
	pokeSprite.flag = 0
	pokeSprite.position = ($BattleScreen/PlaySprite.position)
	$BattleScreen/PlaySprite.visible = false
	$BattleScreen.add_child(pokeSprite)
	
	
func setupOpp() -> void:
	$BattleScreen/OppPoke/HpProgress/Cvalue.text = str(pokeOpp.chp)
	$BattleScreen/OppPoke/HpProgress/Mvalue.text = str(pokeOpp.rawstats.hp)
	$BattleScreen/OppPoke/Name.text = pokeOpp.nick
	$BattleScreen/OppPoke/Level.text = "Lv " + str(pokeOpp.level)
	$BattleScreen/OppPoke/HpBar.max_value = pokeOpp.rawstats.hp
	
	var filepath = regist.get_pokemon_class(pokeOpp.ID).spritenode
	
	oppSprite = load(filepath).instance()
	oppSprite.flag = 1
	oppSprite.position = ($BattleScreen/OppSprite.position)
	$BattleScreen/OppSprite.visible = false
	$BattleScreen.add_child(oppSprite)
	
func updateGameState() -> void:
	$BattleScreen/PlayPoke/HpProgress/Cvalue.text = str(pokePlayer.chp)
	$BattleScreen/OppPoke/HpProgress/Cvalue.text = str(pokeOpp.chp)
	$BattleScreen/OppPoke/HpBar.value = pokeOpp.chp
	$BattleScreen/PlayPoke/HpBar.value = pokePlayer.chp

func changeArrowPosStandby(index : int ) -> void:
	arrow.rect_position.y =  ARROWDEFAULT + (index % STANDBYOPTIONS) * ARROWSPACING
	standbyIndex = index
	
func oppMoveAI():
	var moveIn = randi()%3+1
	var oppMove = {"move": pokeOpp.moves[moveIn], "self": pokeOpp, "target": pokePlayer}
	return oppMove

func setupSwitch():
	var grid = $Switch/BasePanel/PartyContainer
	var count = 0
	for child in grid.get_children():
		if(count != teamPlayer.size() and teamPlayer[count] != null):
			child.text = teamPlayer[count].nick
			child.get_child(0).text = str(teamPlayer[count].chp) + "/" + str(teamPlayer[count].rawstats["hp"])
			count+=1
		else:
			child.text = "		-		"
			child.get_child(0).text = ""
			
func executeBattle(move : Move) -> void:
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
		battleDialog.queue_text(actor.nick + "'s " + move.name + " does " + str(move.base_power / 10) + " damage to " + target.nick)
		updateGameState()
		
	
func changeArrowPosMove(index : int ) -> void:
	moveIndex = index
	match index:
		MoveOption.M1:
			moveArrow.rect_position = Vector2(7, 7)
		MoveOption.M2:
			moveArrow.rect_position = Vector2(80, 7)
		MoveOption.M3:
			moveArrow.rect_position = Vector2(7, 31)
		MoveOption.M4:
			moveArrow.rect_position = Vector2(80, 31)
	ppValue.text = str(pokePlayer.moves[index].total_pp) + "/" + str(pokePlayer.moves[index].total_pp)
	typeInfo.text = TypeStr.new().toStr(pokePlayer.moves[index].type)
		
func changeArrowPosSwitch(index : int ) -> void:
	match index:
		SwitchOption.P1:
			switchArrow.rect_position = Vector2(37, 58)
		SwitchOption.P2:
			switchArrow.rect_position = Vector2(120, 58)
		SwitchOption.P3:
			switchArrow.rect_position = Vector2(37, 88)
		SwitchOption.P4:
			switchArrow.rect_position = Vector2(120, 88)
		SwitchOption.P5:
			switchArrow.rect_position = Vector2(37, 118)
		SwitchOption.P6:
			switchArrow.rect_position = Vector2(120, 118)
	switchIndex = index
	
func switchPokemon() -> void:
	
	if(switchIndex >= teamPlayer.size()):
		print("Empty Slot")
		return
	elif(switchIndex == 0):
		print("Same mon")
		return
		
	var temp = teamPlayer[0]
	teamPlayer[0] = teamPlayer[switchIndex]
	teamPlayer[switchIndex] = temp
	
	setupPlayer()
	
	
	var aiMove = []
	aiMove.append(oppMoveAI())
	print(aiMove.size())
	executeBattleQueue(aiMove)
	
	transistionState(BattleState.POKEMON_SELECT, BattleState.STANDBY)
	
func transistionState(current: int, next: int) -> void:
	match current:
		BattleState.STANDBY:
			standByMenu.visible = false
			
		BattleState.MOVE_SELECT:
			moveMenu.visible = false
			moveIndex = 0
		BattleState.DO_MOVE:
			battleDialog.visible = false
		BattleState.POKEMON_SELECT:
			selectMenu.visible = false
			switchIndex = 0
		
	match next:
		BattleState.STANDBY:
			curState = BattleState.STANDBY
			standByMenu.visible = true
		BattleState.MOVE_SELECT:
			curState = BattleState.MOVE_SELECT
			moveMenu.visible = true
		BattleState.DO_MOVE:
			battleDialog.visible = true
			curState = BattleState.DO_MOVE
		BattleState.POKEMON_SELECT:
			setupSwitch()
			selectMenu.visible = true
			curState = BattleState.POKEMON_SELECT
			
func _unhandled_input(event):
	match curState:
		BattleState.STANDBY:
			if event.is_action_pressed("ui_down"):
				if standbyIndex == 3:
					standbyIndex = 0
				else:
					standbyIndex += 1
				changeArrowPosStandby(standbyIndex)
			elif event.is_action_pressed("ui_up"):
				if standbyIndex == 0:
					standbyIndex = 3
				else:
					standbyIndex -= 1
				changeArrowPosStandby(standbyIndex)
			elif event.is_action_pressed("ui_accept"):
			
				match standbyIndex:
					StandbyOption.FIGHT:
						transistionState(BattleState.STANDBY, BattleState.MOVE_SELECT)
						changeArrowPosMove(0)
					StandbyOption.BAG:
						pass
					StandbyOption.POKEMON:
						transistionState(BattleState.STANDBY, BattleState.POKEMON_SELECT)
						changeArrowPosSwitch(0)
					StandbyOption.RUN:
						pass
						
		BattleState.MOVE_SELECT:
			if(event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down") ):
				match moveIndex:
					MoveOption.M1:
						moveIndex = MoveOption.M3
					MoveOption.M2:
						moveIndex = MoveOption.M4
					MoveOption.M3:
						moveIndex = MoveOption.M1
					MoveOption.M4:	
						moveIndex = MoveOption.M2
				changeArrowPosMove(moveIndex)	
			elif(event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right")):
				match moveIndex:
					MoveOption.M1:
						moveIndex = MoveOption.M2
					MoveOption.M2:
						moveIndex = MoveOption.M1
					MoveOption.M3:
						moveIndex = MoveOption.M4
					MoveOption.M4:	
						moveIndex = MoveOption.M3
				changeArrowPosMove(moveIndex)	
			elif(event.is_action_pressed("ui_cancel")):
				transistionState(BattleState.MOVE_SELECT, BattleState.STANDBY)
			elif(event.is_action_pressed("ui_select")):
				var mymove = moveIndex
				transistionState(BattleState.MOVE_SELECT, BattleState.DO_MOVE)
				executeBattle(pokePlayer.moves[mymove])
		BattleState.DO_MOVE:
			if(event.is_action_pressed("ui_cancel") || event.is_action_pressed("ui_select")):
				pass#transistionState(BattleState.DO_MOVE, BattleState.STANDBY)
		BattleState.POKEMON_SELECT:
			if event.is_action_pressed("ui_up") :
				match switchIndex:
					SwitchOption.P1:
						switchIndex = SwitchOption.P5
					SwitchOption.P2:
						switchIndex = SwitchOption.P6
					SwitchOption.P3:
						switchIndex = SwitchOption.P1
					SwitchOption.P4:	
						switchIndex = SwitchOption.P2
					SwitchOption.P5:	
						switchIndex = SwitchOption.P3
					SwitchOption.P6:	
						switchIndex = SwitchOption.P4
				changeArrowPosSwitch(switchIndex)
			if event.is_action_pressed("ui_down") :
				match switchIndex:
					SwitchOption.P1:
						switchIndex = SwitchOption.P3
					SwitchOption.P2:
						switchIndex = SwitchOption.P4
					SwitchOption.P3:
						switchIndex = SwitchOption.P5
					SwitchOption.P4:	
						switchIndex = SwitchOption.P6
					SwitchOption.P5:	
						switchIndex = SwitchOption.P1
					SwitchOption.P6:	
						switchIndex = SwitchOption.P2
				changeArrowPosSwitch(switchIndex)
			elif(event.is_action_pressed("ui_left") || event.is_action_pressed("ui_right")):
				match switchIndex:
					SwitchOption.P1:	
						switchIndex = SwitchOption.P2
					SwitchOption.P2:	
						switchIndex = SwitchOption.P1
					SwitchOption.P3:	
						switchIndex = SwitchOption.P4
					SwitchOption.P4:	
						switchIndex = SwitchOption.P3
					SwitchOption.P5:	
						switchIndex = SwitchOption.P6
					SwitchOption.P6:	
						switchIndex = SwitchOption.P5
				changeArrowPosSwitch(switchIndex)	
			elif(event.is_action_pressed("ui_cancel")):
				transistionState(BattleState.POKEMON_SELECT, BattleState.STANDBY)
			elif(event.is_action_pressed("ui_select")):
				print("Selected option:")
				print(switchIndex)
				switchPokemon()


func _on_BattleDialog_allPrinted():
	if(curState == BattleState.DO_MOVE):
		transistionState(BattleState.DO_MOVE, BattleState.STANDBY)
