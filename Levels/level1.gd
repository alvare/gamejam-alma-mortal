extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player1 = "Player"
var player2 = "Sapo"
var playables = ["Player", "Sapo", "Tipito"]

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    $Player.set_p1()
#    get_node("Sapo").set_p2()
    #$Sapo.set_p2()

func _process(delta):
    if Input.is_action_pressed("ui_space"):
        get_node(player1).deactivate()
        var node = playables[randi() % playables.size()]
        player1 = node
        get_node(node).set_p1()