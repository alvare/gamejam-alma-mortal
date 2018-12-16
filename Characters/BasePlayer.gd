extends KinematicBody2D

var speed = 350
var jump_speed = 900
var gravity = 1300

var swim = false
var cont = 0
var text_actual = null
var shield = false
var open_door = false

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

var k_up = ""
var k_right = ""
var k_left = ""
var k_attack = ""
var disabled = true

func _ready():
    set_physics_process(true)
    #set_process(true)
    
func set_p1():
    enable()
    k_up = "ui_up"
    k_right = "ui_right"
    k_left = "ui_left"
    k_attack = "ui_down"
    
func set_p2():
    enable()
    k_up = "ui_w"
    k_right = "ui_d"
    k_left = "ui_a"
    k_attack = "ui_s"
        
func unmap():
    k_up = ""
    k_right = ""
    k_left = ""
    k_attack = ""
    
    
func enable():
    $col.disabled = false
    disabled = false
    
    
func deactivate():
    unmap()
    $col.disabled = true
    disabled = true


func _physics_process(delta):
    if not disabled:
        _move(delta)


func _move(delta):
    direction.x = int(Input.is_action_pressed(k_right))-int(Input.is_action_pressed(k_left))
    
    if direction.y != 0 and swim == false:
        $spr.animation = "jump"
    
    if direction.x != 0 and direction.y == 0 and swim == false and open_door == false:
        $spr.animation = "move"
        $spr.playing = true
        
    elif direction.x == 0 and direction.y == 0 and swim == false and open_door == false:
        $spr.playing = false
        $spr.animation = "default"
    
    if direction.x > 0:
        $spr.flip_h = false
    elif direction.x < 0:
        $spr.flip_h = true
    
    distance.x = speed*delta
    velocity.x = (direction.x*distance.x)/delta
    velocity.y += gravity*delta
    
    move_and_slide(velocity, Vector2(0, -1))
    
    if is_on_floor():
        velocity.y = 0
        direction.y = 0
        
        if Input.is_action_just_pressed(k_up):
            velocity.y = -jump_speed
            direction.y = 1