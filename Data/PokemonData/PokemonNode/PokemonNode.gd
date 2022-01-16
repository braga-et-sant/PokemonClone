extends Object

# The name of the pokemon
var name 

# Pokedex ID
var ID

#Path to the sprite scene
var spritenode

# The pokemon's type. If only one type use type1
var type1 
var type2

# The pokemon's base stats (HP,Attack,Defense,Sp.Atack,Sp.Def,Speed)
var hp
var attack
var defense
var sp_attack
var sp_defense
var speed

# The pokemon's public and hidden abilities
var ability
var hidden_ability

# The pokemon's Effort Value Yeild
var ev_yield_hp 
var ev_yield_attack 
var ev_yield_defense 
var ev_yield_sp_attack 
var ev_yield_sp_defense 
var ev_yield_speed 

# The pokemon's base experience yield when defeated
var exp_yield

# The pokemon's leveling rate
var leveling_rate
enum {SLOW, MEDIUM_SLOW, MEDIUM_FAST, FAST, ERRATIC, FLUCTUATING}

# The pokemon's gender ratio male percentage.
var male_ratio

# The pokemon's evolution level
var evolution_level

# The pokemon's evolution ID
var evolution_ID

# The pokemon's catch rate
var catch_rate 

# Weight in kg
var weight

# Moveset by leveling
var movelist = []

var moveset = [
	MoveSet.new(1, "Ice Beam"),
	MoveSet.new(1, "Hydro Pump"),
	MoveSet.new(1, "Ember"),
	MoveSet.new(1, "Thunder Shock"),
]
