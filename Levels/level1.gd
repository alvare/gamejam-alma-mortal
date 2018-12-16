extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player2 = "Tipito"
var player1 = "Sapo"
var explo = preload("res://Scenes/Explo/explo.tscn")
var live = preload("res://Scenes/Live/live.tscn")
var p1_lives = []
var p2_lives = []

func _ready():
    randomize()
    $Sapo.set_p1()
    $Tipito.set_p2()
    var lives_left_x = 100
    var lives_right_x = 1650
    for x in range(4):
        p1_lives.append(render_live(100*x + lives_left_x))
        p2_lives.append(render_live(100*x + lives_right_x))

func render_live(x):
    var live_inst = live.instance()
    live_inst.position = Vector2(x,70)
    add_child(live_inst, true)
    return live_inst
    
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
    
    if x.is_p1:
        var live = p1_lives.pop_back()
        live.queue_free()
        print(p1_lives)
    else:
        var live = p2_lives.pop_front()
        live.queue_free()
        print(p2_lives)
    
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