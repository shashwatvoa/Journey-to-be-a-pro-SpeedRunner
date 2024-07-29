extends Camera3D

@export var mouseSensitivity = 0.05
@onready var playerModle = get_parent()

var freeLook = true 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if playerModle.health<= 0 : return
	if event.is_action_pressed("ui_cancel"):
		freeLook = false
		if freeLook == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseMotion and freeLook == true:
		playerModle.rotation_degrees.x -= event.relative.y * mouseSensitivity 
		playerModle.rotation_degrees.x = clamp(playerModle.rotation_degrees.x , -90 , 30.0 )
		playerModle.rotation_degrees.y -= event.relative.x * mouseSensitivity
		#event.relative.y: This represents the relative vertical movement of the mouse (usually obtained from an input event).
		
