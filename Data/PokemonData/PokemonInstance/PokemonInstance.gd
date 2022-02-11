extends Object
class_name pokemon_instance

var ID
var OT
var nick
var ability
var nature
var metat
var gender
var held
var totexp
var chp
var status
var type1
var type2
var level

enum stat_types {ATTACK, DEFENSE, SP_ATTACK, SP_DEFENSE, SPEED}

var moves = {"move1": null, "move2": null, "move3":null, "move4":null}
var rawstats = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
var evs = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
var ivs = {"hp":0, "atk":0, "def":0, "spd":0, "spa":0, "spe": 0}
	
func genWild(poke_n : int) -> pokemon_instance:
	var regist = registry.new()
	var poke = regist.get_pokemon_class(poke_n)
	ID = poke.ID
	OT = ""
	nick = poke.name
	ability = poke.ability
	type1 = poke.type1
	type2 = poke.type2
	
	randomize()
	level = randi()%10+1
	nature = randi()%25+1
	
	rawstats = genStats(poke, evs, ivs, level, nature)
	
	chp = rawstats["hp"]
	
	moves = makeMoveList(poke)
	return self
	

func genStats(poke, evs, ivs, level, nature):
	var naturemod 
	
	var genhp = ((2 * poke.hp + ivs["hp"] + evs["hp"] * level)/100) + level + 10
	
	naturemod = Nature.get_stat_multiplier(nature, stat_types.ATTACK)
	var genatk = (((2 * poke.attack + ivs["atk"] + evs["atk"] * level)/100) + 5) * naturemod
	
	naturemod = Nature.get_stat_multiplier(nature, stat_types.DEFENSE)
	var gendef = (((2 * poke.defense + ivs["def"] + evs["def"] * level)/100) + 5) * naturemod
	
	naturemod = Nature.get_stat_multiplier(nature, stat_types.SP_ATTACK)
	var genspa = (((2 * poke.sp_attack + ivs["spa"] + evs["spa"] * level)/100) + 5) * naturemod
	
	naturemod = Nature.get_stat_multiplier(nature, stat_types.SP_DEFENSE)
	var genspd = (((2 * poke.sp_defense + ivs["spd"] + evs["spd"] * level)/100) + 5) * naturemod
	
	naturemod = Nature.get_stat_multiplier(nature, stat_types.SPEED)
	var genspe = (((2 * poke.speed + ivs["spe"] + evs["spe"] * level)/100) + 5) * naturemod
	
	return {"hp":genhp, "atk":genatk, "def":gendef, "spd":genspd, "spa":genspa, "spe": genspe}
	
	
func makeMoveList(poke):
	var moveDb = MoveDataBase.new()
	var learnset = poke.moveset
	var limit = level
	var movelistcur = []
	var mindex = 0
	for m in learnset:
		if(m.level <= limit):
			movelistcur.insert(mindex, moveDb.get_move_by_name(m.move))
			mindex = mindex+1 if (mindex < 3) else 0 
		else:
			break;
			
	while movelistcur.size() < 4:
		movelistcur.append(moveDb.get_move_by_name("Ice Beam"))
	return movelistcur

func _to_string():
	var p1 =  "" + str(ID) + "|" + OT + "|" + nick + "|" + ability + "|" + nature  + "|" + held  + "|" \
	 + metat  + "|" + gender + "|" + str(totexp)  + "|" + str(chp)  + "|" + status  + "|" + "\nMoves:\n"
	var p2 = str(moves)
	var p3 = str(rawstats)
	var p4 = str(evs)
	var p5 = str(ivs)
	return p1 + p2 + "\nRawStats\n" + p3 + "\nEVs\n" + p4 + "\nIVs\n" + p5
