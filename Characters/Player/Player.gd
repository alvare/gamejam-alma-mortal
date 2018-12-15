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

func _ready():
    set_physics_process(true)
    set_process(true)
    
    $spr.frame = 3

func _process(delta):
    if global_var.lives == 0 and global_var.punto != null:
        global_var.lives = 4
        global_position = global_var.punto
    
    if Input.is_action_just_pressed("ui_select") and open_door:
        $spr.animation = "open_door"
        $spr.playing = true
        yield($spr,"animation_finished")
        print("Bien, has pasado el nivel")
        get_tree().quit()
    
    if $time_shield.is_stopped() == false and $spr.self_modulate.a8 != 100:
        $spr.self_modulate.a8 -= 5
    elif $time_shield.is_stopped() and $spr.self_modulate.a8 != 255:
        $spr.self_modulate.a8 += 5
        shield = false

    speed = 350
    jump_speed = 900
    gravity = 1300
    
    if Input.is_action_just_pressed("ui_down"):
        $wepon.attack()

func _physics_process(delta):
    _move(delta)

func _speak(text):
    var container_text = load("res://Text/Label.tscn").instance()
    container_text._text(text)
    add_child(container_text)
    text_actual = container_text

func _move(delta):
    direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
    
    if direction.y != 0 and swim == false:
        $spr.animation = "jump"
    
    if direction.x != 0 and direction.y == 0 and swim == false and open_door == false:
        $spr.animation = "mov"
        $spr.playing = true
        
    elif direction.x == 0 and direction.y == 0 and swim == false and open_door == false:
        $spr.playing = false
        $spr.animation = "stop"
    
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
        
        if Input.is_action_just_pressed("ui_up"):
            velocity.y = -jump_speed
            direction.y = 1