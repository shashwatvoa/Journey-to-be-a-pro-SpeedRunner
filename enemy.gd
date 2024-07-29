extends CharacterBody3D

@export var PlayerPath : NodePath
@export var color : Color 
@export var aggroRange := 20.0 
@export var fireSpeed := 0.2
@export var attackPower := 1

var health = 20 
var material 
var player = null 
var bullet = preload("res://bullet.tscn")

@onready var gun =  $gun
@onready var nav = $NavigationAgent3D
@onready var sight = $sight
@onready var engagedTimer = $engage

var lastShot := 0.0
var speed := 1.0

var startPos 
var engaged = false

func _ready():
	player = get_node(PlayerPath)
	startPos = global_position
	var mat = StandardMaterial3D.new()
	mat.set_albedo(color)
	mat.emission_enabled = true
	$%body.set_surface_override_material(0,mat)
	$%nose.set_surface_override_material(0,mat)
	material = mat

func takedamage(dmg):
	health -= dmg
	engaged = true
	engagedTimer.start()
	if health < 1:
		queue_free()
	var tween = get_tree().create_tween()
	tween.tween_property(material, "emission" ,Color(2,1,1,1) , 0.02 )
	tween.tween_property(material, "emission" ,Color(0,0,0,1) , 0.2 )
	
func _fire():
	var now := Time.get_ticks_msec()/1000.0
	if now < lastShot + fireSpeed:return
	
	lastShot = now 
	var b = bullet.instantiate()
	b.damage = attackPower
	b.global_transform = gun.global_transform
	get_parent().add_child(b)

func _process(delta):
	velocity = Vector3.ZERO
	if global_position.distance_to(player.global_position) < aggroRange and player.health > 0 or engaged:
		nav.set_target_position(player.global_transform.origin)
		if sight.get_collider() is Player:
			_fire()
		look_at(Vector3(player.global_position.x , player.global_position.y , player.global_position.z), Vector3.UP)
	elif global_position.distance_to(startPos)>5:
		nav.set_target_position(startPos)
		look_at(Vector3(startPos.x , startPos.y , startPos.z ),Vector3.UP)

	var nextPos = nav.get_next_path_position()
	
	velocity = (nextPos - global_transform.origin).normalized()
	
	move_and_slide()

func _on_engage_timeout():
	engaged = false
