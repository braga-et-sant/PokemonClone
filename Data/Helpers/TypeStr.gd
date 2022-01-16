class_name TypeStr

func toStr(type: int) -> String:
	match type:
		Type.NORMAL:
			return "Normal"
		Type.FIGHTING:
			return "Fighting"
		Type.FLYING:
			return "Flying"
		Type.POISON:
			return "Poison"
		Type.GROUND:
			return "Ground"
		Type.ROCK:
			return "Rock"
		Type.BUG:
			return "Bug"
		Type.GHOST:
			return "Ghost"
		Type.STEEL:
			return "Steel"
		Type.UNKNOWN:
			return "Unknown"
		Type.FIRE:
			return "Fire"
		Type.WATER:
			return "Water"
		Type.GRASS:
			return "Grass"
		Type.ELECTRIC:
			return "Electric"
		Type.PSYCHIC:
			return "Psychic"
		Type.ICE:
			return "Ice"
		Type.DRAGON:
			return "Dragon"
		Type.DARK:
			return "Dark"
		Type.FAIRY:
			return "Fairy"
	return "null"
			
