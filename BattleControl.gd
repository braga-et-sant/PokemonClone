extends Control

enum BattleState {STANDBY, MOVE_SELECT, POKEMON_SELECT, ITEM_SELECT, RUN, DO_MOVE}
var curState = BattleState.STANDBY

var pokeOpp = pokemon_instance.new().default(2)
var pokePlayer = pokemon_instance.new().default(1)

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

const MOVEARROWDEFAULT = Vector2(7, 7)

enum MoveOption {M1, M2, M3, M4}
var moveIndex = MoveOption.M1

func _ready():
	arrow.rect_position.y = ARROWDEFAULT # 13 between select
	moveArrow.rect_position = MOVEARROWDEFAULT
	standByMenu.visible = true
	moveMenu.visible = false
	
	setupPlayer()
	
func setupPlayer():
	$StandbyMenu/MessageBox/StandbyPrompt.text = "What will " + pokePlayer.nick + " do?"
	
	$BattleScreen/PlayPoke/HpProgress/Cvalue.text = str(pokePlayer.chp)
	$BattleScreen/PlayPoke/HpProgress/Mvalue.text = str(pokePlayer.rawstats.hp)
	$BattleScreen/PlayPoke/Name.text = pokePlayer.nick
	$BattleScreen/PlayPoke/Level.text =  str(pokePlayer.level)
	
	$MoveSelectMenu/MoveSelect/MoveBox/Move1.text = pokePlayer.moves["move1"].name
	$MoveSelectMenu/MoveSelect/MoveBox/Move2.text = pokePlayer.moves["move2"].name
	$MoveSelectMenu/MoveSelect/MoveBox/Move3.text = pokePlayer.moves["move3"].name
	$MoveSelectMenu/MoveSelect/MoveBox/Move4.text = "-"
	
	
	
func setupOpp(poke: pokemon_instance):
	pass

func changeArrowPosStandby(index : int ) -> void:
	arrow.rect_position.y =  ARROWDEFAULT + (index % STANDBYOPTIONS) * ARROWSPACING
	standbyIndex = index
	
func changeArrowPosMove(index : int ) -> void:
	var curmove = "move"
	match index:
		MoveOption.M1:
			moveArrow.rect_position = Vector2(7, 7)
			curmove += "1"
		MoveOption.M2:
			moveArrow.rect_position = Vector2(80, 7)
			curmove += "2"
		MoveOption.M3:
			moveArrow.rect_position = Vector2(7, 31)
			curmove += "3"
		MoveOption.M4:
			curmove += "3"
			moveArrow.rect_position = Vector2(80, 31)
			
	$MoveSelectMenu/MoveInfo/MovePP/PPInfo.text = str(pokePlayer.moves[curmove].total_pp) + "/" + str(pokePlayer.moves[curmove].total_pp)
	$MoveSelectMenu/MoveInfo/MoveType/TypeInfo.text = TypeStr.new().toStr(pokePlayer.moves[curmove].type)
		
	
func transistionState(current: int, next: int) -> void:
	match current:
		BattleState.STANDBY:
			standByMenu.visible = false
			standbyIndex = 0
		BattleState.MOVE_SELECT:
			moveMenu.visible = false
			moveIndex = 0
			
	match next:
		BattleState.STANDBY:
			curState = BattleState.STANDBY
			standByMenu.visible = true
		BattleState.MOVE_SELECT:
			curState = BattleState.MOVE_SELECT
			moveMenu.visible = true
			
			
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
				print("Selected option: " + str(standbyIndex))
				match standbyIndex:
					StandbyOption.FIGHT:
						transistionState(BattleState.STANDBY, BattleState.MOVE_SELECT)
						
						$MoveSelectMenu/MoveInfo/MovePP/PPInfo.text = str(pokePlayer.moves["move1"].total_pp) + "/" + str(pokePlayer.moves["move1"].total_pp)
						$MoveSelectMenu/MoveInfo/MoveType/TypeInfo.text = TypeStr.new().toStr(pokePlayer.moves["move1"].type)
					StandbyOption.BAG:
						pass
					StandbyOption.POKEMON:
						pass
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
				print("Executing Move X")
				var themove = "move" + str(moveIndex+1)
				print((pokePlayer.moves[themove].name))
			
