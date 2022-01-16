extends Control


var playerSprite
var oppSprite
	
func setupPlayer(pokePlayer : pokemon_instance) -> void:
	$PlayPoke/HpProgress/Cvalue.text = str(pokePlayer.chp)
	$PlayPoke/HpProgress/Mvalue.text = str(pokePlayer.rawstats.hp)
	$PlayPoke/HpBar.max_value = pokePlayer.rawstats.hp
	$PlayPoke/Name.text = pokePlayer.nick
	$PlayPoke/Level.text =  "Lv " + str(pokePlayer.level)
	
func setupPlayerSprite(pokeSpecies):
	if(playerSprite != null):
		remove_child(playerSprite)
	var filepath = "res://Sprites/Pokemon/Animation/" + pokeSpecies + "/" + pokeSpecies + "Anim.tscn"
	playerSprite = load(filepath).instance()
	playerSprite.flag = 0
	playerSprite.position = ($PlaySprite.position)
	$PlaySprite.visible = false
	add_child(playerSprite)

func setupOpp(pokeOpp : pokemon_instance) -> void:
	$OppPoke/HpProgress/Cvalue.text = str(pokeOpp.chp)
	$OppPoke/HpProgress/Mvalue.text = str(pokeOpp.rawstats.hp)
	$OppPoke/Name.text = pokeOpp.nick
	$OppPoke/Level.text = "Lv " + str(pokeOpp.level)
	$OppPoke/HpBar.max_value = pokeOpp.rawstats.hp
	
func setupOppSprite(pokeSpecies):
	if(oppSprite != null):
		remove_child(oppSprite)
		
	var filepath = "res://Sprites/Pokemon/Animation/" + pokeSpecies + "/" + pokeSpecies + "Anim.tscn"
	oppSprite = load(filepath).instance()
	oppSprite.flag = 1
	oppSprite.position = ($OppSprite.position)
	$OppSprite.visible = false
	add_child(oppSprite)
	
func updateGamestate(pokePlayer, pokeOpp):
	$PlayPoke/HpProgress/Cvalue.text = str(pokePlayer.chp)
	$OppPoke/HpProgress/Cvalue.text = str(pokeOpp.chp)
	$OppPoke/HpBar.value = pokeOpp.chp
	$PlayPoke/HpBar.value = pokePlayer.chp

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
