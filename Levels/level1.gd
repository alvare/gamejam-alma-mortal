extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player2 = "Tipito"
var player1 = "Sapo"

func _ready():
    $Sapo.set_p1()
    $Tipito.set_p2()
    
func kill(x):
    print("LEL")
    x.die()

func _process(delta):
    if Input.is_action_pressed("ui_space"):
        get_node(player1).deactivate()
        var playables = get_nodes_in_group("playables")
        var node = playables[randi() % playables.size()]
        player1 = node
        get_node(node).set_p1()