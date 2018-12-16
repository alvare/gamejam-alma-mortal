extends KinematicBody2D

var speed = 350
var jump_speed = 900
var gravity = 1300

var floats = false

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

var k_up = ""
var k_right = ""
var k_down = ""
var k_left = ""
var k_attack = ""

var is_p1

var attacking = false

func _ready():
    set_physics_process(false)
    $spr.connect("animation_finished", self, "_onAnimationEnded")

func _onAnimationEnded():
    if attacking:
        attacking = false
        $attackr/col.disabled = true
        $attackl/col.disabled = true
        if floats:
            $spr.playing = false
            $spr.animation = "default"

func set_p1():
    enable()
    is_p1 = true
    k_up = "ui_up"
    k_right = "ui_right"
    k_down = "ui_down"
    k_left = "ui_left"
    k_attack = "ui_slash"

func set_p2():
    enable()
    is_p1 = false
    k_up = "ui_w"
    k_right = "ui_d"
    k_down = "ui_s"
    k_left = "ui_a"
    k_attack = "ui_q"

func unmap():
    k_up = ""
    k_right = ""
    k_left = ""
    k_attack = ""

    
func enable():
    $col.disabled = false
    set_physics_process(true)
    remove_from_group("playables")
    
    
func deactivate():
    unmap()
    set_physics_process(false)
    $col.disabled = true

func _physics_process(delta):
    if floats:
        _float(delta)
    else:
        _move(delta)

    if Input.is_action_just_pressed(k_attack):
        $spr.animation = "attack"
        $spr.playing = true
        attacking = true
        if not $spr.flip_h:
            $attackr/col.disabled = false
        else:
            $attackl/col.disabled = false


func _move(delta):
    
    if not attacking:
        direction.x = int(Input.is_action_pressed(k_right))-\
                        int(Input.is_action_pressed(k_left))
        if direction.y != 0:
            $spr.animation = "jump"
        
        if direction.x != 0 and direction.y == 0:
            $spr.animation = "move"
            $spr.playing = true
            
        elif direction.x == 0 and direction.y == 0:
            $spr.playing = false
            $spr.animation = "default"
    else:
        var lel
        if not $spr.flip_h:
            lel = $attackr
        else:
            lel = $attackl
        for x in lel.get_overlapping_bodies():
            get_tree().get_root().get_node("level1").kill(x)
        direction.x = 0
    
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
        
        if Input.is_action_just_pressed(k_up) and not attacking:
            velocity.y = -jump_speed
            direction.y = 1
            
func _float(delta):
    
    if not attacking:
        direction.x = int(Input.is_action_pressed(k_right))-\
                        int(Input.is_action_pressed(k_left))
        direction.y = int(Input.is_action_pressed(k_down))-\
                        int(Input.is_action_pressed(k_up))
    else:
        var lel
        if not $spr.flip_h:
            lel = $attackr
        else:
            lel = $attackl
        for x in lel.get_overlapping_bodies():
            get_tree().get_root().get_node("level1").kill(x)
        direction.x = 0
    
    if direction.x > 0:
        $spr.flip_h = false
    elif direction.x < 0:
        $spr.flip_h = true
    
    distance.x = speed*delta
    distance.y = speed*delta
    velocity.x = (direction.x*distance.x)/delta
    velocity.y = (direction.y*distance.y)/delta
    
    move_and_slide(velocity, Vector2(0, 0))