@icon("res://assets/goog.jpg")
extends Area2D

var e = 0
var smod = 0
@onready var goog = $Goog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	e += delta
	smod *= 0.95
	goog.skew = deg_to_rad(cos(e*1.0*(1.5*smod+1)) * 5 * (10*smod+1))
	goog.scale = Vector2((sin(e)*0.025+0.225)+smod,(cos(e)*0.025+0.225)-smod*0.5)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		smod = 0.2
		$Aura.play()
