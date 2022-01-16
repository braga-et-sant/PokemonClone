extends Object

# The name of the pokemon
var name = "Farfetchd"

# Pokedex ID#
var ID = 4

var spritenode = "res://sprites/Pokemon/Farfetchd.tscn"

# The pokemon's type. If only one type use type1
var type1 = Type.WATER
var type2 = Type.FLYING

# The pokemon's base stats (HP,Attack,Defense,Sp.Atack,Sp.Def,Speed)
var hp = 95
var attack = 125
var defense = 79
var sp_attack = 60
var sp_defense = 100
var speed = 81

# The pokemon's public and hidden abilities
var ability = "lol"
var hidden_ability

# The pokemon's Effort Value Yeild
var ev_yield_hp = 0
var ev_yield_attack = 2
var ev_yield_defense = 0
var ev_yield_sp_attack = 0
var ev_yield_sp_defense = 0
var ev_yield_speed = 0

# The pokemon's base experience yield when defeated
var exp_yield : int = 189

# The pokemon's leveling rate
var leveling_rate = LevelingRate.SLOW

# The pokemon's gender ratio male percentage.
var male_ratio = 50

# The pokemon's evolution level
var evolution_level

# The pokemon's evolution ID
var evolution_ID

# The pokemon's catch rate
var catch_rate = 45

# Weight in kg
var weight = 235.0

# Moveset by leveling
var moveset = [
	MoveSet.new(1, "Ice Beam"),
	MoveSet.new(1, "Hydro Pump"),
	MoveSet.new(1, "Ember"),
	MoveSet.new(1, "Thunder Shock"),
]
