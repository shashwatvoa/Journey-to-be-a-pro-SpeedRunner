extends Label


func _ready():
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self,"position" , Vector2(0 , -60) , 2)
	tween.parallel().tween_property(self, "modulate:a" , 0,2 )
	tween.tween_callback(queue_free)
	
	
	
	
	
	
#In Godot Engine, create_tween() is used to create a new tween. A tween is an interpolation between two values 
#over time. It’s commonly used for smooth animations, transitions, and gradual changes in properties (such as position, scale, or color)
 #of nodes in your game. By creating a tween, you can define how a property should change from its current value to a target value, and the engine 
#will handle the interpolation for you. This makes it easier to create dynamic and visually appealing effects
