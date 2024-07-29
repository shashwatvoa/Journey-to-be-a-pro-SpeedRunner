extends CharacterBody3D

class_name Player

@onready var gun = $gun
@onready var hud = $%HUD
@export var health := 10
@export var firespeed :=0.2
@export var attackPower := 1

var moveSpeed := 4.5
var jumpVelocity := 4.5
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

var regenstamina = false

var lastShot := 0

@onready var staminaRegenTimer = $saminaregen
var bullet = preload("res://bullet.tscn")


func _ready():
	hud.health = health 

func _physics_process(delta):
	if health <= 0 : return
	if not is_on_floor():
		velocity.y -= gravity * delta 
	
	var input_dir = Input.get_vector("ui_left" , "ui_right" , "ui_up" , "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x , 0 , input_dir.y)).normalized() 
	
	velocity.x = direction.x * moveSpeed	
	velocity.z = direction.z * moveSpeed
	
	var landed = is_on_floor()
	var jumping = is_on_floor() and Input.is_action_pressed("jump")
	if jumping:
		velocity.y = jumpVelocity
		
	if velocity.length() > 0.2:
		var moveDirection := Vector2(velocity.z, velocity.x)
		
	move_and_slide()
	
	if regenstamina and hud.stamina <100:
		hud.stamina += 1
		hud.updateHud()

func _fire():
	var now := Time.get_ticks_msec()/1000.0
	if hud.ammo < 1: return
	if now < lastShot + firespeed:return
	
	lastShot = now
	var b = bullet.instantiate()
	b.damage = attackPower
	b.global_transform = gun.global_transform
	get_parent().add_child(b)
	hud.ammo -= 1
	hud.updateHud()
	
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		_fire()
	
	if Input.is_action_just_pressed("run ") and hud.stamina > 0:
		regenstamina = false
		moveSpeed = 5.5
		hud.stamina -= 1
		hud.updateHud() 
	if Input.is_action_just_released("run "):
		moveSpeed = 3.5
		staminaRegenTimer.start()

func gainAmmo(qty):
	hud.ammo += qty
	hud.addUpdate(qty , "Ammo" , Color(0,0,1,1))
	hud.screenGlow(Color(1,0.843137,0,1))
	hud.updateHud()

func gainHealth(qty):
	health -= qty
	hud.health = health
	hud.addUpdate(qty , "Health" , Color(0,1,0,1))
	hud.screenGlow(Color(1,0.843137,0,1))
	hud.updateHud()


func takedamage(qty):
	health -= qty
	hud.health = health
	if health <=0:
		hud.gameOver()
		get_tree().set_pause(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		hud.addUpdate(qty , "Damage" , Color(1,0,0,1))
		hud.screenGlow(Color(1,0,0,0.3))
		hud.updateHud()

func _on_saminaregen_timeout():
	regenstamina = true
