extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player2 = "Tipito"
var player1 = "Sapo"
var explo = preload("res://Scenes/Explo/explo.tscn")

func _ready():
    $Sapo.set_p1()
    $Tipito.set_p2()

func add_explosion(pos):
    var inst = explo.instance()
    inst.position = pos
    inst.playing = true
    add_child(inst)
    
func get_random_playable():
    var playables = get_tree().get_nodes_in_group("playables")
    return playables[randi() % playables.size()]
    
func kill(x):
    add_explosion(x.position)
    x.queue_free()
    
    var node = get_random_playable()
    if x.is_p1:
        node.set_p1()
    else:
        node.set_p2()


func _process(delta):
    if Input.is_action_pressed("ui_space"):
        get_node(player1).deactivate()
        var playables = get_nodes_in_group("playables")
        var node = playables[randi() % playables.size()]
        player1 = node
        get_node(node).set_p1()