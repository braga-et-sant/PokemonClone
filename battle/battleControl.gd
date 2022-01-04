extends Control

enum {COMMAND, ACTION, FLEE, WIN, LOSE}
var current_state = COMMAND

var current_round
var queue = []
var current_turn

class Actor:
    var name
    var hp
    var speed
    var attack
    var chp
    
    func _init(name, hp, speed, attack):
        self.name = name
        self.hp = hp
        self.speed = speed
        self.attack = attack
        chp = hp
    
    func _to_string():
        return "Name: %s, HP: %s, Speed: %s, Attack: %s, CurrentHP: %s" % [name, hp, speed, attack, chp]
        
class Move:
    var name
    var damage
    
    func _init(name, damage):
        self.name = name
        self.damage = damage
        
    func _to_string():
        return "Name: %s, Damage: %s" % [name, damage]
        
class MoveQueue:
    var Move
    var actor
    var target
    func _init(Move, actor, target):
        self.Move = Move
        self.actor = actor
        self.target = target
        
class customSorterMoveQueue:
    static func sortBySpeed(a, b):
        if a.actor < b.actor:
            return true
        return false
        
func applyMove(M):
    var damagedone = M.Move.damage + M.actor.attack
    var text = "%s takes %s damage from %s's attack! Leaving him with %s life" % [M.target, damagedone, M.actor, M.target.chp]
    print(text)
    $BattleMenu.queue_text(text)
    #yield(get_tree().create_timer(2), "timeout")
    M.target.chp -= damagedone
    #$BattleMenu.clear_textbox()
    
var player = Actor.new("Player", 40, 5, 7)
var enemy = Actor.new("Enemy", 30, 6, 10)
var move1 = Move.new("Scratch", 10)
var move2 = Move.new("Tackle", 15)

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationSprites.play("idlemeowth")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func executeTurn(queue):
    queue.sort_custom(customSorterMoveQueue, "sortBySpeed")
    for t in queue:
        print("Executing the move:")
        applyMove(t)
        
    print("Turn over")
    if(player.chp <= 0):
        print("Game Over! The player dieded!")
    if(enemy.chp <=0):
        print("Game Over! The enemy dieded!")
        
    
func _on_Move1_pressed():
    print("Executing Move 1")
    var MoveQueueActor = MoveQueue.new(move2, player, enemy)
    var MoveQueueEnemy = MoveQueue.new(move1, enemy, player)
    queue.append(MoveQueueActor)
    queue.append(MoveQueueEnemy)
    executeTurn(queue)


func _on_Move2_pressed():
    print("Move 2 pressed")
